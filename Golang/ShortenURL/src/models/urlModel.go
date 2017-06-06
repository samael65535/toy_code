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
	pool  chan string
	ready chan struct{}
	mu    sync.Mutex
}

func (u *URLPool) get() string {
	for {
		u.ready <- struct{}{}
		shorten := <-u.pool
		return shorten
	}
}

func (u *URLPool) update() {
	for {
		<-u.ready
		shorten := num62.Encode(uint(rand.Uint32()))
		_, err := FindWithShorten(shorten)
		if err != nil {
			u.pool <- shorten
		}
	}

}

type URLModel struct {
	ID      bson.ObjectId `bson:"_id,omitempty"`
	Shorten string
	Origin  string
	Count   uint
}

var urlPool *URLPool

const poollimit = 20

func init() {
	urlPool = new(URLPool)
	urlPool.pool = make(chan string, poollimit)
	urlPool.ready = make(chan struct{})
	go urlPool.update()
}

func Add(origin string) string {
	rand.Seed(time.Now().UnixNano())
	if !strings.HasPrefix(origin, "https://") && !strings.HasPrefix(origin, "http://") {
		origin = "http://" + origin
	}

	// 写锁
	var shorten string
	u, e := FindWithOrigin(origin)
	if e == nil {
		shorten = u.Shorten
	} else {
		shorten = urlPool.get()
		u := &URLModel{
			Shorten: shorten,
			Origin:  origin,
			Count: 0,
		}
		SaveDB(u)
	}

	return shorten
}

func Get(shorten string) (string, bool) {
	u, err := FindWithShorten(shorten)
	if err != nil {
		return "", false
	}

	return u.Origin, true
}
