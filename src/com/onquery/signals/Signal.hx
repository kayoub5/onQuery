package com.onquery.signals;

import com.onquery.OnQuery;
import com.onquery.collections.*;
import com.onquery.filters.*;
class Signal extends CoreSignal{

	public var filters:List<Filter>;

	public function new(c:Context){
		super(c);
		filters=new List<Filter>();
		
	}

	//--
	override public function setType(t:String):String{
		t=super.setType(t);
		getTarget().addEventListener(t,invokeListeners,false);
		return t;
	}
	//----
	public function dispose(event:Event=null):Void{
		getTarget().removeEventListener(getType(),invokeListeners,false);
		listeners=null;
	}

	override public function invokeListeners(event:Dynamic):Void{
		for (f in filters) {
			if(!f.match(event))return;
		}
		super.invokeListeners(event);
	}

}