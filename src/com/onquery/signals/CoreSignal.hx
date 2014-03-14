package com.onquery.signals;

import com.onquery.OnQuery;
import com.onquery.collections.*;
import com.onquery.SignalContext;

class CoreSignal implements ListenersCollection{

	public var listeners:ListenersCollection;
	private var _context:SignalContext;

	private var _type:String;


	public function new(c:SignalContext){
		_context=new SignalContext(c);
		_context.set('this',this);
		listeners = new ListenersArray();
	}

	public function getContext():SignalContext{return _context;}
	public function getTarget():EventTarget{return _context.get('_target_');}

	public function getType():String{return _type;}
	public function setType(value:String):String{return _type=value;}

	/** @inheritDoc */
	public function addListener(listener:EventListener,options:Dynamic=null):Void{
		listeners.addListener(listener,options);	
	}

	/** @inheritDoc */
	public function removeListener(listener:EventListener):Void{
		listeners.removeListener(listener);
	}

	/** @inheritDoc */
	public function removeAllListeners():Void{
		listeners = new ListenersArray();
	}

	/** @inheritDoc */
	public function invokeListeners(event:Event):Void{
		listeners.invokeListeners(event);
	}

}