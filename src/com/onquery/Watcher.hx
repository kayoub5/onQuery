
package com.onquery;
import com.onquery.signals.*;
import com.onquery.core.*;
import com.onquery.OnQuery;
import haxe.ds.StringMap;
using com.onquery.utils.ContextUtils;
class Watcher {
	private var context:SignalContext;
	public function new(c:SignalContext){
		this.context=c;
		c.setWatcher(this);
	}

	public function bind(query:String,handler:EventListener):Void{
		on(query).addListener(handler);
	}

	public function on(query):Signal{
		var s:Signal=context.get(query);
		if(s==null){
			s=Interpreter.compile(query,context);
			context.set(query,s);
		}
		return s;
	}

	public function unbind(query:String,handler:EventListener){
		on(query).removeListener(handler);
	}

	public function use(data:Dynamic):Watcher{
		var c:SignalContext = new SignalContext();
		for (i in Reflect.fields(data)) {
			var d:Dynamic = Reflect.field(data, i);
			if (Std.is(d, String)) {
				d = on(d);
			}
			c.set(i,d);
		}
		c.setParent(context);
		return new Watcher(c);
	}
}