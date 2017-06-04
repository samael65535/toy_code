package num62

import (
	"testing"
)

func handleEncode(t *testing.T, arg uint, e string) {
	if Encode(arg) != e {
		t.Errorf("Encode: the result should be %s but %s\n", e, Encode(arg))
	}
}

func TestEncode(t *testing.T) {
	handleEncode(t, 0, "0")
	handleEncode(t, 1, "1")
	handleEncode(t, 61, "z")
	handleEncode(t, 124, "20")
}

func handleDecode(t *testing.T, arg string, e uint) {
	if Decode(arg) != e {
		t.Errorf("Decode %s : the result should be %d but %d\n", arg, e, Decode(arg))
	}
}

func TestDecode(t *testing.T) {
	handleDecode(t, "10", 62)
	handleDecode(t, "z", 61)
	handleDecode(t, "11", 63)
	handleDecode(t, "000z0", 62*61)
}

func BenchmarkEncode(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Encode(uint(i))
	}
}

func BenchmarkDecode(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Decode("zzzzzzz")
	}
}
