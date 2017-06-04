package controllers

import (
	"github.com/hoisie/web"
	"html/template"
)

// 注册服务器
func Register(t *template.Template) {
	server := web.NewServer()
	server.Config.StaticDir = "public/"

	ic := new(indexController)
	ic.template = t.Lookup("index.html")
	server.Get("/(.*)", ic.get)
	server.Post("/(.*)", ic.post)
	server.Run("localhost:9999")

}

// 静态资源
func serveResource() {

}
