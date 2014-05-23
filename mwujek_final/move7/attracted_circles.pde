// A circle!
class AttractedCircle {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;  
  Fixture fixture;
  PImage img;

  float w, h, r, filling, opacity;
  float scaled;
  boolean startGrowing;
  float inc = TWO_PI/25.0; //used for smoothing 'easing' on radius growth/shrinking
  float a =0.0;
  AttractedCircle(float x, float y, float radius, float radiusDifference, float restitutionValue, float margin) {
    opacity=255;

    r = 10;

    filling = random(60, 190);
    // Build Body
    BodyDef bd = new BodyDef();      
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bd);



    // Define a circle
    CircleShape cs = new CircleShape();

    cs.m_radius = box2d.scalarPixelsToWorld(r/2);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.0;

    // Attach Fixture to Body               
    fixture = body.createFixture(fd);
  }

  void displayEasyCircles() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);    // Using the Vec2 position and float angle to
    //rotate(-a);     // translate and rotate the rectangle
    noStroke();
    fill(255,0,0); //red

    ellipseMode(CENTER);
    ellipse(0, 0, 10, 10);
    popMatrix();
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
  
  
  boolean collidedA(){
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float distanceFromPoint = dist(x,y,pos.x, pos.y);
    if(distanceFromPoint<r+15){
      return true;
    }
    return false;
  }
}

