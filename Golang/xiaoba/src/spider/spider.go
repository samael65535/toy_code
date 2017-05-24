package spider

import (
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"log"
	"net/http"
	"os"
	"sync"
	"xiaoba/model"
	"io"
)

var pageChan chan int
var itemsChan chan model.XBInfo

var pageDone chan struct{}
var itemDone chan struct{}

var wgPage sync.WaitGroup
var wgItem sync.WaitGroup

const pageGoroutineNums = 3
const itemGoroutineNums = 10
const updatePageCount = 3

var updateItemsNums int

// 当前更新
var currentWorkingItem map[string]bool

func init() {
	filename := "xiaoba.log"
	f, err := os.OpenFile(filename, os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("error opening file: %v", err)
	}

	mw := io.MultiWriter(os.Stdout, f)
	log.SetOutput(mw)
}

func Run(isUpdate bool) {
	err := model.InitDB()
	defer model.CloseDB()

	if err != nil {
		log.Fatal(err)
		return
	}
	log.Println("Starting....")

	updateItemsNums = 0
	currentWorkingItem = make(map[string]bool)
	pageChan = make(chan int)
	itemsChan = make(chan model.XBInfo)
	pageDone = make(chan struct{}, pageGoroutineNums)
	itemDone = make(chan struct{}, itemGoroutineNums)

	for j := 1; j <= pageGoroutineNums; j++ {
		wgPage.Add(1)
		go handlePage()
	}

	for j := 1; j <= itemGoroutineNums; j++ {
		wgItem.Add(1)
		go handleItem()
	}

	// for i := 1; i <= 1; i++ {
	//	pageChan <- i
	// }

	go func() {
		defer close(pageChan)
		i := 0
		count := 0
		for {
			if isUpdate && i >= updatePageCount {
				return
			}
			select {
			case <-pageDone:
				count++
				if count >= pageGoroutineNums {
					break
				}

			default:
				pageChan <- i
				i++
			}
		}
	}()

	wgPage.Wait()
	close(itemsChan)
	wgItem.Wait()

	log.Println("Finish : ", updateItemsNums)
}

func handlePage() {
	defer wgPage.Done()
	for {
		p, ok := <-pageChan
		if !ok {
			return
		}
		url := fmt.Sprintf("https://blog.reimu.net/page/%d", p)
		res, err := http.Get(url)
		if err != nil {
			log.Fatal(err)
		}

		if res.StatusCode != 200 {
			pageDone <- struct{}{}
			return
		}

		doc, err := goquery.NewDocumentFromResponse(res)
		if err != nil {
			log.Fatal(err)
		}

		// Find the review items
		doc.Find(".site-main article .entry-title").Each(func(i int, s *goquery.Selection) {
			// For each item found, get the band and title
			node := s.Find("a")
			band := node.Text()
			attr, exist := node.Attr("href")
			if !exist {
				log.Fatal(exist)
			}

			xb := model.New(band, attr)
			_, ok := currentWorkingItem[attr]
			if !ok && !xb.CheckExist() {
				updateItemsNums++
				currentWorkingItem[attr] = true
				itemsChan <- xb
			}
		})

	}
}

func handleItem() {
	defer wgItem.Done()
	for {
		xb, ok := <-itemsChan
		if !ok {
			return
		}

		res, err := http.Get(xb.URL)
		if err != nil {
			log.Fatal(err)
		}

		if res.StatusCode == 200 {
			doc, err := goquery.NewDocumentFromResponse(res)
			if err != nil {
				log.Fatal(err)
			}
			log.Printf("Getting: %s %s\n", xb.URL, xb.Title)

			isFindPre := false
			doc.Find("pre").Each(func(i int, s *goquery.Selection) {
				// For each item found, get the band and title
				node := s.Find("a")
				info := s.Text()
				attr, exist := node.Attr("href")
				if !exist {
					return
				}
				isFindPre = true
				xb.Pan = attr
				xb.SetInfo(info)
				xb.Save()
			})

			if !isFindPre {
				doc.Find("div").Each(func(i int, s *goquery.Selection) {
					// For each item found, get the band and title
					if s.HasClass("entry-content") {
						node := s.Find("a")
						info := s.Text()
						attr, exist := node.Attr("href")
						if !exist || node.Text() != "传送门" {
							xb.Save()
							return
						}
						xb.Pan = attr
						xb.SetInfo(info)
						xb.Save()
					}
				})
			}
			delete(currentWorkingItem, xb.URL)
		}
	}
}
