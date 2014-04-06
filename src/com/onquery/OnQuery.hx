package com.onquery;

import com.onquery.*;
import com.onquery.core.*;
import com.onquery.signals.*;

using com.onquery.utils.ContextUtils;

@:expose("onQuery")
class OnQuery{

	static public var globalContext:SignalContext= new SignalContext([
		'version' => '0.0.1'
		]);
	static public var buildTarget:Dynamic->EventTarget;
	/**
	 * available threw the window object.
	 * return an instance of a Watcher that moniter the target, watch() will return the same instance every time.
	 */
	@:expose("watch")
	static public function watch(target:EventTarget):Watcher {
		if (Std.is(target, String)) {
			target = buildTarget(target);
		}
		return target.getContext().getWatcher();
	}

	/**
	 * available threw the window object.
	 * use when() instead of watch() when the query does not require a target
	 */
	@:expose("when")
	static public function when(query:String):Signal{
		return globalContext.getWatcher().on(query);
	}

	static function main(){
		new Watcher(globalContext);
		#if js
		var exports:Dynamic = untyped $hx_exports;
		var jQuery =  exports.jQuery;
		if (jQuery != null) {
			buildTarget = untyped jQuery;
			jQuery.fn.dispatchEvent = jQuery.fn.trigger;
			jQuery.fn.addEventListener = function(type:String, listener:EventListener, useCapture:Bool) {
				var o = untyped __js__("this");
				o.on(type, listener);
			}
			jQuery.fn.removeEventListener = function(type:String, listener:EventListener, useCapture:Bool) {
				var o = untyped __js__("this");
				o.off(type, listener);
			}
		}
		#end
	}
	
}


typedef Operator = Dynamic->Dynamic->Bool;
/**
 * an event listener, typically a function with one argument.
 */
typedef EventListener = Array<Dynamic>->Void;

#if js
/*
 * an event
 
typedef Event = js.html.Event*/
/**
 * an event target, must impliment at least addEventListener, removeEventListener, dispatchEvent.
 */
typedef EventTarget = js.html.EventTarget

#end
