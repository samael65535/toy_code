package models

import (
	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"
)

var session *mgo.Session
var collection *mgo.Collection

func InitDB() error {
	var err error
	session, err = mgo.Dial("127.0.0.1")
	if err != nil {
		return err
	}

	session.SetMode(mgo.Monotonic, true)
	collection = session.DB("tinyurl").C("url")
	return nil
}

func CloseDB() {
	if session != nil {
		session.Close()
	}
}

func SaveDB(m *URLModel) error {
	err := collection.Insert(m)
	return err

}
func FindWithOrigin(origin string) (*URLModel, error) {
	u := &URLModel{}
	err := collection.Find(bson.M{"Origin": origin}).One(u)
	if err != nil {
		return nil, err
	}
	return u, nil
}

func FindWithShorten(shorten string) (*URLModel, error) {
	u := &URLModel{}
	err := collection.Find(bson.M{"shorten": shorten}).One(u)
	if err != nil {
		return nil, err
	}
	return u, nil
}
