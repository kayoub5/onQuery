package com.onquery.filters;
import haxe.ds.*;
import com.onquery.OnQuery;
class PropertyFilter implements Filter{
	public var name: String;
	public var operator: String;
	public var value: String;


	public function new(name:String,operator:String,value:String){
		this.name=name;
		this.operator=operator;
		this.value=value;
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