Mover m;
Attractor a;

void setup() {
  size(640,360);
  m = new Mover(20, 60, 20);
  a = new Attractor();
}

void draw() {
  background(255);

  PVector force = a.attract(m);
  m.applyForce(force);
  m.update();

  a.display();
  m.display();
}
