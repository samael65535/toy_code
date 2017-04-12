var ai = 3.92
var aj = 1.343
console.log(ai, aj)
var cost = 10
for (var i = 1;  i <= cost; i++) {
	j = cost - i
	var cj = aj*j - i - j
	var ci = ai*i - j - i
	console.log(i, j, ci, cj)
}
