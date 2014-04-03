package com.onquery.signals;


import com.onquery.core.*;
import com.onquery.OnQuery;

@:expose("ConnectedSignal")
class ConnectedSignal extends CombinedSignal{

	public var queue:List<Dynamic>;
	
	public function new(c:SignalContext,t:List<Dynamic>) {
		super(c);
		queue=new List<Dynamic>();
		setTokens(t);
	}

	override public function rewind(event:Dynamic = null) {
		for (token in  queue){
			if(Std.is(token,SignalToken)){
				token.reset();
			}
		}
	}

	public function recheck(event:Dynamic=null){
		var count:Float=reduce().count;
		if(count>0){
			invokeListeners(new Event(getType()));
		}
	}

	public function reduce():SignalToken {
		var stack =new List<Dynamic>();
		var len:Int = 0, token:Dynamic;
		var q:List<Dynamic>=queue.map(function(o:Dynamic):Dynamic{return o;});
			// While there are input tokens left
			// Read the next token from input.
			while (token = q.pop()) {
				
				if(Std.is(token,SignalToken)){
					// If the token is a value or identifier
					// Push it onto the stack.
					stack.push(token);
					++len;
				}
				else if(Std.is(token,Connector)){
					var connector:Connector=token;
					// It is known a priori that the operator takes n arguments.
					// If there are fewer than n values on the stack
					if (len < connector.argc) throw 'too few arguments for operator';
					
					var args:List<SignalToken>=new List<SignalToken>();
					args.add(stack.pop());
					if (connector.argc == 2)args.push(stack.pop());

					len -= (connector.argc - 1);

					// Push the returned results, if any, back onto the stack.
					var j:SignalToken=connector.connect(args);
					stack.push(j);

				}
				else{
					throw 'unexpected token';
				}
			}

		// If there is only one value in the stack
		// That value is the result of the calculation.
		if (stack.length == 1)return stack.pop();

		// If there are more values in the stack
		// (Error) The user input has too many values.
		throw 'too many values';
	}

	private function setTokens(tokens:List<Dynamic>){
		var stack=new List<Connector>();
		for(token in tokens){
			if (Std.is(token,Signal)) {
				// If the token is a SignalToken, then add it to the output queue. 
				queue.add(new SignalToken(token));
				token.addListener(recheck);
			}
			else if(Std.is(token,Connector)){
				var c:Connector= cast token;
				if(c==Connector.OPEN){
					// If the token is a left parenthesis, then push it onto the stack.
					stack.push(c);
				}
				else if(c==Connector.CLOSE){
					// If the token is a right parenthesis:  
					var found:Bool = false;
					// Until the token at the top of the stack is a left parenthesis,
					// pop operators off the stack onto the output queue
					var o:Dynamic;
					while (o = stack.pop()) {
						if (o == Connector.OPEN) {
							// Pop the left parenthesis from the stack, but not onto the output queue.
							found = true;
							break;
						}
						queue.add(o);
					}

					// If the stack runs out without finding a left parenthesis, then there are mismatched parentheses.
					if (!found)throw 'unmatched parentheses';
				}
				else {
					// If the token is an operator, op1, then:
					var op1:Connector=c;
					// While there is an operator token, o2, at the top of the stack
					var o:Dynamic;
					while (o = stack.first()) {
						var op2:Connector=o;
						if(op2==Connector.OPEN || op2==Connector.CLOSE)	break;
						/* op1 is left-associative and its precedence is less than or equal to that of op2,
						or op1 has precedence less than that of op2,
						Let + and ^ be right associative.
						Correct transformation from 1^2+3 is 12^3+
					 	The differing operator priority decides pop / push
					 	If 2 operators have equal priority then associativity decides.
					 	*/
					 	var p1:Int = op1.precedence;
					 	var p2:Int = op2.precedence;

					 	if (!((op1.leftAssociative && (p1 <= p2)) || (p1 < p2))) break;

						// Pop o2 off the stack, onto the output queue;
						queue.add(stack.pop());
					}
					// push op1 onto the stack.
					stack.push(op1);
				}
			}
			else{
				throw ('unknown token');     
			}
		}
		var token:Dynamic;
		while (token = stack.pop()) {
			if (token == Connector.OPEN || token == Connector.CLOSE)
			throw 'unmatched parentheses';
			queue.add(token);
		}

	}


}