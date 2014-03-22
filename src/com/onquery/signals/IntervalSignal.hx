package com.onquery.signals;

import com.onquery.core.*;
import com.onquery.*;
import com.onquery.OnQuery.Event;
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
		rewind();
	}
	
	private function tick() {
		invokeListeners(new Event("interval"));
	}
	
	override public function rewind(e:Dynamic = null) {
		if(timer!=null){
			timer.stop();
		}
		timer = new haxe.Timer(delay);
		timer.run = tick;
	}
	
	override public function dispose(event:Event = null):Void {
		if(timer!=null){
			timer.stop();
			timer = null;
		}
		super.dispose(event);
	}
}