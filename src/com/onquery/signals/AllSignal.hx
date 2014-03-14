package com.onquery.signals;

import com.onquery.core.*;
import com.onquery.*;
import com.onquery.OnQuery;
import com.onquery.signals.*;



class AllSignal extends CombinedSignal{

	static public function build(p:SignalPrototype, c:SignalContext):Signal {
		var l:List<Dynamic> = Interpreter.interpt(Build.popArg(p));
		var t:List<Signal> = new List<Signal>();
		for (e in l) {
			t.add(Interpreter.build(e,c));
		}
		var s:Signal = new AllSignal(c, t);
		s.setType(p.type);
		return s;
	}
	
	private var queue:List<SignalToken>;

	private function new(c:SignalContext,t:List<Signal>){
		super(c);
		queue = new List<SignalToken>();
		for(token in t){
			queue.add(new SignalToken(token));
			token.addListener(recheck);
		}
		rewind();
	}
	
	override public function rewind(e:Dynamic = null) {
		for (t in  queue){
			t.reset();
		}
	}
	
	private function recheck(e:Dynamic = null) {
		var all:Bool = true;
		var i:Iterator<SignalToken> = queue.iterator();
		while (i.hasNext()){
			all = i.next().count > 0;
		}
		if (all) {
			invokeListeners(new Event(getType()));
		}
	}
	
}
