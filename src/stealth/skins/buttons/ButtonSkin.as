/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.skins.buttons
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.filters.GlowFilter;
	import flight.states.Change;
	import flight.states.State;

	import stealth.containers.DockGroup;
	import stealth.graphics.GraphicText;
	import stealth.graphics.Group;
	import stealth.graphics.paint.GradientEntry;
	import stealth.graphics.paint.LinearGradient;
	import stealth.graphics.shapes.Rect;
	import stealth.layouts.Align;
	import stealth.layouts.HorizontalLayout;
	import stealth.skins.Skin;
	import stealth.skins.Theme;

	public class ButtonSkin extends Skin
	{
		Theme.registerSkin(ButtonSkin);
		
		public var focused:Boolean;
		public var defaultButton:Boolean;
		
		public var background:DockGroup;
		protected var surface:Rect;
		protected var border:Rect;
		protected var highlight:Rect;
		
		public var contents:Group;
		public var labelGroup:Group;
		public var labelDisplay:GraphicText;
		public var labelHighlight:GraphicText;
		
		public function ButtonSkin()
		{
			bindTarget("focused");
			bindTarget("defaultButton");
			
			bindTarget("label");
			bindTarget("cornerRadius");
		}
		
		[Bindable("propertyChange")]
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			DataChange.change(this, "label", _label, _label = value);
			if (created) {
				labelDisplay.text = _label;
				labelHighlight.text = _label;
				labelGroup.invalidate(LayoutEvent.MEASURE);
			}
		}
		private var _label:String;
		
		[Bindable("propertyChange")]
		public function get cornerRadius():Number { return _cornerRadius; }
		public function set cornerRadius(value:Number):void
		{
			DataChange.change(this, "cornerRadius", _cornerRadius, _cornerRadius = value);
			invalidate();
		}
		private var _cornerRadius:Number = 4;
		
		override protected function create():void
		{
			var upState:State =					new State("up");
			var overState:State =				new State("over");
			var downState:State =				new State("down");
			var disabledState:State =			new State("disabled");
			var upSelectedState:State =			new State("upSelected");
			var overSelectedState:State =		new State("overSelected");
			var downSelectedState:State =		new State("downSelected");
			var disabledSelectedState:State =	new State("disabledSelected");
			
			states = [upState, overState, downState, disabledState, upSelectedState,
					  overSelectedState, downSelectedState, disabledSelectedState];
			
			var change:Change;
			
			minWidth = 12;
			minHeight = 12;
			
			
			// :: BACKGROUND :: //
			
			{ // background is all drawn onto one flattened group
				background = new DockGroup();
				background.id = "background";
				background.dock = Align.FILL;
				background.flattened = true;
				content.add(background);
				
				overState.change(background, {filters: [
					new GlowFilter(0x888888, .6, 8, 8)
				]});
				
				overSelectedState.change(background, {filters: [
					new GlowFilter(0x668899, .6, 8, 8)
				]});
			}
			
			{ // 1 px dark border
				border = new Rect();
				border.radiusX = border.radiusY = _cornerRadius + 1;
				border.dock = Align.FILL;
				border.fill = new LinearGradient([
					new GradientEntry(0x000000, .5),
					new GradientEntry(0x000000, .3),
				], -90);
				background.content.add(border);
				
				change = downState.change(border, {fill: new LinearGradient([
					new GradientEntry(0x000000, .3),
					new GradientEntry(0x000000, .5),
				], -90)} );
				
				downSelectedState.add(change);
			}
			
			{ // 1 px highlight across the top of the button
				highlight = new Rect();
				highlight.radiusX = highlight.radiusY = _cornerRadius;
				highlight.dock = Align.FILL;
				highlight.margin = 1;
				highlight.fill = new LinearGradient([
					new GradientEntry(0x888888),
					new GradientEntry(0xFFFFFF),
				], -90);
				background.content.add(highlight);
				
				downState.change(highlight, {fill: new LinearGradient([
					new GradientEntry(0xDDDDDD),
					new GradientEntry(0x999999),
				], -90)});
				
				change = upSelectedState.change(highlight, {fill: new LinearGradient([
					new GradientEntry(0x668899),
					new GradientEntry(0xDDEEFF),
				], -90)});
				
				overSelectedState.add(change);
				
				downSelectedState.change(highlight, {fill: new LinearGradient([
					new GradientEntry(0xDDEEFF),
					new GradientEntry(0x668899),
				], -90)});
			}
			
			{ // smooth gradient as the primary surface
				surface = new Rect();
				surface.radiusX = surface.radiusY = _cornerRadius;
				surface.dock = Align.FILL;
				surface.margin = "2 1";
				surface.fill = new LinearGradient([
					new GradientEntry(0xAAAAAA),
					new GradientEntry(0xEEEEEE),
				], -90);
				background.content.add(surface);
				
				downState.change(surface, {fill: new LinearGradient([
					new GradientEntry(0xCCCCCC),
					new GradientEntry(0xBBBBBB),
				], -90)} );
				
				change = upSelectedState.change(surface, {fill: new LinearGradient([
					new GradientEntry(0x88AABB),
					new GradientEntry(0xCCDDEE),
				], -90)} );
				
				upSelectedState.add(change);
				
				upSelectedState.change(surface, {fill: new LinearGradient([
					new GradientEntry(0xCCDDEE),
					new GradientEntry(0x88AABB),
				], -90)} );
			}
			
			
			// :: CONTENTS :: //
			
			{ // create 'contents' - container of Button's children
				contents = new Group();
				contents.id = "contents";
				contents.layout = new HorizontalLayout();
				contents.hAlign = Align.CENTER;
				contents.vAlign = Align.MIDDLE;
				contents.dock = Align.FILL;
				contents.margin.top = 1;
				contents.margin.bottom = 0;
				contents.margin.left = 6;
				contents.margin.right = 6;
				content.add(contents);
			}
			
			
			{ // default contents consist of a label & labelradius highlight
				labelGroup = new Group();
				labelGroup.id = "labelGroup";
				contents.content.add(labelGroup);
				
				labelHighlight = new GraphicText();
				labelHighlight.y = 1;
				labelHighlight.autoSize = TextFieldAutoSize.LEFT;
				labelHighlight.defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF, true);
				labelHighlight.alpha = .6;
				labelHighlight.text = _label;
				labelHighlight.selectable = false;
				labelGroup.content.add(labelHighlight);
				
				labelDisplay = new GraphicText();
				labelDisplay.autoSize = TextFieldAutoSize.LEFT;
				labelDisplay.defaultTextFormat = new TextFormat("_sans", 14, 0x444444, true);
				labelDisplay.text = _label;
				labelDisplay.selectable = false;
				labelGroup.content.add(labelDisplay);
			}
		}
	}
}
