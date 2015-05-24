class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover() {
    mass = 1;

    location = new PVector(width / 2, height);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);  // f / m
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);

    acceleration.mult(0);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(127);
    ellipse(location.x,location.y,48,48);
  }
  void checkEdges() {

    if (location.x > width) {
      location.x = width;
      velocity.x *= -1;
    } else if (location.x < 0) {
      velocity.x *= -1;
      location.x = 0;
    }
    println (location.y);
    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
    if (location.y < 0) {
      velocity.y *= -0.5;
    }
  }
}
