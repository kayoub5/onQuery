package com.onquery.flash;

class ContextEvent extends com.onquery.OnQuery.Event{
	public var context:com.onquery.Context;

	public function new(type:String){
		super(type);
	}
}