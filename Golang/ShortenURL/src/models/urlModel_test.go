package models

import (
	//"strconv"
	"math/rand"
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
	for i := 0; i < b.N; i++ {
		//Add(strconv.FormatUint(rand.Uint64(), 10))
		Add(strconv.FormatUint(uint64(i), 10))
	}
}

func BenchmarkGoAdd(b *testing.B) {
	for i := 0; i < b.N; i++ {
		//go Add(strconv.FormatUint(rand.Uint64(), 10))
		go Add(strconv.FormatUint(uint64(i), 10))

	}
}

func TestDBAdd(t *testing.T) {
	for i := 0; i < 1000; i++ {
		Add(strconv.FormatUint(rand.Uint64(), 10))
	}
}
