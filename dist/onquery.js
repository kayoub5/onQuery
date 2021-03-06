(function ($hx_exports) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw "EReg::matched";
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var List = function() {
	this.length = 0;
};
List.__name__ = true;
List.prototype = {
	add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		if(this.h == null) return null; else return this.h[0];
	}
	,last: function() {
		if(this.q == null) return null; else return this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
};
var IMap = function() { };
IMap.__name__ = true;
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
};
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var haxe = {};
haxe.ds = {};
haxe.ds.StringMap = function() {
	this.h = { };
};
haxe.ds.StringMap.__name__ = true;
haxe.ds.StringMap.__interfaces__ = [IMap];
haxe.ds.StringMap.prototype = {
	set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,__class__: haxe.ds.StringMap
};
var com = {};
com.onquery = {};
com.onquery.SignalContext = function(parent) {
	haxe.ds.StringMap.call(this);
	this._parent = parent;
};
com.onquery.SignalContext.__name__ = true;
com.onquery.SignalContext.__super__ = haxe.ds.StringMap;
com.onquery.SignalContext.prototype = $extend(haxe.ds.StringMap.prototype,{
	getParent: function() {
		return this._parent;
	}
	,setParent: function(parent) {
		return this._parent = parent;
	}
	,get: function(key) {
		if(haxe.ds.StringMap.prototype.exists.call(this,key)) return haxe.ds.StringMap.prototype.get.call(this,key);
		if(this._parent != null) return this._parent.get(key);
		return null;
	}
	,exists: function(key) {
		if(haxe.ds.StringMap.prototype.exists.call(this,key)) return true;
		if(this._parent != null) return this._parent.exists(key);
		return false;
	}
	,keys: function() {
		return this.getMap().keys();
	}
	,getMap: function() {
		var tmp = new haxe.ds.StringMap();
		if(this._parent != null) {
			var $it0 = this._parent.keys();
			while( $it0.hasNext() ) {
				var key = $it0.next();
				tmp.set(key,this._parent.get(key));
			}
		}
		var $it1 = this.keys();
		while( $it1.hasNext() ) {
			var key1 = $it1.next();
			tmp.set(key1,haxe.ds.StringMap.prototype.get.call(this,key1));
		}
		return tmp;
	}
	,iterator: function() {
		return this.getMap().iterator();
	}
	,__class__: com.onquery.SignalContext
});
com.onquery.OnQuery = $hx_exports.onQuery = function() { };
com.onquery.OnQuery.__name__ = true;
com.onquery.OnQuery.watch = $hx_exports.watch = function(target) {
	if(typeof(target) == "string") target = com.onquery.OnQuery.buildTarget(target);
	return com.onquery.utils.ContextUtils.getWatcher(com.onquery.utils.ContextUtils.getContext(target));
};
com.onquery.OnQuery.when = $hx_exports.when = function(query) {
	return com.onquery.utils.ContextUtils.getWatcher(com.onquery.OnQuery.globalContext).on(query);
};
com.onquery.OnQuery.main = function() {
	new com.onquery.Watcher(com.onquery.OnQuery.globalContext);
	var exports = $hx_exports;
	var jQuery = exports.jQuery;
	if(jQuery != null) {
		com.onquery.OnQuery.buildTarget = jQuery;
		jQuery.fn.dispatchEvent = jQuery.fn.trigger;
		jQuery.fn.addEventListener = function(type,listener,useCapture) {
			var o = this;
			o.on(type,listener);
		};
		jQuery.fn.removeEventListener = function(type1,listener1,useCapture1) {
			var o1 = this;
			o1.off(type1,listener1);
		};
	}
};
com.onquery.Watcher = function(c) {
	this.context = c;
	com.onquery.utils.ContextUtils.setWatcher(c,this);
};
com.onquery.Watcher.__name__ = true;
com.onquery.Watcher.prototype = {
	bind: function(query,handler) {
		this.on(query).addListener(handler);
	}
	,on: function(query) {
		var s = this.context.get(query);
		if(s == null) {
			s = com.onquery.core.Interpreter.compile(query,this.context);
			this.context.set(query,s);
		}
		return s;
	}
	,unbind: function(query,handler) {
		this.on(query).removeListener(handler);
	}
	,'use': function(data) {
		var c = new com.onquery.SignalContext();
		var _g = 0;
		var _g1 = Reflect.fields(data);
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			var d = Reflect.field(data,i);
			if(typeof(d) == "string") d = this.on(d);
			c.set(i,d);
		}
		c.setParent(this.context);
		return new com.onquery.Watcher(c);
	}
	,__class__: com.onquery.Watcher
};
com.onquery.collections = {};
com.onquery.collections.ListenersCollection = function() { };
com.onquery.collections.ListenersCollection.__name__ = true;
com.onquery.collections.ListenersCollection.prototype = {
	__class__: com.onquery.collections.ListenersCollection
};
com.onquery.collections.ListenersArray = function(self) {
	this.self = self;
	this.list = new List();
};
com.onquery.collections.ListenersArray.__name__ = true;
com.onquery.collections.ListenersArray.__interfaces__ = [com.onquery.collections.ListenersCollection];
com.onquery.collections.ListenersArray.prototype = {
	removeListener: function(listener) {
		this.list.remove(listener);
	}
	,addListener: function(listener) {
		this.list.add(listener);
	}
	,invokeListeners: function(args) {
		var $it0 = this.list.iterator();
		while( $it0.hasNext() ) {
			var listener = $it0.next();
			listener.apply(this.self,args);
		}
	}
	,removeAllListeners: function() {
		this.list.clear();
	}
	,__class__: com.onquery.collections.ListenersArray
};
com.onquery.core = {};
com.onquery.core.Interpreter = function() { };
com.onquery.core.Interpreter.__name__ = true;
com.onquery.core.Interpreter.compile = function(expression,context) {
	var input = com.onquery.core.Interpreter.interpt(expression);
	var output = new List();
	var $it0 = input.iterator();
	while( $it0.hasNext() ) {
		var elm = $it0.next();
		if(js.Boot.__instanceof(elm,com.onquery.core.Connector)) output.add(elm); else if(js.Boot.__instanceof(elm,com.onquery.core.SignalPrototype)) output.add(com.onquery.core.Interpreter.build(elm,context));
	}
	var signal = com.onquery.core.Interpreter.combine(output,context);
	signal.setType(expression);
	return signal;
};
com.onquery.core.Interpreter.combine = function(input,context) {
	if(input.length < 2) return input.first();
	var output = new Array();
	var $it0 = input.iterator();
	while( $it0.hasNext() ) {
		var s = $it0.next();
		if(js.Boot.__instanceof(s,com.onquery.signals.ZombieSignal)) {
			var matching = 0;
			var pipe = new List();
			while(output.length > 0) {
				var elm = output.pop();
				pipe.push(elm);
				if(elm == com.onquery.core.Connector.OPEN) matching++; else if(elm == com.onquery.core.Connector.CLOSE) matching--;
				if(matching == 0) break;
			}
			var p = com.onquery.core.Interpreter.combine(pipe,context);
			p = com.onquery.core.Interpreter.attach(p,s.properties);
			output.push(p);
		} else output.push(s);
	}
	var result = new List();
	var _g = 0;
	while(_g < output.length) {
		var e = output[_g];
		++_g;
		result.add(e);
	}
	var signal = new com.onquery.signals.ConnectedSignal(context,result);
	return signal;
};
com.onquery.core.Interpreter.build = function(prototype,context) {
	var signal = null;
	var ePrefix = new EReg("^([$#\\*])?(.*)","");
	ePrefix.match(prototype.type);
	var prefix = ePrefix.matched(1);
	var type = ePrefix.matched(2);
	if(prefix == "*") prefix = "#";
	switch(prefix) {
	case "$":
		signal = context.get(HxOverrides.substr(prototype.type,1,null));
		break;
	case "#":
		signal = (com.onquery.core.Build.registry.get(type))(prototype,context);
		break;
	default:
		signal = new com.onquery.signals.Signal(context);
		signal.setType(prototype.type);
	}
	com.onquery.core.Interpreter.attach(signal,prototype.properties);
	return signal;
};
com.onquery.core.Interpreter.attach = function(signal,properties) {
	var $it0 = properties.iterator();
	while( $it0.hasNext() ) {
		var p = $it0.next();
		if(js.Boot.__instanceof(p,com.onquery.pseudos.Pseudo)) signal = p.attach(signal); else if(js.Boot.__instanceof(p,com.onquery.filters.Filter)) signal.filters.add(p);
	}
	return signal;
};
com.onquery.core.Interpreter.interpt = function(input) {
	var ePseudo = new EReg("^:([:\\w]*)\\(([^\\)]*)\\)?","");
	var eConnector = new EReg("^[>+!&{}]","");
	var eOperator = new EReg("^[<>+~!@$%^&{};,=]+","");
	var eType = new EReg("^[_$#\\*\\-\\.\\w]+","");
	var eFilter = new EReg("^\\[[^\\]]*\\]","");
	var eSpace = new EReg("^\\s+","");
	var output = new List();
	while(input.length > 0) if(eSpace.match(input)) input = eSpace.replace(input,""); else if(eType.match(input)) {
		var type = eType.matched(0);
		input = eType.replace(input,"");
		var proto = new com.onquery.core.SignalPrototype();
		proto.type = type;
		output.add(proto);
	} else if(eFilter.match(input)) {
		var filter = eFilter.matched(0);
		input = eFilter.replace(input,"");
		filter = HxOverrides.substr(filter,1,null);
		filter = HxOverrides.substr(filter,0,filter.length - 1);
		var name = "";
		var operator = "";
		if(eType.match(filter)) {
			name = eType.matched(0);
			filter = eType.replace(filter,"");
		}
		if(eOperator.match(filter)) {
			operator = eOperator.matched(0);
			filter = eOperator.replace(filter,"");
		}
		var proto1 = com.onquery.core.Interpreter.lastPrototype(output);
		proto1.properties.add(new com.onquery.filters.PropertyFilter(name,operator,filter));
	} else if(ePseudo.match(input)) {
		var pseudo = com.onquery.pseudos.Pseudo.getInstance(ePseudo.matched(1),ePseudo.matched(2));
		input = ePseudo.replace(input,"");
		var proto2 = com.onquery.core.Interpreter.lastPrototype(output);
		proto2.properties.add(pseudo);
	} else if(eConnector.match(input)) {
		var c = eConnector.matched(0);
		var connector = com.onquery.core.Connector.registry.get(c);
		input = eConnector.replace(input,"");
		output.add(connector);
	} else throw "error parsing " + HxOverrides.substr(input,0,20);
	return output;
};
com.onquery.core.Interpreter.lastPrototype = function(input) {
	var proto = input.last();
	if(js.Boot.__instanceof(proto,com.onquery.core.SignalPrototype)) return proto;
	proto = new com.onquery.core.SignalPrototype();
	proto.type = "#zombie";
	input.add(proto);
	return proto;
};
com.onquery.core.SignalPrototype = function() {
	this.type = "";
	this.properties = new List();
};
com.onquery.core.SignalPrototype.__name__ = true;
com.onquery.core.SignalPrototype.prototype = {
	__class__: com.onquery.core.SignalPrototype
};
var js = {};
js.Boot = function() { };
js.Boot.__name__ = true;
js.Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else return o.__class__;
};
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
};
js.Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js.Boot.__interfLoop(js.Boot.getClass(o),cl)) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
com.onquery.filters = {};
com.onquery.filters.Filter = function() { };
com.onquery.filters.Filter.__name__ = true;
com.onquery.filters.Filter.prototype = {
	__class__: com.onquery.filters.Filter
};
com.onquery.filters.PropertyFilter = function(name,operator,value) {
	this.name = name;
	this.operator = operator;
	var eString = new EReg("\"(.*)\"","");
	var v = value;
	if(v == "true") v = true; else if(v == "false") v = false; else if(!Math.isNaN(v)) v = Std.parseFloat(v); else if(eString.match(v)) v = eString.matched(1);
	this.value = v;
};
com.onquery.filters.PropertyFilter.__name__ = true;
com.onquery.filters.PropertyFilter.__interfaces__ = [com.onquery.filters.Filter];
com.onquery.filters.PropertyFilter.contains = function(left,right) {
	return left.indexOf(right) > -1;
};
com.onquery.filters.PropertyFilter.exists = function(left,right) {
	return true;
};
com.onquery.filters.PropertyFilter.differs = function(left,right) {
	return left != right;
};
com.onquery.filters.PropertyFilter.equals = function(left,right) {
	return left == right;
};
com.onquery.filters.PropertyFilter.boolEquals = function(left,right) {
	return !(!left) == !(!right);
};
com.onquery.filters.PropertyFilter.greaterThan = function(left,right) {
	return left > right;
};
com.onquery.filters.PropertyFilter.lessThan = function(left,right) {
	return left < right;
};
com.onquery.filters.PropertyFilter.prototype = {
	match: function(args) {
		if(!com.onquery.filters.PropertyFilter.operators.exists(this.operator)) return false;
		var object = args;
		var names = this.name.split(".");
		var valid = true;
		while(names.length > 0) {
			var n = names.shift();
			if(n == "") n = 0; else n = n;
			if(!Reflect.hasField(object,n)) return false;
			object = Reflect.field(object,n);
		}
		return (com.onquery.filters.PropertyFilter.operators.get(this.operator))(object,this.value);
	}
	,__class__: com.onquery.filters.PropertyFilter
};
com.onquery.pseudos = {};
com.onquery.pseudos.Pseudo = function(n) {
	this.setName(n);
};
com.onquery.pseudos.Pseudo.__name__ = true;
com.onquery.pseudos.Pseudo.getInstance = function(name,value) {
	var pseudo = null;
	switch(name) {
	case "rewind":
		pseudo = new com.onquery.pseudos.RewindPseudo();
		break;
	case "pause":
		pseudo = new com.onquery.pseudos.PausePseudo();
		break;
	case "delay":
		pseudo = new com.onquery.pseudos.DelayPseudo();
		break;
	case "throttle":
		pseudo = new com.onquery.pseudos.ThrottlePseudo();
		break;
	default:
		pseudo = new com.onquery.pseudos.Pseudo(name);
	}
	pseudo.setValue(value);
	return pseudo;
};
com.onquery.pseudos.Pseudo.prototype = {
	getName: function() {
		return this._name;
	}
	,setName: function(value) {
		return this._name = value;
	}
	,getValue: function() {
		return this._value;
	}
	,setValue: function(val) {
		return this._value = val;
	}
	,attach: function(signal) {
		return signal;
	}
	,__class__: com.onquery.pseudos.Pseudo
};
com.onquery.pseudos.RewindPseudo = function() {
	com.onquery.pseudos.Pseudo.call(this,"rewind");
};
com.onquery.pseudos.RewindPseudo.__name__ = true;
com.onquery.pseudos.RewindPseudo.__super__ = com.onquery.pseudos.Pseudo;
com.onquery.pseudos.RewindPseudo.prototype = $extend(com.onquery.pseudos.Pseudo.prototype,{
	attach: function(signal) {
		var s = signal;
		s.setRewinder(com.onquery.core.Interpreter.compile(this.getValue(),s.getContext()));
		return signal;
	}
	,__class__: com.onquery.pseudos.RewindPseudo
});
com.onquery.pseudos.PausePseudo = function() {
	this.paused = false;
	com.onquery.pseudos.Pseudo.call(this,"pause");
};
com.onquery.pseudos.PausePseudo.__name__ = true;
com.onquery.pseudos.PausePseudo.__interfaces__ = [com.onquery.filters.Filter];
com.onquery.pseudos.PausePseudo.__super__ = com.onquery.pseudos.Pseudo;
com.onquery.pseudos.PausePseudo.prototype = $extend(com.onquery.pseudos.Pseudo.prototype,{
	attach: function(signal) {
		this._signal = signal;
		signal.filters.add(this);
		return signal;
	}
	,match: function(args) {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
		if(this.paused) {
			this.paused = false;
			return true;
		}
		this.lastArgs = args;
		this.timer = haxe.Timer.delay($bind(this,this.onPause),Std.parseInt("0" + this.getValue()));
		return false;
	}
	,onPause: function() {
		this.paused = true;
		this._signal.invokeListeners(this.lastArgs);
	}
	,__class__: com.onquery.pseudos.PausePseudo
});
com.onquery.pseudos.DelayPseudo = function() {
	this.delayed = false;
	com.onquery.pseudos.Pseudo.call(this,"delay");
};
com.onquery.pseudos.DelayPseudo.__name__ = true;
com.onquery.pseudos.DelayPseudo.__interfaces__ = [com.onquery.filters.Filter];
com.onquery.pseudos.DelayPseudo.__super__ = com.onquery.pseudos.Pseudo;
com.onquery.pseudos.DelayPseudo.prototype = $extend(com.onquery.pseudos.Pseudo.prototype,{
	attach: function(signal) {
		this._signal = signal;
		signal.filters.add(this);
		return signal;
	}
	,match: function(args) {
		var _g = this;
		if(this.delayed) {
			this.delayed = false;
			return true;
		}
		var onDelay = function() {
			_g.delayed = true;
			_g._signal.invokeListeners(args);
		};
		haxe.Timer.delay(onDelay,Std.parseInt("0" + this.getValue()));
		return false;
	}
	,__class__: com.onquery.pseudos.DelayPseudo
});
com.onquery.pseudos.ThrottlePseudo = function() {
	this.throttling = false;
	com.onquery.pseudos.Pseudo.call(this,"throttle");
};
com.onquery.pseudos.ThrottlePseudo.__name__ = true;
com.onquery.pseudos.ThrottlePseudo.__interfaces__ = [com.onquery.filters.Filter];
com.onquery.pseudos.ThrottlePseudo.__super__ = com.onquery.pseudos.Pseudo;
com.onquery.pseudos.ThrottlePseudo.prototype = $extend(com.onquery.pseudos.Pseudo.prototype,{
	attach: function(signal) {
		this._signal = signal;
		signal.filters.add(this);
		return signal;
	}
	,match: function(args) {
		if(this.throttling) return false;
		this.throttling = true;
		haxe.Timer.delay($bind(this,this.onThrottle),Std.parseInt("0" + this.getValue()));
		return true;
	}
	,onThrottle: function() {
		this.throttling = false;
	}
	,__class__: com.onquery.pseudos.ThrottlePseudo
});
com.onquery.core.SignalToken = function(signal) {
	this.time = 0;
	this.count = 0;
	this.setSignal(signal);
};
com.onquery.core.SignalToken.__name__ = true;
com.onquery.core.SignalToken.prototype = {
	getSignal: function() {
		return this._signal;
	}
	,setSignal: function(value) {
		if(this._signal == value) return this._signal;
		this._signal = value;
		if(this._signal != null) this._signal.addListener($bind(this,this.refresh));
		return this._signal;
	}
	,refresh: function(args) {
		this.time = com.onquery.core.SignalToken.currentTime++;
		this.count++;
	}
	,reset: function() {
		this.count = 0;
		this.time = 0;
	}
	,__class__: com.onquery.core.SignalToken
};
com.onquery.core.Connector = function(connect,argc,precedence,leftAssociative) {
	if(leftAssociative == null) leftAssociative = false;
	if(precedence == null) precedence = 0;
	if(argc == null) argc = 0;
	this.connect = connect;
	this.argc = argc;
	this.precedence = precedence;
	this.leftAssociative = leftAssociative;
};
com.onquery.core.Connector.__name__ = true;
com.onquery.core.Connector.prototype = {
	__class__: com.onquery.core.Connector
};
com.onquery.signals = {};
com.onquery.signals.CoreSignal = function(c) {
	this._context = new com.onquery.SignalContext(c);
	this._context.set("this",this);
	this.listeners = new com.onquery.collections.ListenersArray(this.getTarget());
};
com.onquery.signals.CoreSignal.__name__ = true;
com.onquery.signals.CoreSignal.__interfaces__ = [com.onquery.collections.ListenersCollection];
com.onquery.signals.CoreSignal.prototype = {
	getContext: function() {
		return this._context;
	}
	,getTarget: function() {
		return com.onquery.utils.ContextUtils.getTarget(this._context);
	}
	,getType: function() {
		return this._type;
	}
	,setType: function(value) {
		return this._type = value;
	}
	,addListener: function(listener) {
		this.listeners.addListener(listener);
	}
	,removeListener: function(listener) {
		this.listeners.removeListener(listener);
	}
	,removeAllListeners: function() {
		this.listeners.removeAllListeners();
	}
	,invokeListeners: function(args) {
		this.lastArgs = args;
		this.listeners.invokeListeners(args);
	}
	,__class__: com.onquery.signals.CoreSignal
};
com.onquery.signals.Signal = function(c) {
	com.onquery.signals.CoreSignal.call(this,c);
	this.filters = new List();
};
com.onquery.signals.Signal.__name__ = true;
com.onquery.signals.Signal.__super__ = com.onquery.signals.CoreSignal;
com.onquery.signals.Signal.prototype = $extend(com.onquery.signals.CoreSignal.prototype,{
	setType: function(t) {
		t = com.onquery.signals.CoreSignal.prototype.setType.call(this,t);
		this.getTarget().addEventListener(t,$bind(this,this.handle),false);
		return t;
	}
	,dispose: function() {
		this.getTarget().removeEventListener(this.getType(),$bind(this,this.handle),false);
		this.listeners = null;
	}
	,handle: function(event) {
		this.invokeListeners(arguments);
	}
	,invokeListeners: function(args) {
		var $it0 = this.filters.iterator();
		while( $it0.hasNext() ) {
			var f = $it0.next();
			if(!f.match(args)) return;
		}
		com.onquery.signals.CoreSignal.prototype.invokeListeners.call(this,args);
	}
	,__class__: com.onquery.signals.Signal
});
com.onquery.signals.CombinedSignal = function(c) {
	com.onquery.signals.Signal.call(this,c);
	this.setRewinder(this);
};
com.onquery.signals.CombinedSignal.__name__ = true;
com.onquery.signals.CombinedSignal.__super__ = com.onquery.signals.Signal;
com.onquery.signals.CombinedSignal.prototype = $extend(com.onquery.signals.Signal.prototype,{
	setRewinder: function(value) {
		if(this._rewinder != null) this._rewinder.removeListener($bind(this,this.rewind));
		this._rewinder = value;
		if(this._rewinder != null) this._rewinder.addListener($bind(this,this.rewind));
		return this._rewinder;
	}
	,rewind: function(args) {
		throw "not implimented";
	}
	,__class__: com.onquery.signals.CombinedSignal
});
com.onquery.signals.IntervalSignal = function(c,delay) {
	com.onquery.signals.CombinedSignal.call(this,c);
	this.delay = delay;
	this.rewind(null);
};
com.onquery.signals.IntervalSignal.__name__ = true;
com.onquery.signals.IntervalSignal.build = function(p,c) {
	return new com.onquery.signals.IntervalSignal(c,Std.parseInt(com.onquery.core.Build.popArg(p)));
};
com.onquery.signals.IntervalSignal.__super__ = com.onquery.signals.CombinedSignal;
com.onquery.signals.IntervalSignal.prototype = $extend(com.onquery.signals.CombinedSignal.prototype,{
	tick: function() {
		this.invokeListeners([]);
	}
	,rewind: function(args) {
		if(this.timer != null) this.timer.stop();
		this.timer = new haxe.Timer(this.delay);
		this.timer.run = $bind(this,this.tick);
	}
	,dispose: function() {
		if(this.timer != null) {
			this.timer.stop();
			this.timer = null;
		}
		com.onquery.signals.CombinedSignal.prototype.dispose.call(this);
	}
	,__class__: com.onquery.signals.IntervalSignal
});
com.onquery.signals.AllSignal = function(c,t) {
	com.onquery.signals.CombinedSignal.call(this,c);
	this.queue = new List();
	var $it0 = t.iterator();
	while( $it0.hasNext() ) {
		var token = $it0.next();
		this.queue.add(new com.onquery.core.SignalToken(token));
		token.addListener($bind(this,this.recheck));
	}
	this.rewind(null);
};
com.onquery.signals.AllSignal.__name__ = true;
com.onquery.signals.AllSignal.build = function(p,c) {
	var l = com.onquery.core.Interpreter.interpt(com.onquery.core.Build.popArg(p));
	var t = new List();
	var $it0 = l.iterator();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		t.add(com.onquery.core.Interpreter.build(e,c));
	}
	var s = new com.onquery.signals.AllSignal(c,t);
	s.setType(p.type);
	return s;
};
com.onquery.signals.AllSignal.__super__ = com.onquery.signals.CombinedSignal;
com.onquery.signals.AllSignal.prototype = $extend(com.onquery.signals.CombinedSignal.prototype,{
	rewind: function(args) {
		var $it0 = this.queue.iterator();
		while( $it0.hasNext() ) {
			var t = $it0.next();
			t.reset();
		}
	}
	,recheck: function(args) {
		var all = true;
		var i = this.queue.iterator();
		while(all && i.hasNext()) all = i.next().count > 0;
		if(all) {
			this.lastArgs = [];
			var $it0 = this.queue.iterator();
			while( $it0.hasNext() ) {
				var t = $it0.next();
				this.lastArgs.push(t.getSignal().lastArgs);
			}
			this.invokeListeners(this.lastArgs);
		}
	}
	,__class__: com.onquery.signals.AllSignal
});
com.onquery.signals.SequenceSignal = function(c,t) {
	com.onquery.signals.CombinedSignal.call(this,c);
	this.queue = t;
	this.rewind();
};
com.onquery.signals.SequenceSignal.__name__ = true;
com.onquery.signals.SequenceSignal.build = function(p,c) {
	var l = com.onquery.core.Interpreter.interpt(com.onquery.core.Build.popArg(p));
	var t = [];
	var $it0 = l.iterator();
	while( $it0.hasNext() ) {
		var e = $it0.next();
		t.push(com.onquery.core.Interpreter.build(e,c));
	}
	var s = new com.onquery.signals.SequenceSignal(c,t);
	s.setType(p.type);
	return s;
};
com.onquery.signals.SequenceSignal.__super__ = com.onquery.signals.CombinedSignal;
com.onquery.signals.SequenceSignal.prototype = $extend(com.onquery.signals.CombinedSignal.prototype,{
	rewind: function(e) {
		this.reset();
		this.nextSignal();
	}
	,reset: function() {
		var _g = 0;
		var _g1 = this.queue;
		while(_g < _g1.length) {
			var signal = _g1[_g];
			++_g;
			signal.removeListener($bind(this,this.nextSignal));
		}
		this.index = -1;
	}
	,nextSignal: function(args) {
		var next = ++this.index;
		if(next == this.queue.length) {
			this.lastArgs = this.queue.map(function(s) {
				return s.lastArgs;
			});
			this.invokeListeners(this.lastArgs);
		} else {
			next %= this.queue.length;
			this.reset();
			this.index = next;
			this.queue[next].addListener($bind(this,this.nextSignal));
		}
	}
	,dispose: function() {
		this.reset();
		com.onquery.signals.CombinedSignal.prototype.dispose.call(this);
	}
	,__class__: com.onquery.signals.SequenceSignal
});
com.onquery.signals.ZombieSignal = function(c) {
	com.onquery.signals.Signal.call(this,c);
};
com.onquery.signals.ZombieSignal.__name__ = true;
com.onquery.signals.ZombieSignal.build = function(p,c) {
	var s = new com.onquery.signals.ZombieSignal(c);
	s.properties = p.properties;
	p.properties = new List();
	return s;
};
com.onquery.signals.ZombieSignal.__super__ = com.onquery.signals.Signal;
com.onquery.signals.ZombieSignal.prototype = $extend(com.onquery.signals.Signal.prototype,{
	__class__: com.onquery.signals.ZombieSignal
});
com.onquery.signals.ConnectedSignal = function(c,t) {
	com.onquery.signals.CombinedSignal.call(this,c);
	this.queue = new List();
	this.signals = [];
	this.setTokens(t);
};
com.onquery.signals.ConnectedSignal.__name__ = true;
com.onquery.signals.ConnectedSignal.__super__ = com.onquery.signals.CombinedSignal;
com.onquery.signals.ConnectedSignal.prototype = $extend(com.onquery.signals.CombinedSignal.prototype,{
	rewind: function(args) {
		var $it0 = this.queue.iterator();
		while( $it0.hasNext() ) {
			var token = $it0.next();
			if(js.Boot.__instanceof(token,com.onquery.core.SignalToken)) token.reset();
		}
	}
	,recheck: function(args) {
		var count = this.reduce().count;
		if(count > 0) {
			this.lastArgs = this.signals.map(function(s) {
				return s.lastArgs;
			});
			this.invokeListeners(this.lastArgs);
		}
	}
	,reduce: function() {
		var stack = new List();
		var len = 0;
		var token;
		var q = this.queue.map(function(o) {
			return o;
		});
		while(token = q.pop()) if(js.Boot.__instanceof(token,com.onquery.core.SignalToken)) {
			stack.push(token);
			++len;
		} else if(js.Boot.__instanceof(token,com.onquery.core.Connector)) {
			var connector = token;
			if(len < connector.argc) throw "too few arguments for operator";
			var args = new List();
			args.add(stack.pop());
			if(connector.argc == 2) args.push(stack.pop());
			len -= connector.argc - 1;
			var j = connector.connect(args);
			stack.push(j);
		} else throw "unexpected token";
		if(stack.length == 1) return stack.pop();
		throw "too many values";
	}
	,setTokens: function(tokens) {
		var stack = new List();
		var $it0 = tokens.iterator();
		while( $it0.hasNext() ) {
			var token = $it0.next();
			if(js.Boot.__instanceof(token,com.onquery.signals.Signal)) {
				this.signals.push(token);
				this.queue.add(new com.onquery.core.SignalToken(token));
				token.addListener($bind(this,this.recheck));
			} else if(js.Boot.__instanceof(token,com.onquery.core.Connector)) {
				var c = token;
				if(c == com.onquery.core.Connector.OPEN) stack.push(c); else if(c == com.onquery.core.Connector.CLOSE) {
					var found = false;
					var o;
					while(o = stack.pop()) {
						if(o == com.onquery.core.Connector.OPEN) {
							found = true;
							break;
						}
						this.queue.add(o);
					}
					if(!found) throw "unmatched parentheses";
				} else {
					var op1 = c;
					var o1;
					while(o1 = stack.first()) {
						var op2 = o1;
						if(op2 == com.onquery.core.Connector.OPEN || op2 == com.onquery.core.Connector.CLOSE) break;
						var p1 = op1.precedence;
						var p2 = op2.precedence;
						if(!(op1.leftAssociative && p1 <= p2 || p1 < p2)) break;
						this.queue.add(stack.pop());
					}
					stack.push(op1);
				}
			} else throw "unknown token";
		}
		var token1;
		while(token1 = stack.pop()) {
			if(token1 == com.onquery.core.Connector.OPEN || token1 == com.onquery.core.Connector.CLOSE) throw "unmatched parentheses";
			this.queue.add(token1);
		}
	}
	,__class__: com.onquery.signals.ConnectedSignal
});
com.onquery.core.Build = function() { };
com.onquery.core.Build.__name__ = true;
com.onquery.core.Build.popArg = function(p) {
	var arg = "";
	var f = p.properties.first();
	if(js.Boot.__instanceof(f,com.onquery.pseudos.Pseudo) && f.getName() == "") {
		arg = f.getValue();
		p.properties.pop();
	}
	return arg;
};
com.onquery.core.Build.wrap = function(prototype,context) {
	return com.onquery.core.Interpreter.compile(com.onquery.core.Build.popArg(prototype),context);
};
com.onquery.utils = {};
com.onquery.utils.ContextUtils = function() { };
com.onquery.utils.ContextUtils.__name__ = true;
com.onquery.utils.ContextUtils.getTarget = function(context) {
	return context.get("_target_");
};
com.onquery.utils.ContextUtils.setTarget = function(context,target) {
	return context.set("_target_",target);
};
com.onquery.utils.ContextUtils.getWatcher = function(context) {
	return context.get("_watcher_");
};
com.onquery.utils.ContextUtils.setWatcher = function(context,watcher) {
	return context.set("_watcher_",watcher);
};
com.onquery.utils.ContextUtils.getContext = function(target) {
	var e = new Event("_context_");
	target.dispatchEvent(e);
	if(e.context == null) {
		var c = new com.onquery.SignalContext();
		c.setParent(com.onquery.OnQuery.globalContext);
		com.onquery.utils.ContextUtils.setTarget(c,target);
		new com.onquery.Watcher(c);
		target.addEventListener("_context_",function(e1) {
			e1.context = c;
		});
		return c;
	}
	return e.context;
};
haxe.Timer = function(time_ms) {
	var me = this;
	this.id = setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = true;
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
};
haxe.Timer.prototype = {
	stop: function() {
		if(this.id == null) return;
		clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i1) {
	return isNaN(i1);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
com.onquery.OnQuery.globalContext = new com.onquery.SignalContext((function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("version","0.0.1");
	$r = _g;
	return $r;
}(this)));
com.onquery.filters.PropertyFilter.operators = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("",com.onquery.filters.PropertyFilter.exists);
	_g.set("=",com.onquery.filters.PropertyFilter.equals);
	_g.set("*=",com.onquery.filters.PropertyFilter.contains);
	_g.set("!=",com.onquery.filters.PropertyFilter.differs);
	_g.set("==",com.onquery.filters.PropertyFilter.boolEquals);
	_g.set(">",com.onquery.filters.PropertyFilter.greaterThan);
	_g.set("<",com.onquery.filters.PropertyFilter.lessThan);
	$r = _g;
	return $r;
}(this));
com.onquery.core.SignalToken.currentTime = 1;
com.onquery.core.Connector.OPEN = new com.onquery.core.Connector(null);
com.onquery.core.Connector.CLOSE = new com.onquery.core.Connector(null);
com.onquery.core.Connector.NOT = new com.onquery.core.Connector(function(l) {
	var token = new com.onquery.core.SignalToken();
	var arg = l.first();
	token.time = arg.time;
	if(arg.count > 0) token.count = 0; else token.count = 1;
	return token;
},1,100,false);
com.onquery.core.Connector.OR = new com.onquery.core.Connector(function(l) {
	var token = new com.onquery.core.SignalToken();
	var left = l.first();
	var right = l.last();
	token.time = Math.max(left.time,right.time);
	token.count = Math.max(left.count,right.count);
	return token;
},2,80,false);
com.onquery.core.Connector.AND = new com.onquery.core.Connector(function(l) {
	var token = new com.onquery.core.SignalToken();
	var left = l.first();
	var right = l.last();
	token.time = Math.max(left.time,right.time);
	token.count = Math.min(left.count,right.count);
	return token;
},2,90,false);
com.onquery.core.Connector.NEXT = new com.onquery.core.Connector(function(l) {
	var left = l.first();
	var right = l.last();
	var token = new com.onquery.core.SignalToken();
	if(left.time < right.time) {
		token.count = Math.min(left.count,right.count);
		token.time = right.time;
	}
	return token;
},2,70,true);
com.onquery.core.Connector.registry = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("+",com.onquery.core.Connector.OR);
	_g.set("!",com.onquery.core.Connector.NOT);
	_g.set("&",com.onquery.core.Connector.AND);
	_g.set(">",com.onquery.core.Connector.NEXT);
	_g.set("{",com.onquery.core.Connector.OPEN);
	_g.set("}",com.onquery.core.Connector.CLOSE);
	$r = _g;
	return $r;
}(this));
com.onquery.core.Build.registry = (function($this) {
	var $r;
	var _g = new haxe.ds.StringMap();
	_g.set("",com.onquery.core.Build.wrap);
	_g.set("timeout",null);
	_g.set("interval",com.onquery.signals.IntervalSignal.build);
	_g.set("any",null);
	_g.set("all",com.onquery.signals.AllSignal.build);
	_g.set("seq",com.onquery.signals.SequenceSignal.build);
	_g.set("zombie",com.onquery.signals.ZombieSignal.build);
	$r = _g;
	return $r;
}(this));
com.onquery.OnQuery.main();
})(typeof window != "undefined" ? window : exports);
