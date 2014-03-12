package com.onquery.core;

import com.onquery.filters.*;
import com.onquery.signals.*;
import com.onquery.pseudos.*;

class SignalPrototype{
	public var type:String='';
	public var properties:List<Dynamic>;

	public function new(){
		properties=new List<Dynamic>();
	}

}