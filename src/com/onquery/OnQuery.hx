package com.onquery;

import com.onquery.*;
import com.onquery.core.*;
import com.onquery.signals.*;

@:expose("OnQuery")
class OnQuery{

	static public var globalContext:SignalContext= new SignalContext([
		'version' => '0.0.0'
		]);
	static public var targetBuilder:Dynamic->EventTarget;
	/**
	 * available threw the window object.
	 * return an instance of a Watcher that moniter the target, watch() will return the same instance every time.
	 */
	static public function watch(target:EventTarget):Watcher {
		if (Std.is(target, String)) {
			target = targetBuilder(target);
		}
		return getContext(target).get('_watcher_');
	}

	/**
	 * available threw the window object.
	 * use when() instead of watch() when the query does not require a target
	 */
	static public function when(query:String):Signal{
		return globalContext.get('_watcher_').on(query);
	}
	
	static public function getContext(target:EventTarget):com.onquery.SignalContext{
		var e:Dynamic=new ContextEvent('_context_');
		target.dispatchEvent(e);
		if(e.context==null){
			var c:SignalContext=new SignalContext();
			c.setParent(globalContext);
			c.set('_target_',target);
			var w:Watcher=new Watcher(c);
			target.addEventListener('_context_',function(e:Dynamic){
				e.context=c;
				});
			return c;
		}
		return e.context;
	}
	/**
	* @private
	*/
	static function main(){
		new Watcher(globalContext);
		#if js
		var window:Dynamic=js.Browser.window;
		window.watch = watch;
		window.when = when;
		var jQuery = window.jQuery;
		if (jQuery != null) {
			targetBuilder = untyped jQuery;
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
typedef EventListener = Dynamic ->Void

#if (js)
/**
 * an event
 */
typedef Event = js.html.Event
/**
 * an event target, must impliment at least addEventListener, removeEventListener, dispatchEvent.
 */
typedef EventTarget = js.html.EventTarget
/**
 * a context event, a special type of event used for storing the Watcher inside the EventTarget
 */
typedef ContextEvent=js.html.Event
#end

#if (flash)
typedef Event = flash.events.Event
typedef EventTarget = flash.events.EventDispatcher
typedef ContextEvent=com.onquery.flash.ContextEvent
#end

#if (flash9 || flash9doc || js ) 
typedef UInt = Int 
#end 