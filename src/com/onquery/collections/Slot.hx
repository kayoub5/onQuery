package com.onquery.collections;

import com.onquery.OnQuery;
/**
 *
 */
class Slot{
public var listener:EventListener;
public var options:Dynamic;

/**
 * Creates and returns a new Slot Dynamic.
 *
 * @param listener The listener associated with the slot.
 * @param priority The priority of the slot.
 *
 */
public function new(listener:EventListener,options:Dynamic){
	this.listener = listener;
	this.options=options;
}
}