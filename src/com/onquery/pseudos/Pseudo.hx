package com.onquery.pseudos;

import com.onquery.signals.*;

class Pseudo{
	private var _name:String;
	private var _value:String;
	public function new(n:String){
		setName(n);
	}


	public function getName():String{return _name;}
	public function setName(value:String):String{return _name=value;}

	public function getValue():String{return _value;}
	public function setValue(val:String):String{return _value=val;}

	public function attach(signal:Signal):Signal{
		return signal;
	}

	static public function getInstance(name:String,value:String):Pseudo{
		var pseudo:Pseudo=null;
		switch (name) {
			case'rewind':
			pseudo=new RewindPseudo();
			case 'pause':
			pseudo=new PausePseudo();
			case 'delay':
			pseudo=new DelayPseudo();
			case 'throttle':
			pseudo=new ThrottlePseudo();

			default:
			pseudo=new Pseudo(name);
		}
		pseudo.setValue(value);
		return pseudo;
	}
}