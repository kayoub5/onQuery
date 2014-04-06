package com.onquery.collections;

import com.onquery.OnQuery;
import com.onquery.signals.*;

class ListenersArray implements ListenersCollection{
	private var list:List<EventListener>;
	public var self:Dynamic;
	public function new(self:Dynamic) {
		this.self = self;
		list=new List<EventListener>();
	}

	public function removeListener(listener:EventListener):Void{
		list.remove(listener);
	}

	public function addListener(listener:EventListener):Void{
		list.add(listener);
	}

	public function invokeListeners(args:Array<Dynamic>):Void {
		for(listener in list){
			(untyped listener).apply(self,args);
		}
		
	}

	public function removeAllListeners():Void{
		list.clear();
	}


}