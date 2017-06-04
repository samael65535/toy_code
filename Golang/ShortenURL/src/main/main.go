package main

import (
	"controllers"

	"html/template"
	"os"
)

func main() {
	templates := populateTemplates()
	controllers.Register(templates)
}

func populateTemplates() *template.Template {
	// 解析缓存templates
	result := template.New("templates")
	basePath := "templates"
	templateFolder, _ := os.Open(basePath)
	defer templateFolder.Close()

	templatePathsRaw, _ := templateFolder.Readdir(-1)

	templatePaths := new([]string)

	for _, pathInfo := range templatePathsRaw {
		if !pathInfo.IsDir() {
			*templatePaths = append(*templatePaths, basePath+"/"+pathInfo.Name())
		}
	}
	result.ParseFiles(*templatePaths...)

	return result
}
