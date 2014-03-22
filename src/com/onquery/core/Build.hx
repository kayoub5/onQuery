package com.onquery.core;
import haxe.ds.StringMap.StringMap;
import com.onquery.signals.*;
import com.onquery.pseudos.*;

/**
 * ...
 * @author Ayoub Kaanich
 */

typedef Builder = SignalPrototype-> SignalContext->Signal;


class Build{

	static public var registry:StringMap<Builder> = [
		'' =>		wrap,
		'timeout'	=>null,
		'interval'	=>IntervalSignal.build,
		'any'		=>null,
		'all'		=>AllSignal.build,
		'seq'		=>SequenceSignal.build
	];
	
	static public function popArg(p:SignalPrototype):String{
		var arg:String='';
		var f = p.properties.first();
		if (Std.is(f,Pseudo) && f.getName()==''){
			arg = f.getValue();
			p.properties.pop();
		}
		return arg;
	}
	
	static private function wrap(prototype:SignalPrototype, context:com.onquery.SignalContext):Signal {
		return Interpreter.compile(popArg(prototype),context);
	}
	
	
}
