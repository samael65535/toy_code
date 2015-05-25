class Mover {
  float mass;
  PVector location;
  PVector velocity;
  PVector acceleration;
  Mover(float m_, float x_, float y_) {
    mass = m_;
    location = new PVector(x_, y_);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  void drag(Liquid l) {
    float speed = velocity.mag();
    float f = speed * speed * l.c; // 力的大小

    PVector drag = velocity.get();
    drag.mult(-1);
    drag.normalize();

    drag.mult(f);

    applyForce(drag);
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

  boolean isInside(Liquid l) {
    if (location.x > l.x && location.x < l.w + l.x
        && location.y > l.y && location.y < l.y + l.h) {
      return true;
    }
    return false;
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
