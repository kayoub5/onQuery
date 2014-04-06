package com.onquery.filters;

interface Filter {
	public function match(args:Array<Dynamic>):Bool;
}