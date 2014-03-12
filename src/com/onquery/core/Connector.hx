package com.onquery.core;

import com.onquery.core.SignalToken;


class Connector{
	public var precedence:Int;
	public var argc:Int;
	public var leftAssociative:Bool;
	public var connect:List<SignalToken>->SignalToken;

	public function new(connect:List<SignalToken>->SignalToken,argc:Int=0,precedence:Int=0,leftAssociative:Bool=false){
		this.connect=connect;
		this.argc=argc;
		this.precedence=precedence;
		this.leftAssociative=leftAssociative;
	}


	static public var OPEN	:Connector=new Connector(null);
	static public var CLOSE	:Connector=new Connector(null);

	static public var NOT	:Connector=new Connector(
		function(l:List<SignalToken>):SignalToken{
			var token:SignalToken=new SignalToken();
			var arg:SignalToken=l.first();
			token.time= arg.time;
			token.count= arg.count>0?0:1;
			return token;
		}
		,1,100,false);

	static public var OR	:Connector=new Connector(
		function(l:List<SignalToken>):SignalToken{
			var token:SignalToken=new SignalToken();
			var left:SignalToken=l.first();
			var right:SignalToken=l.last();
			token.time=Math.max(left.time,right.time);
			token.count=Math.max(left.count,right.count);

			return token;
		}
		,2,80,false);

	static public var AND	:Connector=new Connector(
		function(l:List<SignalToken>):SignalToken{
			var token:SignalToken=new SignalToken();
			var left:SignalToken=l.first();
			var right:SignalToken=l.last();
			token.time=Math.max(left.time,right.time);
			token.count=Math.min(left.count,right.count);
			
			return token;
		}
		,2,90,false);

	static public var NEXT	:Connector=new Connector(
		function(l:List<SignalToken>):SignalToken{
			var left:SignalToken=l.first();
			var right:SignalToken=l.last();
			var token:SignalToken=new SignalToken();
			if(left.time<right.time){
				token.count=Math.min(left.count,right.count);
				token.time=right.time;
			}
			return token;
		}
		,2,70,true);



	static public var registry:haxe.ds.StringMap<Connector>=[
	'+'=> OR,
	'!'=> NOT,
	'&'=> AND,
	'>'=> NEXT,
	'{'=> OPEN,
	'}'=> CLOSE
	];




}