package com.onquery.signals;

/**
 * ...
 * @author Ayoub Kaanich
 */
class CombinedSignal extends Signal{

	private var _rewinder:Signal;

	public function setRewinder(value:Signal):Signal{
		if(_rewinder!=null){
			_rewinder.removeListener(rewind);
		}
		_rewinder=value;
		if(_rewinder!=null){
			_rewinder.addListener(rewind);
		}
		return _rewinder;
	}
	
	public function rewind(?args:Array<Dynamic>){
		throw 'not implimented';
	}
	
	public function new(c:SignalContext){
		super(c);
		setRewinder(this);
	}
	
}