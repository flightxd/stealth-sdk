/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package
{
	import mx.binding.ArrayElementWatcher;
	import mx.binding.BindingManager;
	import mx.binding.FunctionReturnWatcher;
	import mx.binding.IBindingClient;
	import mx.binding.IWatcherSetupUtil;
	import mx.binding.IWatcherSetupUtil2;
	import mx.binding.PropertyWatcher;
	import mx.binding.RepeaterComponentWatcher;
	import mx.binding.RepeaterItemWatcher;
	import mx.binding.StaticPropertyWatcher;
	import mx.binding.XMLWatcher;
	import mx.core.ClassFactory;
	import mx.core.DeferredInstanceFromClass;
	import mx.core.DeferredInstanceFromFunction;
	import mx.core.IFlexModuleFactory;
	import mx.core.IMXMLObject;
	import mx.core.IPropertyChangeNotifier;
	import mx.styles.StyleManager;
	import mx.utils.ObjectProxy;
	import mx.utils.UIDUtil;

	/**
	 * @private
	 * This class is used to link additional classes into flight-stealth.swc
	 * beyond those that are found by dependecy analysis starting from the
	 * classes specified in manifest.xml. For example, compiler-required
	 * references to Flex classes for use of an MXML workflow and the [Bindable]
	 * metadata tag in AS3-only projects - many of these classes are never
	 * actually used, not even in the auto-generated code.
	 */
	internal class FlexClasses
	{
		IMXMLObject;
		IFlexModuleFactory;
		
		// binding references for use of the [Bindable] metadata tag
		BindingManager;
		IPropertyChangeNotifier;
		ObjectProxy;
		UIDUtil;
		
		// mx core references for use of MXML
		StyleManager;
		ClassFactory;
		DeferredInstanceFromClass;
		DeferredInstanceFromFunction;
		
		// binding references for use of the curly-brace binding in MXML
		IWatcherSetupUtil;
		// Required class for Flash Buider 4 binding in AS3 projects
		IBindingClient;
		IWatcherSetupUtil2;
		ArrayElementWatcher;
		FunctionReturnWatcher;
		PropertyWatcher;
		RepeaterComponentWatcher;
		RepeaterItemWatcher;
		StaticPropertyWatcher;
		XMLWatcher;
	}

}
