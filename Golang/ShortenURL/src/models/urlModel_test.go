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

func TestDBAdd(t *testing.T) {
	for i := 0; i < 1000; i++ {
		Add(strconv.FormatUint(rand.Uint64(), 10))
	}
}

func BenchmarkAdd(b *testing.B) {
	// too slow
	for i := 0; i < b.N; i++ {
		shorten := Add(strconv.FormatInt(rand.Int63n(500), 10))
		Get(shorten)
	}
}

func BenchmarkGoAdd(b *testing.B) {
	for i := 0; i < b.N; i++ {
		go func() {
			shorten := Add(strconv.FormatInt(rand.Int63n(500), 10))
			Get(shorten)
		}()

	}
}
