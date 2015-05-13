// Perlin算法表现出一定的自然性,因为它能生成符合自然排序的伪随机数

void setup() {
  size(500, 500);
}
float s = 0;
void draw() {
  //  float x = random(0, width);
  // float x = map(noise(tx), 0, 1, 0, width);
  // float y = map(noise(ty), 0, 1, 0, height);
  // float y = map(noise(ty), 0, 1, 0, height);
  // ellipse(x, y, 16, 16);
  // tx += 0.01;
  // ty += 0.01;

  // 普通2维噪声
  // loadPixels();

  // for (int x = 0; x < width; x++) {
  //   for (int y = 0; y < height; y++) {
  //     float bright = random(255);
  //     pixels[x+y*width] = color(bright);
  //   }
  // }
  // updatePixels();

  // Perlin2维噪声 可以模拟云层
  loadPixels();
  float xoff = 0.0;
  for (int x = 0; x < width; x++) {
    float yoff = 1000;
    for (int y = 0; y < height; y++) {
      noiseDetail(6);
      float r = map(noise(xoff, yoff, s), 0, 1, 0, 255);
      noiseDetail(1);
      float g = map(noise(xoff, yoff, s), 0, 1, 0, 255);
      noiseDetail(3);
      float b = map(noise(xoff, yoff, s), 0, 1, 0, 255);
      pixels[x+y*width] = color(r, g, b);
      yoff += 0.02;
    }
    xoff += 0.02;
  }
  updatePixels();
  s += 0.01;
}
