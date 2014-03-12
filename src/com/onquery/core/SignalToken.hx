package com.onquery.core;

import com.onquery.signals.Signal;

class SignalToken{

	public var count:Float=0;
	public var time:Float=0;
	static private var currentTime:Float=1;

	public function new(signal:Signal=null){
		setSignal(signal);
	}

	private var _signal:Signal;

	public function getSignal():Signal { return _signal; }

	public function setSignal(value:Signal):Signal{
		if (_signal == value){
			return _signal;
		}
		_signal = value;
		if(_signal!=null){
			_signal.addListener(refresh);
		}
		return _signal;
	}

	private function refresh(event:Dynamic=null):Void{
		time=currentTime++;
		count++;
	}

	public function reset(event:Dynamic=null):Void{
		count=0;
		time=0;
	}
}