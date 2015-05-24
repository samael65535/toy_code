Mover m;

float t = 3;
float x = 0;
void setup() {
  size(640,360);
  m = new Mover();
}

void draw() {
  background(255);

  PVector buoyancy = new PVector(0,-0.1);
  x = map(noise(t), 0, 1, -0.5, 0.5);
  println(x);
  PVector wind = new PVector(x,0);
  PVector gravity = new PVector(0,0.01);
  m.applyForce(buoyancy);
  m.applyForce(gravity);
  m.applyForce(wind);
  m.update();
  m.display();
  m.checkEdges();
  t += 0.03;
}
