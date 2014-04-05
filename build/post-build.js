
require('shelljs/global');
var argv = require('optimist').argv;
var fs = require('fs');

cp('-rf', 'dist/*', 'test');

if(argv.config=='release'){
	rm('-rf', 'docs');
	rm('-rf', 'pages/docs');
	mkdir('docs');
	mv('dist/haxedoc.xml','docs/');
	exec('haxelib run dox -i docs -o docs -r /onQuery/docs/ --title onQuery',{async:true,silent:true}, function(code, output) {
		mv('docs','pages/');
		console.log('Generating docs:',code==0?'success':'failed');
	});
	uglify('dist/js/onquery.js', 'dist/js/onquery.min.js');

}

function uglify(srcPath, distPath) {
    var UglifyJS = require('uglify-js');
	var result = UglifyJS.minify(srcPath);    
    fs.writeFileSync(distPath,result.code);
    console.log('Minifying:',distPath,'done.');
}


//var glob = require("glob");
/*glob("dist/**", {}, function (er, files) {
  console.log(files);
})*/