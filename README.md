# onQuery #


### Description ###
onQuery is an event querying engine for JavaScript


### STATUS ###
this library is still BETA so use it with caution. 


### Features ###
* Event filtering
`event[foo="bar"]`
* Event chaining 
`event1 > event2`
* altering Event behaviour `event:pause(3000)`


### Examples ###
```javascript

	//logging function
	function log(data){
		console.log(data);
	}
	
	//creating an events watcher
	var w=OnQuery.watch(window);
	
	//dragging= mousedown then mousemove,if a mouseup interept try again
	w.bind('*:(mousedown>mousemove):rewind(mouseup)',log);
	
	//click while holding shift key
	w.bind('click[shiftKey==true]',log);
	
	//either a click or keydown
	w.bind('click + keydown',log);
	
	//after the mouse stop moving for 10 sec = 10000 milliseconds
	watch(document).bind('mousemove:pause(10000)',log);
			
```


### Author ###
Ayoub Kaanich kayoub5@gmail.com

### Licence ###
[Attribution-NonCommercial-NoDerivs 3.0 Unported](http://creativecommons.org/licenses/by-nc-nd/3.0/)
