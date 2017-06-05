package model

import (
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
	"log"
	"time"
)

type XBPage struct {
	URL  string
	Date time.Time
}
type XBInfo struct {
	ID       bson.ObjectId `bson:"_id,omitempty"`
	URL      string
	Title    string
	Info     string
	Pan      string
	LastTime time.Time
}

var globalSession *mgo.Session
var collection *mgo.Collection

func getSession() error {
	var err error
	globalSession, err = mgo.Dial("127.0.0.1")
	if err != nil {
		return err
	}

	globalSession.SetMode(mgo.Monotonic, true)
	collection = globalSession.DB("xiaoba").C("Items")
	return nil
}

func CloseDB() {
	if globalSession != nil {
		globalSession.Close()
	}
}

func New(title, url string) XBInfo {
	xb := XBInfo{
		Title: title,
		URL:   url,
	}
	return xb
}

func (xb *XBInfo) SetInfo(info string) {
	xb.Info = info
	xb.LastTime = time.Now()
}

func (xb XBInfo) Save() {
	colQuerier := bson.M{"URL": xb.URL}
	change := mgo.Change{
		Update:    bson.M{"$set": bson.M{"Pan": xb.Pan, "URL": xb.URL, "LastTime": xb.LastTime, "Info": xb.Info, "Title": xb.Title}},
		ReturnNew: false,
		Upsert:    true,
	}
	_, err := collection.Find(colQuerier).Apply(change, nil)

	if err != nil {
		panic(err)
	}
}

func (xb XBInfo) CheckExist() bool {
	result := XBInfo{}
	colQuerier := bson.M{"URL": xb.URL}
	err := collection.Find(colQuerier).One(&result)
	if err == mgo.ErrNotFound {
		return false

	}
	if err != nil {
		log.Fatal(err)
	}
	return true
}
