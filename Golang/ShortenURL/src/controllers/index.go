package controllers

import (
	"fmt"
	"github.com/hoisie/web"
	"html/template"
	"log"
	"models"
	"net/http"
)

type indexController struct {
	template *template.Template
}

func (this *indexController) get(ctx *web.Context, val string) {
	if val == "" {
		r := result{"", ""}
		// 查询有没有命中
		fmt.Println(this.template.Execute(ctx.ResponseWriter, r))
	} else {
		if url, ok := models.Get(val); ok {
			log.Print(url)
			ctx.Redirect(http.StatusFound, url)
		} else {
			ctx.NotFound("url")
		}
	}

}

type result struct {
	Tiny   string
	Origin string
}

func (this *indexController) post(ctx *web.Context, val string) {
	originUrl, ok := ctx.Params["origin"]
	if !ok {
		ctx.NotFound("hello")
	}
	tinyUrl := models.Add(originUrl)
	r := result{tinyUrl, originUrl}
	fmt.Println(this.template.Execute(ctx.ResponseWriter, r))
}
