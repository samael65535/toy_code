Walker2 w;
void setup() {
  size(400, 400);
  w = new Walker2();
  background(255);
}

void draw() {
  w.step();
  w.render();
}
