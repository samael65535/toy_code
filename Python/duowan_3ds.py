# -*- coding: utf-8 -*-
# 抓取多玩上3DS ROM
import urllib
import urllib2
import re
pattern_item     = r'<h4><a target="_blank" href="http://tvgdb.duowan.com/3ds/[0-9]*/[0-9].html">.*?</a></h4>'
pattern_title    = r'<h4><a target="_blank" href="http://tvgdb.duowan.com/3ds/[0-9]*/[0-9].html">(.*?)</a></h4>'
pattern_address  = r'<h4><a target="_blank" href="(http://tvgdb.duowan.com/3ds/[0-9]*/[0-9].html)">.*?</a></h4>'
pattern_bbs      = r'</b><a target="_blank" href="(.*?)">'
# pattern_download = r'<a href="(http://kuai.*?)" target="_blank">'
pattern_download = r'<a href="(http://pan.*?)" target="_blank">'
pattern_password = r'<font color="blue">' + u'点击从百度下载该游戏' + r'</font></a>'+ u' 密码:' + r'(.*?)<'
fp   = open("3DS_ROM.txt", 'a')
# 得到多玩3ds rom地址
def Get3DSROM(address):
    response       = urllib2.urlopen(address)
    html           = response.read()
    htmlutf        = html.decode('utf-8')
    bbs_address    = re.findall(pattern_download, htmlutf, re.S)
    bbs_password   = re.findall(pattern_password, htmlutf, re.S)
    # return ''.join(bbs_address)
    return [''.join(bbs_address), ''.join(bbs_password)]

# 得到多玩3ds BBS的地址
def Get3DSBBS(title, address):
    response       = urllib2.urlopen(address)
    html           = response.read()
    htmlutf        = html.decode('utf-8')
    bbs_address    = re.findall(pattern_bbs, htmlutf, re.S)
    return Get3DSROM(''.join(bbs_address))

# 得到多玩可下载的3ds标题
def Get3DSTitle(page):
    result   = {}
    for i in range(1, page):
        url      = 'http://tvgdb.duowan.com/3ds?state=dl&search_state=dl&page=%d' % i
        response = urllib2.urlopen(url)
        html     = response.read()
        htmlutf  = html.decode('utf-8')
        items    = re.findall(pattern_item, htmlutf, re.S)
        for item in items:

            titles   = re.findall(pattern_title, item, re.S)
            address  = re.findall(pattern_address, item, re.S)
            title    = ''.join(titles)
            try:
                download = Get3DSBBS(title, ''.join(address))
                print download
                result[title] = download[0]
                strtmp = title + '\t' + download[0] + '\t' + download[1] + '\n'
                print i
                print strtmp
                fp.write(strtmp.encode('utf-8'))
            except ValueError:
                continue
    return result
if __name__ == "__main__":
    data = Get3DSTitle(10)
    fp.close()

