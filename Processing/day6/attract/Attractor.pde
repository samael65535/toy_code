class Attractor {
  float mass;
  PVector location;
  float G;
  boolean isMoving;
  Attractor() {
    location = new PVector(width / 2, height / 2);
    mass = 20;
    G = 0.4;
  }

  PVector attract(Mover m) {
    PVector f = PVector.sub(location, m.location);
    float d = f.mag();
    d = constrain(d, 5.0, 25.0);

    f.normalize();
    float s = (G * mass * m.mass) / (d * d);
    f.mult(s);
    return f;
  }

  void display() {
    stroke(0);
    fill(175, 200);
    ellipse(location.x, location.y, mass * 2, mass * 2);
  }
}
