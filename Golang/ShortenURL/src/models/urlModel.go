package models

import (
	"gopkg.in/mgo.v2/bson"
	"helper/num62"
	"math/rand"
	"strings"
	"sync"
	"time"
)

type URLPool struct {
	pool chan string
	mu   sync.Mutex
}

func (u *URLPool) get() string {
	for {
		res := <-u.pool
		u, err := FindWithShorten(res)
		if err == nil {
			urlContent.dic[res] = u
		} else {
			return res
		}
	}
}

func (u *URLPool) update() {
	for {
		if len(u.pool) < poollimit {
			key := num62.Encode(uint(rand.Uint32()))
			// 读锁
			urlContent.mu.RLock()
			_, ok := urlContent.dic[key]
			urlContent.mu.RUnlock()
			if !ok {
				u.pool <- key
			}
		}
	}

}

type URLModel struct {
	ID      bson.ObjectId `bson:"_id,omitempty"`
	Shorten string
	Origin  string
}

type URLContent struct {
	dic        map[string]*URLModel
	mu         sync.RWMutex
	updateTime time.Time
}

var urlContent *URLContent
var urlPool *URLPool

const poollimit = 20

func init() {
	InitDB()
	urlContent = new(URLContent)
	urlContent.dic = make(map[string]*URLModel)
	urlPool = new(URLPool)
	urlPool.pool = make(chan string, poollimit)
	go urlPool.update()

}

func Add(origin string) string {
	rand.Seed(time.Now().UnixNano())
	if !strings.HasPrefix(origin, "https://") && !strings.HasPrefix(origin, "http://") {
		origin = "http://" + origin
	}

	// 写锁
	shorten := urlPool.get()
	urlContent.mu.Lock()
	defer urlContent.mu.Unlock()
	_, ok := urlContent.dic[shorten]
	if !ok {
		urlContent.dic[shorten] = &URLModel{
			Shorten: shorten,
			Origin:  origin,
		}
		SaveDB(urlContent.dic[shorten])
	}

	return shorten
}

func Get(shorten string) (string, bool) {
	urlContent.mu.RLock()
	defer urlContent.mu.RUnlock()
	u, ok := urlContent.dic[shorten]
	if !ok {
		var err error
		u, err = FindWithShorten(shorten)
		if err == nil {
			urlContent.dic[shorten] = u
		} else {
			return "", false
		}
	}

	return u.Origin, true
}

func Clear() {
	urlContent.dic = make(map[string]*URLModel)
}

/*
	import (
		"helper/num62"
		"math/rand"
		"strings"
		"sync"
		"time"
	)


	type URLModel struct {
		Shorten   string
		Origin string
	}

	type URLContent struct {
		dic        map[string]*URLModel
		mu         sync.RWMutex
		updateTime time.Time
	}

	var urlContent *URLContent

	// goroutines?
	func init() {
		urlContent = new(URLContent)
		urlContent.dic = make(map[string]*URLModel)
	}

	func Add(Origin string) string {

		if !strings.HasPrefix(Origin, "https://") && !strings.HasPrefix(Origin, "http://") {
			Origin = "http://" + Origin
		}
		urlContent.mu.Lock()
		defer urlContent.mu.Unlock()
		var key string
		for {
			rand.Seed(time.Now().UnixNano())
			key = num62.Encode(uint(rand.Uint32()))
			_, ok := urlContent.dic[key]
			if !ok {
				urlContent.dic[key] = &URLModel{
					Shorten:   key,
					Origin: Origin,
				}
				break
			}
		}

		return key
	}

*/
