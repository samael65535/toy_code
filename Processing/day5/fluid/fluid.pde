Liquid liquid;
Mover[] movers = new Mover[1];
void setup() {
  size(640,360);
  smooth();
  liquid = new Liquid(0, height / 2, width , height, 0.8);
  for (int i = 0; i < movers.length; i++) {
  //   println(i);
    movers[i] = new Mover(random(0.1, 5), width / 2, 40);
  }
}

void draw() {
  background(255);
  liquid.display();
  for (int i = 0; i < movers.length; i++) {
    if (movers[i].isInside(liquid)) {
      movers[i].drag(liquid);
    }
    float m = 0.01 * movers[i].mass;
    PVector gravity = new PVector(0, m);
    movers[i].applyForce(gravity);

    movers[i].update();
    movers[i].display();
    movers[i].checkEdges();
  }
}
