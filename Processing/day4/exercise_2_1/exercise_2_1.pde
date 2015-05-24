Mover m;

void setup() {
  size(640,360);
  m = new Mover();
}

void draw() {
  background(255);

  
  PVector wind = new PVector(0,-0.02);
  PVector gravity = new PVector(0,0.01);
  m.applyForce(wind);
  m.applyForce(gravity);


  m.update();
  m.display();
  m.checkEdges();
}
