package com.onquery.pseudos;

import com.onquery.signals.*;
import com.onquery.filters.*;
import haxe.Timer;

class ThrottlePseudo extends Pseudo implements Filter{
	private var _signal:Signal;
	private var throttling:Bool=false;
	private var timer:Timer;

	public function new(){
		super('throttle');
	}
	override public function attach(signal:Signal):Signal{
		_signal=signal;
		signal.filters.add(this);
		return signal;
	}	

	public function match(event:Dynamic):Bool{
		if(throttling){
			return false;
		}
		throttling=true;
		Timer.delay(onThrottle,Std.parseInt('0'+getValue()));
		return true;
	}

	private function onThrottle():Void{
		throttling=false;
	}

}