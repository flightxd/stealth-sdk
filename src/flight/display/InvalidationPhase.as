/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * Internal class for exclusive use with Invalidation, representing a phase
	 * of invalidation such as "measure", "layout or "draw" and storing
	 * invalidated targets until validate is called.
	 */
	internal class InvalidationPhase
	{
		/**
		 * An Array of registered phases ordered by priority from highest to
		 * lowest.
		 */
		public static var phaseList:Array = [];

		/**
		 * Phase lookup by phase name, for convenience.
		 */
		public static var phaseIndices:Object = {};
		
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
		public static function registerPhase(phaseName:String, eventType:Class = null, priority:int = 0, ascending:Boolean = true):Boolean
		{
			var invalidationPhase:InvalidationPhase = phaseList[phaseIndices[phaseName]];
			if (!invalidationPhase) {
				invalidationPhase = new InvalidationPhase(phaseName, eventType);
				phaseList.push(invalidationPhase);									// keep track of phases in both ordered phaseList and the phaseIndeces index lookup
			} else if (invalidationPhase.priority == priority &&
					   invalidationPhase.ascending == ascending) {
				return false;
			}
			
			invalidationPhase.priority = priority;
			invalidationPhase.ascending = ascending;
			phaseList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);			// always maintain order - phases shouldn't be registered often
			for (var i:int = 0; i < phaseList.length; i++) {						// adjust phaseIndeces with a new phase or order
				phaseIndices[phaseList[i].name] = i;
			}
			return true;
		}
		
		/**
		 * Order of execution in display-list hierarchy, where ascending is from
		 * child to parent up the display list until the stage is reached.
		 */
		public var ascending:Boolean = false;
	
		/**
		 * The priority of this phase relating to other invalidation phases.
		 */
		public var priority:int = 0;
	
		/**
		 * The event class instantiated for dispatch from invalidation targets.
		 */
		public var eventType:Class;
	
		/**
		 * Flag indicating whether there have been any invalidation targets
		 * added since last validation.
		 */
		public var invalidated:Boolean;
		
		/**
		 * List of dictionaries storing invalidation targets, indexed by level.
		 */
		private var levels:Array = [];
		
		/**
		 * Quick reference with invalidated targets as key and value as level.
		 */
		private var invalidTargets:Dictionary = new Dictionary(true);
	
		/**
		 * Rotating dictionary, always 1 empty dictionary to be put in place of
		 * the current level's dictionary, rotating into the levels array while
		 * current targets are taken out.
		 */
		private var emptyTargets:Dictionary = new Dictionary(true);
	
		/**
		 * Current level being executed, or -1 when not running.
		 */
		private var currentLevel:int = -1;
	
		/**
		 * Constructor requiring phase name also used as event type, and
		 * optionally the class used for event instantiation.
		 * 
		 * @param name			Phase name, also the event type.
		 * @param eventType		Event class used when dispatching from
		 * 						invalidation targets.
		 */
		public function InvalidationPhase(name:String, eventType:Class = null)
		{
			_name = name;
			this.eventType = eventType || Event;
		}
	
		/**
		 * Phase name, also used as the event type.
		 */
		public function get name():String { return _name; }
		private var _name:String;
	
		/**
		 * Execution of the phase by dispatching an event from each target, in order
		 * ascending or descending by level. Event type and class correlate with
		 * phase name and eventType respectively.
		 * 
		 * @param target		Optional target may be specified for isolated
		 * 						validation. If null, full validation is run on
		 * 						all targets in proper level order.
		 */
		public function validate(target:IEventDispatcher = null):void
		{
			if (target) {													// skip full validation and run only on specified target
				if (remove(target)) {
					target.dispatchEvent(new eventType(_name));
				}
				return;
			} else if (!invalidated) {
				return;
			}
			
			invalidated = false;
			var i:int;
			if (ascending) {
				for (i = levels.length - 1; i > 0; i--) {
					validateLevel(i);
				}
			} else {
				for (i = 1; i < levels.length; i++) {
					validateLevel(i);
				}
			}
			
			currentLevel = -1;														// reset current level indicator when not in use
		}

		/**
		 * Validates level specified, executing the phase by dispatching an
		 * event from each target. Event type and class correlate with phase
		 * name and eventType respectively.
		 * 
		 * @param level			The current level being validated.
		 */
		private function validateLevel(level:int):void
		{
			if (levels[level]) {
				currentLevel = level;
				var currentTargets:Dictionary = levels[level];						// retrieve current level's dictionary for target iteration and replace it 
				levels[level] = emptyTargets;										// with a clean one, allowing for invalidation to occur on this level
																					// to be resolved with the next validation call
				
				for (var key:Object in currentTargets) {							// targets stored as keys remain weak-referenced and can be garbage collected
					delete currentTargets[key];
					delete invalidTargets[key];
					IEventDispatcher(key).dispatchEvent(new eventType(_name));
				}
				emptyTargets = currentTargets;										// current level's dictionary has now been emptied
			}
		}
	
		/**
		 * Effectively invalidates target with this phase.
		 * 
		 * @param target		Target to be invalidated.
		 * @param level			Level in display-list hierarchy.
		 * @return				Returns true the first time target is
		 * 						invalidated.
		 */
		public function add(target:IEventDispatcher, level:int = 1):Boolean
		{
			if (invalidTargets[target] === level) {
				return false;														// already invalidated
			} else if (invalidTargets[target] !== undefined) {						// invalidated, but at a different level, so clear and re-invalidate
				delete levels[invalidTargets[target]][target];
			}
			
			if (levels[level] == null) {
				levels[level] = new Dictionary(true);								// once a level is assigned a dictionary it will always have a dictionary
			}
			levels[level][target] = true;											// store target in both the level and the quick reference
			invalidTargets[target] = level;
			
			if (currentLevel == -1 ||
				(ascending && level >= currentLevel) ||								// targets invalidated in a level soon-to-be executed do not flag an invalid phase
				(!ascending && level <= currentLevel)) {
				invalidated = true;
			}
			return true;
		}
	
		/**
		 * Removes a target from invalidation without executing validation.
		 * 
		 * @param target		Target to be removed, reversing invalidation.
		 * @return				Returns true if the target was previously
		 * 						invalidated.
		 */
		public function remove(target:IEventDispatcher):Boolean
		{
			if (invalidTargets[target] === undefined) {
				return false;
			}
			var level:int = invalidTargets[target];
			delete levels[level][target];
			delete invalidTargets[target];
			return true;
		}
		
		public function contains(target:IEventDispatcher):Boolean
		{
			return invalidTargets[target] !== undefined;
		}
	}
}
