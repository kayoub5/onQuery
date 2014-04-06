package com.onquery.signals;

import com.onquery.core.*;
import com.onquery.*;
import com.onquery.OnQuery;
import haxe.Timer;


class IntervalSignal extends CombinedSignal{

	private var delay:Int;
	public var timer:Timer;
	
	static public function build(p:SignalPrototype, c:SignalContext):Signal {
		return new IntervalSignal(c,Std.parseInt(Build.popArg(p)));
	}

	private function new(c:SignalContext,delay:Int){
		super(c);
		this.delay = delay;
		rewind(null);
	}
	
	private function tick() {
		invokeListeners([]);
	}
	
	override public function rewind(?args:Array<Dynamic>) {
		if(timer!=null){
			timer.stop();
		}
		timer = new haxe.Timer(delay);
		timer.run = tick;
	}
	
	override public function dispose():Void {
		if(timer!=null){
			timer.stop();
			timer = null;
		}
		super.dispose();
	}
}