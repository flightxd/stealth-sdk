/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import flight.utils.callLater;
	import flight.utils.getClassName;

	/**
	 * The Invalidation utility allows potentially expensive processes, such as
	 * layout, to delay their execution and runs these processes just once each
	 * time the screen is rendered. In the case of layout this delayed execution
	 * is essential, because size and position of parents affect the size and
	 * position of their children and vice versa, through all levels of the
	 * display-list. Invalidation runs in ordered execution by level and
	 * supports any number of custom phases (it is recommended to maintain a
	 * small set of known phases for performance and approachability).
	 */
	public class Invalidation
	{
		/**
		 * Flag indicating whether stages have been invalidated since last
		 * validation.
		 */
		private static var invalidated:Boolean;
		
		/**
		 * Represents the current phase being rendered or validated. Used only
		 * when invalidation is currently running under a "render" event
		 * dispatched from Stage.
		 */
		private static var renderIndex:int = int.MAX_VALUE;

		/**
		 * Internal weak-referenced registry of all stages that have touched
		 * invalidation, to allow one-time setup on each of these stages.
		 */
		private static var stages:Dictionary = new Dictionary(true);

		/**
		 * Internal weak-referenced registry of the levels (depth in hierarchy
		 * from the stage down, with stage being 1, root 2, etc) of all display
		 * objects currently invalidated.
		 */
		private static var displayLevels:Dictionary = new Dictionary(true);

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
			return InvalidationPhase.registerPhase(phaseName, eventType, priority, ascending);
		}

		/**
		 * Marks a target for delayed execution in the specified phase, to
		 * execute just once this render cycle regardless of the number times
		 * invalidate is called. Phase "execution" is carried out through an
		 * event of type phaseName dispatched from the target, and can be
		 * listened to by anyone.
		 * 
		 * @param target		The IEventDispatcher or display object to be
		 * 						invalidated.
		 * @param phaseName		The phase to be invalidated by, and the event
		 * 						type dispatched on resolution.
		 * @param level			Optional level supplied for IEventDispatchers.
		 * 						Display objects' level is calculated internally.
		 * @return				Returns true if the target was invalidated for
		 * 						the first time this render cycle.
		 */
		public static function invalidate(target:IEventDispatcher, phaseName:String, stage:Stage = null, level:int = 1):Boolean
		{
			var phaseIndex:int = InvalidationPhase.phaseIndices[phaseName];
			var invalidationPhase:InvalidationPhase = InvalidationPhase.phaseList[phaseIndex];
			
			if (!target) {
				return false;
			} else if (!invalidationPhase) {
				throw new Error(getClassName(target) + " cannot be invalidated by unknown phase '" + phaseName + "'.");
			}
			
			if (target is DisplayObject) {
				if (invalidationPhase.contains(target)) {
					return false;
				} else if (!displayLevels[target]) {																	// setup listeners only once on a display object
					target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 20, true);				// watch for level changes - this is a permanent listener since these changes happen
					target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 20, true);		// less frequently than invalidation and so require fewer level calculations
				}
				
				stage = DisplayObject(target).stage;
				level = displayLevels[target] || getDisplayLevel(DisplayObject(target));						// retrieve level (depth in hierarchy) for proper ordering
			}
			
			if (stage) {
				if (!stages[stage]) {
					stage.addEventListener(Event.RENDER, onRender, false, -10, true);							// listen to ALL stage render events, also a permanent listener since they only get
																												// dispatched with a stage.invalidate and add/remove listeners costs some in performance
					stage.addEventListener(Event.RESIZE, onRender, false, -10, true);							// in many environments render and enterFrame events stop firing when stage is resized -
																												// listening to resize compensates for this shortcoming and continues to run validation
					stages[stage] = true;																		// with each screen render
				}
				
				var added:Boolean = invalidationPhase.add(target, level);
				if (!invalidated && phaseIndex <= renderIndex && invalidationPhase.invalidated) {
					
					invalidated = true;
					if (renderIndex == int.MAX_VALUE) {								// renderIndex reflects the current phase being invalidated, or MAX_VALUE
						stage.invalidate();
					} else {														// stage.invalidate can't be called in the middle of a render cycle -
						callLater(stage.invalidate);								// it just doesn't work. Note that this delayed stage invalidation
																					// isn't always utilized because phases are smart enough to include
																					// targets of yet un-executed levels in the current render cycle.
					}
				}
				return added;
			} else {
				return invalidationPhase.add(target, -1);							// keep a reference to invalidated targets on the phase, but stored at
																					// a level that won't be executed until display is addedToStage
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
		public static function validateNow(target:IEventDispatcher = null, phaseName:String = null):void
		{
			var invalidationPhase:InvalidationPhase;
			if (phaseName && InvalidationPhase.phaseIndices[phaseName] == null) {
				throw new Error(getClassName(target) + " cannot be validated by unknown phase '" + phaseName + "'.");
			} else if (phaseName) {
				invalidationPhase = InvalidationPhase.phaseList[InvalidationPhase.phaseIndices[phaseName]];
				invalidationPhase.validate(target);
			} else {
				for each (invalidationPhase in InvalidationPhase.phaseList) {
					invalidationPhase.validate(target);
				}
			}
		}

		/**
		 * Calculates the level in display-list hierarchy of target display
		 * object, where stage is level 1, children of stage are level 2, their
		 * children are level 3 and so on.
		 * 
		 * @param target		Display object residing in the display-list.
		 * @return				Hierarchical level as an integer.
		 */
		private static function getDisplayLevel(target:DisplayObject):int
		{
			var level:int = 1;														// start with level 1, stage, which has no parent
			var display:DisplayObject = target;
			while ((display = display.parent)) {
				if (displayLevels[display]) {										// shortcut when parent level is already defined - used often
					level += displayLevels[display];								// because addedToStage resolves for parents before children
					break;
				}
				++level;
			}
			return displayLevels[target] = level;									// assign in a global index and return
		}

		/**
		 * Listener responding to both render and stage resize events.
		 */
		private static function onRender(event:Event):void
		{
			if (invalidated) {
				invalidated = false;
				for (renderIndex = 0; renderIndex < InvalidationPhase.phaseList.length; renderIndex++) {
					InvalidationPhase.phaseList[renderIndex].validate();
				}
				renderIndex = int.MAX_VALUE;
			}
		}

		/**
		 * Listener responding to any previously invalidated display objects
		 * being added to the display-list, calculating their level (depth
		 * in display-list hierarchy).
		 */
		private static function onAddedToStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			var level:int = getDisplayLevel(target);
			
			var phaseList:Array = InvalidationPhase.phaseList;						// correctly invalidate newly added display object on all phases
			for each (var renderPhase:InvalidationPhase in phaseList) {				// where it was invalidated while off of the display-list (and set at level -1)
				if (renderPhase.contains(target)) {
					renderPhase.remove(target);
					invalidate(target, renderPhase.name, target.stage, level);
				}
			}
		}

		/**
		 * Listener responding to any previously invalidated display objects
		 * being removed from the display-list, deleting their level (depth
		 * in display-list hierarchy).
		 */
		private static function onRemovedFromStage(event:Event):void
		{
			var target:DisplayObject = DisplayObject(event.target);
			displayLevels[target] = -1;
			
			var phaseList:Array = InvalidationPhase.phaseList;						// remove display object from proper invalidation and add it at level -1
			for each (var renderPhase:InvalidationPhase in phaseList) {				// where it won't be executed until added to display-list again
				if (renderPhase.contains(target)) {
					renderPhase.remove(target);
					renderPhase.add(target, -1);
				}
			}
		}
	}
}
