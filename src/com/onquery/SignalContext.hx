
package com.onquery;
import haxe.ds.StringMap;
class SignalContext extends StringMap<Dynamic>{

	private var _parent:StringMap<Dynamic>;
	public function getParent():StringMap<Dynamic>{return _parent;}
	public function setParent(parent:StringMap<Dynamic>):StringMap<Dynamic>{
		return _parent=parent;
	}
	public function new(parent:StringMap<Dynamic>=null){
		super();
		_parent=parent;
	}

	override public function get( key : String ) : Null<Dynamic>{
		if(super.exists(key)){
			return super.get(key);
		}
		if(_parent!=null){
			return _parent.get(key);
		}
		return null;
	}

	override public function exists( key : String ) : Bool{
		if(super.exists(key)){
			return true;
		}
		if(_parent!=null){
			return _parent.exists(key);
		}
		return false;
	}

	override public function keys() : Iterator<String>{
		return getMap().keys();
	}

	public function getMap():StringMap<Dynamic>{
		var tmp:StringMap<Dynamic>=new StringMap<Dynamic>();
		if(_parent!=null){
			for(key in _parent.keys()){
				tmp.set(key,_parent.get(key));
			}
		}
		
		for(key in keys()){
			tmp.set(key,super.get(key));
		}

		return tmp;
	}


	override public function iterator() : Iterator<Dynamic>{
		return getMap().iterator();
	}

}