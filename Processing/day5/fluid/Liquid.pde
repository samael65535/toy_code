class Liquid {
  float x, y, w, h;             // 位置
  float c;                      // 阻力系数
  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }
  void display() {
    noStroke();
    fill(175);
    rect(x, y, w, h);
  }
};
