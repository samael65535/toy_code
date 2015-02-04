// 防止过采样有随机Walker
class Walker {
  int x,y;

  Walker() {
    x = width/2;
    y = height/2;
  }

  void render() {
    stroke(0);
    point(x,y);
  }
  void step() {
    float r = random(1);
    float sx, sy;

    if (r < 0.01) {
      sx = random(-100, 100);
      sy = random(-100, 100);
    } else {
      sx = random(-1, 1);
      sy = random(-1, 1);
    }
    x += sx;
    y += sy;
    x = constrain(x,0,width-1);
    y = constrain(y,0,height-1);
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
