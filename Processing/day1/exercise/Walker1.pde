class Walker1 {
  int x, y;
  Walker1() {
    x = width / 2;
    y = height / 2;
  }

  void step() {
    int sx = int(random(-2, 2));
    int sy = int(random(-2, 2));
    if (sx == 0) sx = 1;
    if (sy == 0) sy = 1;
    x += sx;
    y += sy;
  }

  void render() {
    stroke(0);
    point(x, y);
  }
}
