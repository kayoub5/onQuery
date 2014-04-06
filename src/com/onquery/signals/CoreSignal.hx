package com.onquery.signals;

import com.onquery.OnQuery;
import com.onquery.collections.*;
import com.onquery.SignalContext;

using com.onquery.utils.ContextUtils;

class CoreSignal implements ListenersCollection{

	public var listeners:ListenersCollection;
	public var lastArgs:Array<Dynamic>;
	private var _context:SignalContext;

	private var _type:String;


	public function new(c:SignalContext){
		_context=new SignalContext(c);
		_context.set('this',this);
		listeners = new ListenersArray(getTarget());
	}

	public function getContext():SignalContext{return _context;}
	public function getTarget():EventTarget{return _context.getTarget();}

	public function getType():String{return _type;}
	public function setType(value:String):String{return _type=value;}

	public function addListener(listener:EventListener):Void{
		listeners.addListener(listener);	
	}

	public function removeListener(listener:EventListener):Void{
		listeners.removeListener(listener);
	}

	public function removeAllListeners():Void{
		listeners.removeAllListeners();
	}

	public function invokeListeners(args:Array<Dynamic>):Void {
		lastArgs = args;
		listeners.invokeListeners(args);
	}

}