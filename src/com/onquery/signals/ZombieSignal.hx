package com.onquery.signals;

import com.onquery.core.*;

class ZombieSignal extends Signal{

	static public function build(p:SignalPrototype, c:SignalContext):Signal {
		var s:ZombieSignal = new ZombieSignal(c);
		s.properties = p.properties;
		p.properties = new List<Dynamic>();
		return s;
	}
	
	public var properties:List<Dynamic>;
	public function new(c:SignalContext) {
		super(c);
		
	}
	
}