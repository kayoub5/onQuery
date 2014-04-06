package com.onquery.utils;

import com.onquery.OnQuery.EventTarget;
import com.onquery.SignalContext;
import com.onquery.Watcher;

using com.onquery.utils.ContextUtils;

	/**
	* a context event, a special type of event used for storing the Watcher inside the EventTarget
	*/
	typedef ContextEvent=js.html.Event

class ContextUtils {
	
	public static function getTarget(context:SignalContext):EventTarget {
		return context.get('_target_');
	}
	
	public static function setTarget(context:SignalContext,target:EventTarget) {
		return context.set('_target_',target);
	}
	
	public static function getWatcher(context:SignalContext):Watcher {
		return context.get('_watcher_');
	}
	
	public static function setWatcher(context:SignalContext,watcher:Watcher) {
		return context.set('_watcher_',watcher);
	}
	
	static public function getContext(target:EventTarget):SignalContext{
		var e:Dynamic=new ContextEvent('_context_');
		target.dispatchEvent(e);
		if(e.context==null){
			var c:SignalContext=new SignalContext();
			c.setParent(OnQuery.globalContext);
			c.setTarget(target);
			new Watcher(c);
			target.addEventListener('_context_',function(e:Dynamic){
				e.context=c;
				});
			return c;
		}
		return e.context;
	}
	
}