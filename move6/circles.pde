// A circle!
class Circle {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;  
  Fixture fixture;
  float energyValue;
  PImage img;

  float radius;
  float w, h, r, filling, opacity;
  float scaled;
  boolean startGrowing;
  float inc = TWO_PI/25.0; //used for smoothing 'easing' on radius growth/shrinking
  float a =0.0;
  Circle(float x, float y, float radius, float radiusDifference, float restitutionValue, float margin, int xPush, int yPush) {
    opacity=255;
    w = 16;
    h = 16;
    r = random(radius, radius+radiusDifference);



    filling = random(60, 190);
    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);



    // Define a circle
    CircleShape cs = new CircleShape();

    cs.m_radius = box2d.scalarPixelsToWorld(r/(2-margin));

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 5.0;
    fd.friction = 0.0;
    fd.restitution = 0.45;


    //body.setLinearVelocity(new Vec2(0,3));
    body.setLinearVelocity(new Vec2(xPush, yPush));

    // Attach Fixture to Body               
    fixture = body.createFixture(fd);
  }
  //  void update(){
  //    //Destroy the old fixture; we'll replace it in a sec
  //        body.destroyFixture(fixture);
  //        body.createFixture(p); //density after comma
  //
  //  }
  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    noStroke();
    //image(img, 0, 0);
    fill(#fc0fc0, 100); //blue

    ellipseMode(CENTER);
    ellipse(0, 0, r, r);

    popMatrix();
  }

  void energy() {
    energyValue = random(1);
    float energy = map(energyValue, 0, 1, -5, 5);
    body.setLinearVelocity(new Vec2(energy, energy));
  }




  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
  void applyForce(Vec2 v) {
    body.applyForce(v, body.getWorldCenter());
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height || opacity<20) {
      killBody();
      return true;
    }
    return false;
  }

  //    void change() {
  //      println("bleh");
  //  }
  //returns value for collision
  boolean collided() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float distanceFromPoint = dist(x, y, pos.x, pos.y);
    if (distanceFromPoint<(r/2)+16) {
      return true;
    }
    return false;
  }
 
}

