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
    float r = this.montecarlo();
    float sx, sy;
    println(r);
    sx = random(-r, r);
    sy = random(-r, r);
    x += sx;
    y += sy;
    x = constrain(x,0,width-1);
    y = constrain(y,0,height-1);
  }

  // 蒙特卡洛算法
  float montecarlo() {
    while(true) {
      float r1 = random(100);
      float p = r1;
      float r2 = random(100);
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
