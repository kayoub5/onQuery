
require('shelljs/global');
var Mustache=require('mustache');
var argv = require('optimist').argv;
var fs = require('fs');
//files
var f={};
f.config='build/config.json';
f.build_template='build/template/';
f.docs='pages/docs/';
f.dist='dist/';
f.test='test/';

var config=JSON.parse(fs.readFileSync("build/config.json","utf-8"));
config.ver.build++;
config.version=config.ver.major+"."+config.ver.minor+"."+config.ver.patch;//+"-b"+config.ver.build;
console.log('build:',config.ver.build);

//copy dist to test
cp('-rf',f.dist+'*', f.test+'js/');

if(argv.config=='release'){
	//generate docs
	rm('-rf', f.docs);
	mkdir(f.docs);
	mv(f.dist+'onQuery.xml',f.docs);
	exec('haxelib run dox -i '+f.docs+' -o '+f.docs+' -r /onQuery/docs/ --title onQuery',{async:true,silent:true}, function(code, output) {
		console.log('Generating docs:',code==0?'success':'failed');
	});
	
	//Minifying
	var UglifyJS = require('uglify-js');
	var result = UglifyJS.minify(f.dist+'onquery.js');
    /*! onQuery v1.11.0 | (c) 2014 Ayoub Kaanich | onquery.org/license */
    fs.writeFile(f.dist+'onquery.min.js',result.code,function(err){
		if(err)throw err;
		console.log('Minifying: done.');
	});
	
	render('package.json');
	render('README.md');
    
}

function render(name){
	fs.readFile(f.build_template+name,'utf-8', function (err, template) {
		if (err) throw err;
		var output = Mustache.render(template,config);
		fs.writeFile(name,output,function(err){
			if(err)throw err;
			console.log('rendering ',name,': done.')
		});
	});
}

fs.writeFileSync(f.config,JSON.stringify(config,null,4));

//var glob = require("glob");
/*glob("dist/**", {}, function (er, files) {
  console.log(files);
})*/