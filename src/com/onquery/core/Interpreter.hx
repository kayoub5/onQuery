package com.onquery.core;

import com.onquery.*;
import com.onquery.filters.*;
import com.onquery.signals.*;
import com.onquery.pseudos.*;

class Interpreter{
	
	static public function compile(expression:String,context:SignalContext):Signal{
		var input:List<Dynamic> = interpt(expression);
		var output:List<Dynamic>=new List<Dynamic>();
		for(elm in input){
			if(Std.is(elm,Connector)){
				output.add(elm);
			}
			else if(Std.is(elm,SignalPrototype)){
				output.add(build(elm,context));
			}
		}
		/*if(output.length==1){
			signal=output.first();
		}
		else if(output.length>1){
			signal=new ConnectedSignal(context,output);
			signal.setType(expression);
		}*/
		var signal:Signal = combine(output,context);
		signal.setType(expression);
		return signal;
	}
	
	static private function combine(input:List<Dynamic>, context:SignalContext):Signal {
		if(input.length<2){
			return input.first();
		}
		var output:Array<Dynamic>=new Array<Dynamic>();
		for (s in input) {
			if (Std.is(s, ZombieSignal)) {
				var matching:Int = 0;
				var pipe:List<Dynamic> = new List<Dynamic>();
				while (output.length>0) {
					var elm:Dynamic = output.pop();
					pipe.push(elm);
					if (elm == Connector.OPEN) {
						matching++;
					}else if (elm == Connector.CLOSE) {
						matching--;
					}
					if (matching == 0) break;
				}
				var p:Signal = combine(pipe, context);
				p=attach(p, s.properties);
				output.push(p);
			}else {
				output.push(s);
			}
		}
		var result:List<Dynamic> = new List<Dynamic>();
		for (e in output) {
			result.add(e);
		}
		var signal:CombinedSignal=new ConnectedSignal(context,result);
		//signal.setType(expression);
		return signal;
	}
	
	static public function build(prototype:SignalPrototype,context:SignalContext):Signal{
		var signal:Signal=null;
		var ePrefix:EReg=~/^([$#\*])?(.*)/;
		ePrefix.match(prototype.type);
		var prefix:String=ePrefix.matched(1);
		var type:String = ePrefix.matched(2);
		
		if (prefix == '*') prefix = '#';
		
		switch (prefix) {
			case'$':
			//TODO sub signal
			signal=context.get(prototype.type.substr(1));
			case'#':
			signal=Build.registry.get(type)(prototype, context);
			
			default:
			signal=new Signal(context);
			signal.setType(prototype.type);
		}
		
		attach(signal, prototype.properties);
		return signal;
	}
	
	static private function attach(signal:Signal, properties:List<Dynamic>):Signal {
		for (p in properties){
			if(Std.is(p,Pseudo)){
				signal=p.attach(signal);
			}
			else if(Std.is(p,Filter)){
				signal.filters.add(cast p);
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
				
				var proto:SignalPrototype= lastPrototype(output);//output.last();
				proto.properties.add(new com.onquery.filters.PropertyFilter(name,operator,filter));
			}
			//pseudo
			else if (ePseudo.match(input)) {
				var pseudo:Pseudo=Pseudo.getInstance(ePseudo.matched(1),ePseudo.matched(2));
				input=ePseudo.replace(input,'');
				var proto:SignalPrototype = lastPrototype(output);//output.last();
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
	
	static private function lastPrototype(input:List<Dynamic>):SignalPrototype{
		var proto = input.last();
		if (Std.is(proto, SignalPrototype)){
			return proto;
		}
		proto = new SignalPrototype();
		proto.type = "#zombie";
		input.add(proto);
		return proto;
	}
}