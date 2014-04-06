package com.onquery.signals;

import com.onquery.OnQuery;
import com.onquery.collections.*;
import com.onquery.filters.*;
class Signal extends CoreSignal{

	public var filters:List<Filter>;

	public function new(c:SignalContext){
		super(c);
		filters=new List<Filter>();
		
	}

	//--
	override public function setType(t:String):String{
		t=super.setType(t);
		getTarget().addEventListener(t,handle,false);
		return t;
	}
	//----
	public function dispose():Void{
		getTarget().removeEventListener(getType(),handle,false);
		listeners=null;
	}
	
	private function handle(event:Dynamic):Void {
		invokeListeners(untyped __js__('arguments'));
	}

	override public function invokeListeners(args:Array<Dynamic>):Void{
		for (f in filters) {
			if(!f.match(args))return;
		}
		super.invokeListeners(args);
	}

}