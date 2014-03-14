package com.onquery.signals;

import com.onquery.core.*;
import com.onquery.*;
import com.onquery.OnQuery.Event;


class SequenceSignal extends CombinedSignal{

	static public function build(p:SignalPrototype, c:SignalContext):Signal {
		var l:List<Dynamic> = Interpreter.interpt(Build.popArg(p));
		var t:Array<Signal> = [];
		for (e in l) {
			t.push(Interpreter.build(e,c));
		}
		var s:Signal = new SequenceSignal(c, t);
		s.setType(p.type);
		return s;
	}
	
	private var queue:Array<Signal>;
	public var index:Int;
	
	private function new(c:SignalContext,t:Array<Signal>){
		super(c);
		queue = t;
		rewind();
	}
	
	override public function rewind(e:Dynamic = null) {
		reset();
		nextSignal();
	}
	
	private function reset() {
		for (signal in queue){
			signal.removeListener(nextSignal);
		}
		index = -1;
	}
	
	private function nextSignal(e:Dynamic = null) {
		var next = ++index;
		if (next == queue.length) {
			invokeListeners(e);
		}else {
			next %= queue.length;
			reset();
			index = next;
			queue[next].addListener(nextSignal);
		}
	}
	
	override public function dispose(event:Event = null):Void {
		reset();
		super.dispose(event);
	}
}