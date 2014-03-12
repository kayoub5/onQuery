package com.onquery.pseudos;


import com.onquery.core.Interpreter;
import com.onquery.signals.*;

class RewindPseudo extends Pseudo{
	private var rewinder:Signal;
	public function new(){
		super('rewind');
	}

	override public function attach(signal:Signal):Signal{
		var s:ConnectedSignal= cast signal;
		s.setRewinder(Interpreter.compile(getValue(),s.getContext()));
		return signal;
	}	

}