package com.onquery.pseudos;

import com.onquery.signals.*;
import com.onquery.filters.*;
import haxe.Timer;

class DelayPseudo extends Pseudo implements Filter{
	private var _signal:Signal;
	private var delayed:Bool=false;
	public function new(){
		super('delay');
	}
	override public function attach(signal:Signal):Signal{
		_signal=signal;
		signal.filters.add(this);
		return signal;
	}	

	public function match(args:Array<Dynamic>):Bool{
		if(delayed){
			delayed=false;
			return true;
		}
		function onDelay():Void{
			delayed=true;
			_signal.invokeListeners(args);
		}
		Timer.delay(onDelay,Std.parseInt('0'+getValue()));
		return false;
	}

}
