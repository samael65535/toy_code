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
    int stepx = int(random(3)) - 1;
    int stepy = int(random(3)) - 1;
    x += stepx;
    y += stepy;
    x = constrain(x,0,width-1);
    y = constrain(y,0,height-1);
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
