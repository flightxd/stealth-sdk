/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	import flash.utils.getDefinitionByName;

	public class Factory implements IFactory
	{
		public var build:Function;
		public var properties:Object;
		
		protected var template:Class;
		
		// 'build' should resolve to a class or a method
		public function Factory(build:Object, properties:Object = null)
		{
			this.properties = properties;
			
			if (build is String) {
				build = getDefinitionByName(String(build));
			}
			if (build is Class) {
				if ("getInstance" in Class) {
					this.build = build.getInstance;
				} else {
					this.template = Class(build);
					this.build = buildTemplate;
				}
			} else {
				this.build = Function(build);
			}
		}
		
		public function getInstance(data:Object = null):*
		{
			var instance:Object = build.length ? build(data) : build();
			for (var i:String in properties) {
				instance[i] = properties;
			}
			return instance;
		}
		
		protected function buildTemplate(data:Object = null):*
		{
			var template:Object = new template();
			if ("data" in template) {
				template["data"] = data;
			}
			return template;
		}
		
		public static function getInstance(value:*, data:Object = null):*
		{
			if (value is String) {
				value = getDefinitionByName(String(value));
			}
			if (value is Class) {
				if ("getInstance" in value) {
					return value.getInstance.length ? value.getInstance(data) : value.getInstance();
				} else {
					return new value();
				}
			} else if (value is IFactory) {
				return IFactory(value).getInstance(data);
			} else if (value is Function) {
				return value.length ? value(data) : value();
			} else {
				return value;
			}
		}
	}
}
