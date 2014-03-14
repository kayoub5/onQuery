package com.onquery.collections;

import com.onquery.OnQuery;
import com.onquery.signals.*;
import haxe.ds.StringMap;
class ListenersArray implements ListenersCollection{
	private var list:List<Slot>;
	public function new(){
		list=new List<Slot>();
	}

	public function removeListener(listener:EventListener):Void{
		list=list.filter(function(item:Slot):Bool{
			return item.listener!=listener;
			});
	}

	public function addListener(listener:EventListener, options:Dynamic=null):Void{
		if(options==null){
			options={};
		}
		removeListener(listener);
		var slot:Slot=new Slot(listener,options);
		list.add(slot);
	}

	public function invokeListeners(event:Dynamic):Void{
		for(slot in list){
			var fn:EventListener=slot.listener;
			/*if(fn.length==0){
				fn();
			}
			else{*/
				fn(event);
			//}
		}
	}

	public function removeAllListeners():Void{
		list.clear();
	}


}