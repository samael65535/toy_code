package main

import (
	"xiaoba/spider"
	"time"
)

func main() {
	isUpdate := false
	spider.Run(isUpdate)
	for {
		<- time.After(24 * time.Hour)
		spider.Run(isUpdate)
		isUpdate = true
	}
}
