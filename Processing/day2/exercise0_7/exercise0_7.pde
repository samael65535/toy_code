// Perlin算法表现出一定的自然性,因为它能生成符合自然排序的伪随机数

class Walker {
  float x,y;
  float tx = 0;
  float ty = 10000;
  Walker() {
    x = width/2;
    y = height/2;
  }

  void render() {
    stroke(0);
    point(x,y);
  }
  void step() {
    float sx = map(noise(tx), 0, 1, -1, 1);
    float sy = map(noise(ty), 0, 1, -1, 1);
    x += sx;
    y += sy;
    println(x, y);
    tx += 0.01;
    ty += 0.01;
  }

  // 蒙特卡洛算法
  float montecarlo() {
    while(true) {
      float r1 = random(1);
      float p = r1;
      float r2 = random(1);
      if (r2 < p) {
        return r2;
      }
    }

  }
}

Walker w;

void setup() {
  size(640,360);
  // Create a walker object
  w = new Walker();
  background(255);
}

void draw() {
  // Run the walker object
  w.step();
  w.render();
}
