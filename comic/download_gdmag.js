var gdmag = "http://gdcvault.com/gdmag";
var request = require('request')
var cheerio = require('cheerio')
var fs = require('fs');
var cp = require('child_process');
var outPath = "./gdmag/"
var fileList = [];

var app = function() {
	request(gdmag, function(err, res, body) {
		if(err) return;
		var $ = cheerio.load(body)
		var data = $("[href$='.pdf']");
		for (var prop in data) {
			var attribs = data[prop].attribs
			if (attribs && attribs.href) {
				fileList.unshift(attribs.href);
			}
		}

		var data = $("[href$='.zip']");
		for (var prop in data) {
			var attribs = data[prop].attribs
			if (attribs && attribs.href) {
				fileList.unshift(attribs.href);
			}
		}
		console.log(fileList.join('\n'));
		fs.writeFile("gdmag.txt", fileList.join('\n'),(err) => {
			if (err) throw err;
			console.log("OK!")
		});
		var wget = cp.exec("wget -i gdmag.txt -P " + outPath,  (err, stdout, stderr) => {
			if (err) throw err;

		});
		wget.stderr.pipe(process.stderr);
	});

};
app()
