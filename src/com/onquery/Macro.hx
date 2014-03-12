package com.onquery;

import haxe.macro.Expr;
class Macro {
	/*macro public static function build() : Array<Field> {

		var pos = haxe.macro.Context.currentPos();
		var fs:Array<Field> = haxe.macro.Context.getBuildFields();
		var ns:Array<Field>=new Array<Field>();
		for(f in fs){
			ns.push(f);
			var hasGet:Bool=false;
			var hasSet:Bool=false;
			for(meta in f.meta){
				if(meta.name==':getter'){
					hasGet=true;
				}
				if(meta.name==':setter'){
					hasSet=true;
				}
				if(meta.name==':property'){
					hasSet=true;
					hasGet=true;
				}
			}
			//#if js
				if(hasGet && hasSet){
					//ns.remove(f);

				}
			//#end
			
//if(f.kind){
	
			//f.meta.push({name:'meta',params:[{
			//	pos:pos,expr:EConst(CString((f.kind)+''))
			//	}],pos:pos});
//}
  //      	ns.push({ name : c, doc : null, meta : [], access : [], kind : FVar(null,null), pos : pos })
            //c.kind=FProp('get_foo','', t:ComplexType, e:Expr
        }
        return ns;
    }*/
}
