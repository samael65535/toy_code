package models

import (
	"github.com/muesli/cache2go"
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"time"
)

var globalSession *mgo.Session
var cache1 *cache2go.CacheTable
var cache2 *cache2go.CacheTable

func init() {
	cache1 = cache2go.Cache("Origin")
	cache2 = cache2go.Cache("Shorten")
	collection := GetSession().DB("tinyurl").C("url")
	res := []URLModel{}
	collection.Find(bson.M{}).All(&res)
	for _, item := range res {
		cache1.Add(item.Origin, 60*time.Second, &item)
		cache2.Add(item.Shorten, 60*time.Second, &item)
	}
}

func GetSession() *mgo.Session {
	var err error
	if globalSession == nil {
		globalSession, err = mgo.Dial("127.0.0.1")
		if err != nil {
			panic(err)
		}

		globalSession.SetMode(mgo.Monotonic, true)
	}
	return globalSession
}

func CloseSession() {
	if globalSession != nil {
		globalSession.Close()
	}
}

func SaveDB(m *URLModel) error {
	collection := GetSession().DB("tinyurl").C("url")
	err := collection.Insert(m)
	cache1.Add(m.Origin, 60*time.Second, m)
	cache2.Add(m.Shorten, 60*time.Second, m)
	return err
}

func FindWithOrigin(origin string) (*URLModel, error) {

	res, err := cache1.Value(origin)
	if err == nil {
		return res.Data().(*URLModel), nil
	} else {
		collection := GetSession().DB("tinyurl").C("url")
		u := &URLModel{}
		err := collection.Find(bson.M{"origin": origin}).One(u)
		if err != nil {
			return nil, err
		}
		cache1.Add(u.Origin, 60*time.Second, u)
		cache2.Add(u.Shorten, 60*time.Second, u)
		return u, nil
	}
}

func FindWithShorten(shorten string) (*URLModel, error) {
	res, err := cache2.Value(shorten)
	if err == nil {
		return res.Data().(*URLModel), nil
	} else {
		collection := GetSession().DB("tinyurl").C("url")
		u := &URLModel{}
		err := collection.Find(bson.M{"shorten": shorten}).One(u)
		if err != nil {
			return nil, err
		}
		cache1.Add(u.Origin, 60*time.Second, u)
		cache2.Add(u.Shorten, 60*time.Second, u)
		return u, nil
	}
}
