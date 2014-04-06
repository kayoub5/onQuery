package com.onquery.collections;
import com.onquery.OnQuery;
interface ListenersCollection{
	
/**
 * Subscribes a listener.
 * @param	listener A function with arguments
 * that matches the value classes dispatched by the Signal.
 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
 * @return a ISlot, which contains the Function passed as the parameter
 */
function addListener(listener:EventListener):Void;
	
/**
 * Unsubscribes a listener from the Signal.
 * @param	listener
 * @return a ISlot, which contains the Function passed as the parameter
 */
function removeListener(listener:EventListener):Void;
	
/**
 * Unsubscribes all listeners from the Signal.
 */
function removeAllListeners():Void;
	
/**
 * Dispatches an Dynamic to listeners.
 * @param	event	Any number of parameters to send to listeners. Will be type-checked against valueClasses.
 */
function invokeListeners(args:Array<Dynamic>):Void;
}