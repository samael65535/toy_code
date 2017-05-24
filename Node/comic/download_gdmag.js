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
			var attribs = data[prop].attribs;
			if (attribs && attribs.href) {
				fileList.unshift(attribs.href);
			}
		}

		var data = $("[href$='.zip']");
		for (var prop in data) {
			var attribs = data[prop].attribs;
			if (attribs && attribs.href) {
				fileList.unshift(attribs.href);
			}
		}

		fs.writeFile("gdmag.txt", fileList.join('\n'),(err) => {
			if (err) throw err;
		});

		var downloadList = [];
		for (var idx in fileList) {
			var file = fileList[idx].split('/').pop();
			if (fs.existsSync(outPath + file) == false) {
				downloadList.push(fileList[idx].replace(new RegExp(' ', 'g'), '%20'));
			}
		}
		console.log(downloadList.join(' '))
		var wget = cp.exec("wget " + downloadList.join(' ') + " -P " + outPath,  {maxBuffer: 1024*500}, (err, stdout, stderr) => {
			if (err) throw err;

		});
		wget.stderr.pipe(process.stderr);
	});

};

app()
