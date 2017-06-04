package models

import (
	//"strconv"
	"strconv"
	"testing"
)

func TestAdd(t *testing.T) {
	key := Add("test")
	_, ok := Get(key)
	if !ok {
		t.Error("error")
	}
}

func BenchmarkAdd(b *testing.B) {
	Clear()
	for i := 0; i < b.N; i++ {
		Add(strconv.FormatInt(int64(i), 10))
	}
}

func BenchmarkGoAdd(b *testing.B) {
	Clear()
	for i := 0; i < b.N; i++ {
		go Add(strconv.FormatInt(int64(i), 10))

	}
}

func TestDBAdd(t *testing.T) {

}
