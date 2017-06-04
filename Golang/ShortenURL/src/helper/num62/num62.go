package num62

const BASE = 62

var ALPHABET [62]byte

func init() {
	var b byte
	for r := 0; r < 62; r++ {
		if r >= 0 && r <= 9 {
			b = byte(r + 48)
		} else if r >= 10 && r < 36 {
			b = byte(r + 65 - 10)
		} else {
			b = byte(r + 97 - 36)
		}
		ALPHABET[r] = b
	}
}
func Encode(num uint) string {

	/*
		BenchmarkEncode-8       10000000               176 ns/op
		res := ""
			for {
				if num < BASE {
					res = string(ALPHABET[num]) + res
					break
				} else {
					res = string(ALPHABET[num%BASE]) + res
					num = num / BASE
				}
			}
	*/
	res := []byte{}
	for {
		r := num % BASE
		res = append(res, ALPHABET[r])
		// s := []int{1}
		// s, s[0] = append(s[0:1], s[0:]...), 3
		// 使用unshift
		// BenchmarkEncode-8       20000000                72.9 ns/op
		// 使用先append 后reverse
		// BenchmarkEncode-8       20000000                66.6 ns/op
		num = num / BASE
		if num == 0 {
			break
		}
	}

	return string(reverse(res))
}

func reverse(b []byte) []byte {
	for i, j := 0, len(b)-1; i < j; i, j = i+1, j-1 {
		b[i], b[j] = b[j], b[i]
	}
	return b
}
func Decode(n62 string) uint {
	res := uint(0)
	s := uint(1)
	for i := len(n62) - 1; i >= 0; i-- {
		c := n62[i]
		if c >= 'A' && c <= 'Z' {
			res += (uint(c) - 65 + 10) * s
		} else if c >= '0' && c <= '9' {
			res += (uint(c) - 48) * s
		} else if c >= 'a' && c <= 'z' {
			res += (uint(c) - 97 + 36) * s
		}
		s *= BASE
	}
	return res
}
