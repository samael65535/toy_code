Walker2 w;
void setup() {
  size(640, 360);
  //w = new Walker2();
  background(255);
}

void draw() {
  //  w.step();
  //  w.render();
  float num = (float)randomGaussian();
  float sd = 60; // 标准差
  float mean = 320; // 平均值
  float x = sd * num + mean;
  noStroke();
  fill(0, 10);
  ellipse(x, 180, 16, 16);
}
