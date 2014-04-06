package com.onquery.pseudos;

import com.onquery.signals.*;
import com.onquery.filters.*;
import haxe.Timer;

class PausePseudo extends Pseudo implements Filter{
	private var _signal:Signal;
	private var paused:Bool=false;
	private var timer:Timer;
	private var lastArgs:Array<Dynamic>;

	public function new(){
		super('pause');
	}
	override public function attach(signal:Signal):Signal{
		_signal=signal;
		signal.filters.add(this);
		return signal;
	}	

	public function match(args:Array<Dynamic>):Bool{
		if(timer!=null){
			timer.stop();
			timer=null;
		}
		if(paused){
			paused=false;
			return true;
		}
		lastArgs=args;
		timer=Timer.delay(onPause,Std.parseInt('0'+getValue()));
		return false;
	}

	private function onPause():Void{
		paused=true;
		_signal.invokeListeners(lastArgs);
	}

}