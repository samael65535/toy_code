var ai = 1.429
var aj = 3.332
var cost = 10;
for (var i = 1;  i <= cost; i++) {
for (var j = 1; j <= cost; j++) {
	var cj = aj*j - i - j
	var ci = ai*i - j - i
	console.log(i, j, ci, cj)

}
}
