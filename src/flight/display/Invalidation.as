/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import flight.utils.callLater;
	import flight.utils.getClassName;

	/**
	 * The Invalidation utility allows potentially expensive processes, such as
	 * layout, to delay their execution and run just once before the screen is
	 * rendered. In the case of layout this delayed execution is a performance
	 * necessity, because the size and position of display objects can directly
	 * effect each other, through all levels of the display-list.
	 * 
	 * Invalidation runs in ordered execution by level and depth and supports
	 * any number of custom phases. For example, the "commit" phase will run
	 * through the entire display list, starting with the stage and moving down
	 * to each invalidated child, dispatching an <code>InvalidationEvent</code>
	 * of type "commit". Later, in its own pass, the "layout" phase will run
	 * through the display list dispatching a <code>LayoutEvent</code> from
	 * display objects that have been invalidated by this phase. All
	 * invalidation happens via these custom phases which must be registered
	 * before use. A small set of known phases should be documented and
	 * maintained on their related <code>Event</code> class.
	 * 
	 * Invalidation is tied to the display list and supports multiple stages.
	 * Processes unrelated to rendering can be deferred via the package-level
	 * method <code>callLater()</code>.
	 * 
	 * @see flight.utils#callLater()
	 */
	public class Invalidation
	{
		/**
		 * Internal weak-reference registry of all display objects initialized
		 * by Invalidation, including stages.
		 */
		private static var initialized:Dictionary = new Dictionary(true);
		
		/**
		 * Internal weak-referenced registry of invalidated stages.
		 */
		private static var invalidStages:Dictionary = new Dictionary(true);
		
		/**
		 * An Array of registered phases ordered by priority from highest to
		 * lowest.
		 */
		private static var phases:Array = [];
		
		/**
		 * Phase lookup by phase name, for convenience.
		 */
		private static var lookup:Object = {};
		
		/**
		 * Phases of invalidation such as "measure", "layout" and "draw" allow
		 * different systems to register their own pass over the display-list
		 * independent of any other system. Phases are ordered by priority and
		 * marked as ascending (execution of child then parent) or descending
		 * (from parent to child). Though phases run in the same render cycle
		 * they are independent from each other and must be invalidated
		 * independently. Finally, each phase supports a unique event dispatched
		 * from the display object which is how systems such as layout execute.
		 * 
		 * For example:
		 * <code>
		 *     // phases only need to be registered once
		 *     Invalidation.registerPhase(LayoutEvent.MEASURE, LayoutEvent, 100);
		 *     
		 *     // invalidate/listen on display objects wanting to support measurement
		 *     Invalidation.invalidate(sprite, LayoutEvent.MEASURE);
		 *     sprite.addEventListener(LayoutEvent.MEASURE, onMeasure);
		 *     
		 *     function onMeasure(event:LayoutEvent):void
		 *     {
		 *         // run measurement code on event.target (the invalidated display object)
		 *     }
		 * </code>
		 * 
		 * @param phaseName		The name by which objects are invalidated and
		 * 						the event type dispatched on their validation.
		 * @param eventType		The event class created and dispatched on
		 * 						validation.
		 * @param priority		Phase priority relating to other phases, where
		 * 						higher priority runs validation first.
		 * @param ascending		Determines order of execution within the phase
		 * 						with ascending from child to parent.
		 * @return				Returns true if phase was successful registered
		 * 						for the first time, or re-registered with new
		 * 						priority/ascending settings.
		 */
		public static function registerPhase(phaseName:String, eventType:Class = null, priority:int = 0, ascending:Boolean = false):Boolean
		{
			var phase:Invalidation = lookup[phaseName];
			if (!phase) {
				phase = new Invalidation(phaseName, eventType, ascending);
				phases.push(phase);													// keep track of phases in both ordered phases and the lookup
				lookup[phase._name] = phase;
			} else if (phase.priority == priority) {
				return false;
			}
			
			phase.priority = priority;
			phases.sortOn("priority", Array.DESCENDING | Array.NUMERIC);			// always maintain order - phases shouldn't be registered often
			return true;
		}

		/**
		 * Marks a target for delayed execution in the specified phase, to
		 * execute just once this render cycle regardless of the number times
		 * invalidate is called. Phase "execution" is carried out through an
		 * event of type phaseName dispatched from the target, and can be
		 * listened to by anyone.
		 * 
		 * @param target		The DisplayObject or display object to be
		 * 						invalidated.
		 * @param phaseName		The phase to be invalidated by, and the event
		 * 						type dispatched on resolution.
		 * @return				Returns true if the target was invalidated for
		 * 						the first time this render cycle.
		 */
		public static function invalidate(target:DisplayObject, phaseName:String):Boolean
		{
			var phase:Invalidation = lookup[phaseName];
			if (!phase) {
				throw new Error(getClassName(target) + " cannot be invalidated by unknown phase '" + phaseName + "'.");
			}
			
			if (phase.invalidate(target)) {
				invalidateStage(target.stage);
				return true;
			}
			return false;
		}
		
		public static function initialize(target:DisplayObject):void
		{
			if (!initialized[target]) {														// setup listeners only once on each unique target
				initialized[target] = true;
				
				if (target is Stage) {
					target.addEventListener(Event.RENDER, onRender, false, -10, true);		// listen to ALL stage render events, also a permanent listener since they only get
																							// dispatched with a stage.invalidate and add/remove listeners costs some in performance
					target.addEventListener(Event.RESIZE, onRender, false, -10, true);		// in many environments render and enterFrame events stop firing when stage is resized -
																							// listening to resize compensates for this shortcoming and continues to run validation
					invalidStages[target] = false;											// with each screen render
				} else {
					target.addEventListener(Event.ADDED, onAdded, false, 20, true);			// watch for level changes - this is a permanent listener since these changes happen
																							// less frequently than invalidation and so require fewer level calculations
					if (target.stage) {
						initialize(target.stage);
					} else {
						target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
					}
				}
			}
		}

		/**
		 * Most often internally invoked with the render cycle, validate runs
		 * each phase of invalidation by priority and level. A specific target
		 * and phase may be validated manually independent of the render cycle. 
		 * 
		 * @param target		Optional invalidated target to be resolved. If
		 * 						null, full validation cycle is run.
		 * 						are resolved.
		 * @param phaseName		Optional invalidation phase to run. If null, all
		 * 						phases will be run in order of priority.
		 */
		public static function validateNow(target:DisplayObject = null, phaseName:String = null):void
		{
			if (phaseName) {
				var phase:Invalidation = lookup[phaseName];
				if (!phase) {
					throw new Error(getClassName(target) + " cannot be validated by unknown phase '" + phaseName + "'.");
				}
				phase.validateNow(target);
			} else {
				for each (phase in phases) {
					phase.validateNow(target);
				}
			}
		}

		/**
		 * Listener responding to both render and stage resize events.
		 */
		private static function onRender(event:Event):void
		{
			var stage:Stage = Stage(event.currentTarget);
			if (invalidStages[stage]) {
				invalidStages[stage] = false;
				validateNow(stage);
				delete invalidStages[stage];
			}
		}

		/**
		 * Listener responding to any previously invalidated display objects
		 * being added to the display-list, calculating their level (depth
		 * in display-list hierarchy).
		 */
		private static function onAdded(event:Event):void
		{
			if (event.target == event.currentTarget) {
				var target:DisplayObject = DisplayObject(event.currentTarget);
				var invalid:Boolean = false;
																					// correctly invalidate newly added display object on all phases
				for each (var phase:Invalidation in phases) {						// where it was invalidated while off of the display-list (and set at level -1)
					if (phase.invalid[target]) {
						phase.invalid[target] = false;
						phase.invalidate(target);
						invalid = true;
					}
				}
				if (invalid) {
					invalidateStage(target.stage);
				}
			}
		}
		
		private static function invalidateStage(stage:Stage):void
		{
			if (stage) {
				if (!invalidStages[stage]) {
					stage.invalidate();
					invalidStages[stage] = true;
				} else if (invalidStages[stage] != null) {
					callLater(invalidateStage, arguments);
				}
			}
		}
		
		private static function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initialize(target.stage);
		}
		
		/**
		 * The priority of this phase relating to other invalidation phases.
		 */
		public var priority:int = 0;
		
		/**
		 * The event class instantiated for dispatch from invalidation targets.
		 */
		public var eventType:Class;
		
		public var ascending:Boolean;
		
		/**
		 * Quick reference with invalidated targets as key and value as level.
		 */
		private var invalid:Dictionary = new Dictionary(true);
		
		/**
		 */
		private var invalidContent:Dictionary = new Dictionary(true);
		
		private var indices:Dictionary = new Dictionary(true);
		
		/**
		 * Constructor requiring phase name also used as event type, and
		 * optionally the class used for event instantiation.
		 * 
		 * @param name			Phase name, also the event type.
		 * @param eventType		Event class used when dispatching from
		 * 						invalidation targets.
		 */
		public function Invalidation(name:String, eventType:Class = null, ascending:Boolean = false)
		{
			_name = name;
			this.eventType = eventType || Event;
			this.ascending = ascending;
		}
		
		/**
		 * Phase name, also used as the event type.
		 */
		public function get name():String { return _name; }
		private var _name:String;
		
		
		/**
		 * Effectively invalidates target with this phase.
		 * 
		 * @param target		Target to be invalidated.
		 * @return				Returns true the first time target is
		 * 						invalidated.
		 */
		public function invalidate(target:DisplayObject):Boolean
		{
			if (!target || invalid[target]) {
				return false;
			}
			
			invalid[target] = true;
			
			var parent:DisplayObjectContainer = target.parent;
			while (parent && !invalidContent[parent]) {
				invalidContent[parent] = true;
				parent = parent.parent;
			}
			
			return true;
		}
		
		/**
		 * Execution of the phase by dispatching an event from each target, in order
		 * ascending or descending by level. Event type and class correlate with
		 * phase name and eventType respectively.
		 * 
		 * @param target		Optional target may be specified for isolated
		 * 						validation. If null, full validation is run on
		 * 						all targets in proper level order.
		 */
		public function validateNow(target:DisplayObject):void
		{
			var current:DisplayObjectContainer;
			var next:DisplayObject;
			
			// flattened recursive process to maintain a shallow stack
			if (ascending) {
				
				if (invalidContent[target]) {
					current = DisplayObjectContainer(target);
					indices[current] = 0;
					
					while (current) {
						
						next = indices[current] < current.numChildren ? current.getChildAt(indices[current]++) : null;
						if (next) {
							if (invalidContent[next]) {
								delete invalidContent[next];
								
								current = DisplayObjectContainer(next);
								indices[current] = 0;
							} else if (invalid[next]) {
								delete invalid[next];
								next.dispatchEvent(new eventType(_name));
							}
						} else {
							if (invalid[current]) {
								delete invalid[current];
								current.dispatchEvent(new eventType(_name));
							}
							delete indices[current];
							current = current != target ? current.parent : null;
						}
					}
					
					delete invalidContent[target];
				} else if (invalid[target]) {
					delete invalid[target];
					target.dispatchEvent(new eventType(_name));
				}
				
			} else {
				
				if (invalid[target]) {
					delete invalid[target];
					target.dispatchEvent(new eventType(_name));
				}
				
				if (invalidContent[target]) {
					current = DisplayObjectContainer(target);
					indices[current] = 0;
					delete invalidContent[current];
					
					while (current) {
						
						next = indices[current] < current.numChildren ? current.getChildAt(indices[current]++) : null;
						if (next) {
							
							if (invalid[next]) {
								delete invalid[next];
								next.dispatchEvent(new eventType(_name));
							}
							
							if (invalidContent[next]) {
								delete invalidContent[next];
								
								current = DisplayObjectContainer(next);
								indices[current] = 0;
							}
						} else {
							delete indices[current];
							current = current != target ? current.parent : null;
						}
					}
				}
				
			}
		}
	}
}
