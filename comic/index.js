/**
 * Created by samael on 15-7-17.
 */
//http://www.wnacg.com/download-index-aid-18457.html
var request = require('request');
var cheerio = require('cheerio');
var hentaiURL = "http://www.wnacg.com/";
var fs = require('fs');
function kumakichi(maxPage, outPath) {
    // 加工一级目录
    var page = 1;
    var result = {};
    for (var i = 1; i <= maxPage; i++) {
        var url = hentaiURL + "albums-index-page-" + i + "-cate-6.html";
        request(url, function(error, response, body){
            var re = /photos-index-aid-[0-9]*\.html*/;
            var k = body.split('\n');
            k.forEach(function(str) {
                var s = str.match(re);
                var newUrl = s
                    ? hentaiURL + s[0].replace('photos', 'download') :
                    null;

                if (newUrl && !result[newUrl]) {
                    var $ = cheerio.load(s.input);
                    var filename = $('a').text();
                    result[newUrl] = filename;
                    console.log(filename);
                }
            });
            if (page == maxPage) {
                hashida(result, outPath);
            } else {
                page++;
            }
        });
    }
}

function hashida(originData, outFile) {
    // 处理二级目录
    var hentaiData = {};
    var keys = Object.keys(originData);
    var totalFileNum = keys.length;
    keys.forEach(function(url, index) {
        request(url, function (error, response, body) {
            var re = /down_btn*/;
            var k = body.split('\n');
            var filename = originData[url];
            k.forEach(function (str) {
                var s = str.match(re);
                var downUrl = s
                    ? cheerio.load(s.input)('a').attr('href')
                    : null;
                if (s && hentaiData[downUrl] == undefined) {
                    hentaiData[downUrl] = filename;
                }
            });
            totalFileNum--;
            if (totalFileNum == 0) {
                fs.exists(outFile, function(exists) {
                    if (exists) fs.unlinkSync(outFile);
                });
                Object.keys(hentaiData).forEach(function(key) {
                    console.log(key + '\t' + hentaiData[key] + "\n");
                    fs.appendFile(outFile,  key + '\t' + hentaiData[key] + "\n");
                });
                console.log('Hentai! Enjoy it!');
            }
        })
    })
}

module.exports = kumakichi