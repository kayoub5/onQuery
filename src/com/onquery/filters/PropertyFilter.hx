package com.onquery.filters;
import haxe.ds.*;
import com.onquery.OnQuery;
class PropertyFilter implements Filter{
	public var name: String;
	public var operator: String;
	public var value: Dynamic;


	public function new(name:String,operator:String,value:String){
		this.name=name;
		this.operator = operator;
		var eString:EReg = ~/"(.*)"/;
		var v:Dynamic = value;
		if (v == 'true') { 
			v = true;
		}else if (v == 'false') {
			v = false;
		}else if (!Math.isNaN(v)) {
			v = Std.parseFloat(v);
		}else if (eString.match(v)) {
			v = eString.matched(1);
		}
		this.value=v;
	}

	public function match(object:Dynamic):Bool{
		if(!operators.exists(operator))return false;
		if(!Reflect.hasField(object,name))return false;
		return operators.get(operator)(Reflect.field(object,name),value);	
	}


	static private var operators:StringMap<Operator>=[
	''	=> exists,
	'='	=> equals,
	'*='=> contains,
	'!='=> differs,
	'=='=> boolEquals,
	'>'	=> greaterThan,
	'<'	=> lessThan
	];

	static function contains(left:Dynamic,right:Dynamic):Bool{
		return (left.indexOf(right) > -1);
	}

	static  function exists(left:Dynamic,right:Dynamic):Bool{
		return true;
	}
	static  function differs(left:Dynamic,right:Dynamic):Bool{
		return (left!=right);
	}

	static  function equals(left:Dynamic,right:Dynamic):Bool{
		return (left==right);
	}
	static  function boolEquals(left:Dynamic,right:Dynamic):Bool{
		return (!!left)==(!!right);
	}

	static  function greaterThan(left:Dynamic,right:Dynamic):Bool{
		return (left>right);
	}

	static  function lessThan(left:Dynamic,right:Dynamic):Bool{
		return (left<right);
	}
}