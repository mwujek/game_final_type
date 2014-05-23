// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2011
// Box2DProcessing example

// Showing how to use applyForce() with box2d

// Fixed Attractor (this is redundant with Mover)

class Attractor {
  
  // We need to keep track of a Body and a radius
  Body body;
  Fixture fixture;
  float r;

  Attractor(float r_, float x, float y) {
    r = r_;
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    fixture = body.createFixture(cs, 1);
    //body.createFixture(cs,1);

  }


  // Formula for gravitational attraction
  // We are computing this in "world" coordinates
  // No need to convert to pixels and back
  Vec2 attract(AttractedCircle ea) {
    float G = 140; // Strength of force
    // clone() makes us a copy
    Vec2 pos = body.getWorldCenter();    
    Vec2 moverPos = ea.body.getWorldCenter();
    // Vector pointing from mover to attractor
    Vec2 force = pos.sub(moverPos);
    float distance = force.length();
    // Keep force within bounds
    distance = constrain(distance,1,5);
    force.normalize();
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float strength = (G * 1 * ea.body.m_mass) / (distance * distance); // Calculate gravitional force magnitude
    force.mulLocal(strength);         // Get force vector --> magnitude * direction
    return force;
  }

  
  void update(float x, float y){
    body.destroyFixture(fixture);
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
     fixture = body.createFixture(cs, 1);
  }
}


