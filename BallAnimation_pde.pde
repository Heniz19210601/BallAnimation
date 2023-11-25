ArrayList<Ball> balls = new ArrayList<Ball>();
PImage[] textures = new PImage[3];

void setup() {
  size(800, 600, P3D);
  textures[0] = loadImage("T1.jpg");
  textures[1] = loadImage("T2.jpg");
  textures[2] = loadImage("T3.jpg");
}

void draw() {
  background(0);
  for (Ball ball : balls) {
    ball.update();
    ball.display();
  }
}

void mousePressed() {
  PVector initPos = new PVector(mouseX, mouseY, 0);
  PVector initVel = PVector.random3D();
  initVel.z = abs(initVel.z); // ensure the ball is always "shot" into the screen
  PImage textureChoice = textures[int(random(textures.length))];
  balls.add(new Ball(initPos, initVel, textureChoice));
}

void setTexture(PShape s, PImage tex) {
  s.setTexture(tex);
}

class Ball {
  PVector pos;  // position
  PVector vel;  // velocity
  PVector acc;  // acceleration
  PVector spin; // spin
  PShape sphereShape;  // Use PShape instead of PImage for texture
  float radius = 20;
  float energyDecay = 0.995;
  float bounceFactor = 0.8;
  
  Ball(PVector pos, PVector vel, PImage texture) {
    this.pos = pos;
    this.vel = vel;
    this.sphereShape = createShape(SPHERE, radius); // create the sphere shape
    setTexture(this.sphereShape, texture); // set the texture to the sphere
    this.acc = new PVector(0, 0.1, 0); // gravity acts on y-axis
    this.spin = PVector.random3D();    // initial random spin direction
  }

  void update() {
    vel.add(acc);   // update velocity by acceleration
    pos.add(vel);   // update position by velocity
    vel.mult(energyDecay); // handle energy decay
    wallCollision();  // Handle wall collisions
    for (Ball other : balls) {
      if (other != this && pos.dist(other.pos) < 2 * radius) {
        PVector bounce = PVector.sub(pos, other.pos);
        bounce.normalize();
        bounce.mult(bounceFactor);
        vel.add(bounce);
        vel.mult(bounceFactor); // dampen velocity due to collision
      }
    }
  }

  void wallCollision() {
    if (pos.x > width - radius || pos.x < radius) {
      vel.x = -vel.x * bounceFactor;
    }
    if (pos.y > height - radius || pos.y < radius) {
      vel.y = -vel.y * bounceFactor;
    }
    if (pos.z > 300 || pos.z < -300) {
      vel.z = -vel.z * bounceFactor;
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(spin.x);
    rotateY(spin.y);
    rotateZ(spin.z);
    noStroke();
    shape(sphereShape); // draw the sphere shape
    popMatrix();
  }
}
