# onQuery #
_______________________________________

### Description ###
onQuery is an event querying engine for JavaScript


### STATUS ###
this library is still ALPHA so use it with caution. 


### Features ###
* Event filtering
`event[foo="bar"]`
* Event chaining 
`event1 > event2`
* altering Event behaviour `event:pause(3000)`


### Example ###
```javascript

	function log(data){
		console.log(data);
	}
	var w=OnQuery.watch(window);
	w.bind('*:(mousedown>mousemove):rewind(mouseup)',log);//dragging
	w.bind('click[shiftKey==true]',log);//click+shif
			
```

________________________________
### Author ###
Ayoub Kaanich kayoub5@gmail.com
### Licence ###
[Attribution-NonCommercial-NoDerivs 3.0 Unported](http://creativecommons.org/licenses/by-nc-nd/3.0/)