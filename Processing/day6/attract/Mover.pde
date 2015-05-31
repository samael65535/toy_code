class Mover {
  float mass;
  PVector location;
  PVector velocity;
  PVector acceleration;
  Mover(float m_, float x_, float y_) {
    mass = m_;
    location = new PVector(x_, y_);
    velocity = new PVector(1, 1);
    acceleration = new PVector(0, 0);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);

    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);  // f / m
    acceleration.add(f);
  }

  void display() {
    stroke(0);
    strokeWeight(2);
    fill(255);
    ellipse(location.x,location.y,48,48);
  }

  void checkEdges() {
    if (location.x > width) {
      location.x = width;
      velocity.x *= -0.5;
    } else if (location.x < 0) {
      velocity.x *= -0.5;
      location.x = 0;
    }
    if (location.y > height) {
      velocity.y *= -1;
      location.y = height;
    }
    if (location.y < 0) {
      velocity.y *= -0.5;
    }
  }
}
