package com.onquery;

import com.onquery.*;
import com.onquery.core.*;
import com.onquery.signals.*;

@:expose("OnQuery")
@:expose
//@:build(com.onquery.Macro.build()) 
class OnQuery{

	static public var globalContext:SignalContext= new SignalContext([
		'version' => '0.0.0'
		]);

	static public function watch(target:EventTarget):Watcher{
		return getContext(target).get('_watcher_');
	}

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

	static function main(){
		new Watcher(globalContext);
		#if js
		var window:Dynamic=js.Browser.window;
		window.watch=watch;
		#end
	}
	
}



typedef Operator=Dynamic->Dynamic->Bool;
typedef EventListener = Dynamic ->Void

#if (js)
typedef Event = js.html.Event
typedef EventTarget = js.html.EventTarget
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