# coding: utf-8
# https://paiza.jp/poh/ando
# 自分の得意な言語で
# Let's チャレンジ！！
# coding: utf-8
# 自分の得意な言語で
# Let's チャレンジ！！
input_lines = raw_input()
input_lines = long(input_lines)
ret1 = 0
a = 1
for i in range(1, input_lines + 1):
	j = i
	while(0 == j % 5):
		ret1 += 1
		j /= 5
	a *= j
	while 0 == a % 2 and ret1 > 0:
		ret1 -= 1;
		a /= 2
	a%=1000000000000000
print a%1000000000
