/**
 * Created by samael on 15-7-17.
 */
//http://www.wnacg.com/download-index-aid-18457.html
var request = require('request');
var cheerio = require('cheerio');
var http = require('http');
var fs = require('fs');
var async = require('async');
var hentaiURL = "http://www.wnacg.com/";
var outPath = "./output.txt";
var maxPage = 0
function kumakichi(i, cb) {
    var url = hentaiURL + "albums-index-page-" + i + "-cate-6.html";

    request(url, function(error, response, body){
        var result = {};
        if (error) {
            return;
        }
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
            }
        });
        cb(null, result, i);
    });
}

function hashida(originData, page, cb) {
    // 处理二级目录
    var hentaiData = {};
    var keys = Object.keys(originData);
    var totalFileNum = keys.length;

    keys.forEach(function(url) {
        request(url, function (error, response, body) {
            if (error) {
                console.log(error.message);
                return;
            }
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
                var outStr = "";
                Object.keys(hentaiData).forEach(function(key) {
                    console.log(key + '\t' + hentaiData[key] + "\n");
                    outStr += key + '\t' + hentaiData[key] + "\n";
                });
                fs.appendFileSync(outPath, outStr);
                cb(null,  page+1);
            }
        })
    });
}


module.exports = function(maxPage, outPath) {
    // 加工一级目录
    maxPage = maxPage;
    fs.exists(outPath, function(exists) {
        if (exists) fs.unlinkSync(outPath);
    });
    var funcs = [function(cb) {
        cb(null, 1)
    }]
    for (var i = 1; i <= maxPage; i++) {
        funcs.push(function(n ,cb) {
            kumakichi(n, cb)
        });
        funcs.push(function(n, page, cb) {
            hashida(n, page, cb)
        });

    }
    async.waterfall(funcs, function(err,cb) {
        if (err) return ;
        console.log("Enjoy it! Hentai");
    });
};