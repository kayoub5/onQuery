package com.onquery.core;

import com.onquery.*;
import com.onquery.filters.*;
import com.onquery.signals.*;
import com.onquery.pseudos.*;

class Interpreter{

	static public function compile(expression:String,context:Context):Signal{
		var input:List<Dynamic> = interpt(expression);
		var signal:Signal=null;
		var output:List<Dynamic>=new List<Dynamic>();
		for(elm in input){
			if(Std.is(elm,Connector)){
				output.add(elm);
			}
			else if(Std.is(elm,SignalPrototype)){
				output.add(build(elm,context));
			}
		}
		if(output.length==1){
			signal=output.first();
		}
		else if(output.length>1){
			signal=new ConnectedSignal(context,output);
			signal.setType(expression);
		}

		return signal;
	}


	static private function build(prototype:SignalPrototype,context:Context):Signal{
		var signal:Signal=null;
		var ePrefix:EReg=~/^([$#\*])?(.*)/;
		ePrefix.match(prototype.type);
		var prefix:String=ePrefix.matched(1);
		var type:String=ePrefix.matched(2);
		switch (prefix) {
			case'*':
			var p:Pseudo=prototype.properties.pop();
			if(p.getName()==''){
				signal=compile(p.getValue(),context);
			}

			case'$':
			//TODO sub signal
			signal=context.get(prototype.type.substr(1));

			case'#':
			switch (type) {
				case'timeout':

				case'interval':

				case'seq':

				case'any':

				case'all':
			}

			default:
			signal=new Signal(context);
			signal.setType(prototype.type);
		}

		for (p in prototype.properties){
			if(Std.is(p,Pseudo)){
				signal=cast(p,Pseudo).attach(signal);
			}
			else if(Std.is(p,Filter)){
				signal.filters.add(p);
			}
		}
		return signal;
	}



	static public function interpt(input:String):List<Dynamic>{
		var 
		ePseudo:EReg=~/^:([:\w]*)\(([^\)]*)\)?/,
eConnector:EReg=~/^[>+!&{}]/,
eOperator:EReg=~/^[<>+~!@$%^&{};,=]+/,
eType:EReg=~/^[_$#\*\-\.\w]+/,
eFilter:EReg=~/^\[[^\]]*\]/,
eSpace:EReg=~/^\s+/;

var output:List<Dynamic>=new List<Dynamic>();
while(input.length>0){
	//space
	if (eSpace.match(input)) {
		input=eSpace.replace(input,'');
	}
			//type
			else if (eType.match(input)) {
				var type:String=eType.matched(0);
				input=eType.replace(input,'');
				var proto:SignalPrototype=new SignalPrototype();
				proto.type=type;
				output.add(proto);
			}
			//filter
			else if (eFilter.match(input)) {
				var filter:String=eFilter.matched(0);
				input=eFilter.replace(input,'');
				filter=filter.substr(1);
				filter=filter.substr(0,filter.length-1);
				var name: String='';
				var operator: String='';
				if(eType.match(filter)){
					name=eType.matched(0);
					filter=eType.replace(filter,'');
				}
				if(eOperator.match(filter)){
					operator=eOperator.matched(0);
					filter=eOperator.replace(filter,'');
				}

				var proto:SignalPrototype= output.last();
				proto.properties.add(new com.onquery.filters.PropertyFilter(name,operator,filter));
			}
			//pseudo
			else if (ePseudo.match(input)) {
				var pseudo:Pseudo=Pseudo.getInstance(ePseudo.matched(1),ePseudo.matched(2));
				input=ePseudo.replace(input,'');
				var proto:SignalPrototype= output.last();
				proto.properties.add(pseudo);
			}
			//connector
			else if (eConnector.match(input)) {
				var c:String=eConnector.matched(0);
				var connector:Connector=Connector.registry.get(c);
				input=eConnector.replace(input,'');
				output.add(connector);
			}
			//something else
			else{
				throw 'error parsing '+input.substr(0,20);
			}

		}
		//trace(output.toString());
		return output;
	}

}