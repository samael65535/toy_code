class Walker2 {
  int x, y;
  Walker2() {
    x = width / 2;
    y = height / 2;
  }

  void step() {
    // mouse方向
    int sx = x > mouseX ? -1 : 1;
    int sy = y > mouseY ? -1 : 1;
    if (random(1) <= 0.5) {
      sx = int(random(-2, 2));
      sy = int(random(-2, 2));
    }
    x += sx;
    y += sy;
    println(x, y);
  }

  void render()
  {
    stroke(0);
    point(x, y);
 }
}
