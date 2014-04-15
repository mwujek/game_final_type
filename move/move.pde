import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

import oscP5.*;
import netP5.*;
OscP5 oscP5;


//collision detection
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;





Box2DProcessing box2d; 

ArrayList<Boundary> boundaries;


//score, lives, and text stuff
PFont apercu;
int score=100;


float x, y, thrust, inverseDrag, velocityX, velocityY, angle, torque;
boolean[] keyIsPressed = new boolean[256];
Circle[] circles = new Circle[7];

//box2d variables 
int scaleFactor = 10;
float radius = 10f;
float radiusDifference= 20;
float restitutionValue = 0.0f;
float blurValue=1;
float margin= 0.0f;
float red = 0.0f;
float green = 0.0f;
float blue = 0.0f;
float creationRate = 0.0f;

void setup() {
  size(600, 600);
  oscP5 = new OscP5(this, 8000); //new OSC object 
  x = width/2;
  y = height/2;
  thrust = 0.12;
  inverseDrag = 0.99;
  velocityX = 0;
  velocityY = 0;
  angle = 0.0;
  torque = radians(5.0);

  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  box2d.setGravity(0, 0);

  for (int i = 0; i < circles.length; i++) {
    circles[i] = new Circle((width/2+100), 50, 50, radiusDifference, restitutionValue, margin);
  }
  
  
  boundaries = new ArrayList<Boundary>();
  
  boundaries.add(new Boundary(0, height-5, width*2, 10));
  boundaries.add(new Boundary(0, 5, width*2, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));
}

void draw() {
  box2d.step();   

  velocityX *= inverseDrag;
  velocityY *= inverseDrag;
  x += velocityX;
  y += velocityY;

  if (x > width + 30)
    x = -30;
  else if (x < -30)
    x = width + 30;
  if (y > height + 30)
    y = -30;
  else if (y < -30)
    y = height + 30;

  if (keyIsPressed[LEFT])
    angle -= torque;
  if (keyIsPressed[RIGHT])
    angle += torque;
  if (keyIsPressed[UP]) {
    velocityX += cos(angle) * thrust;
    velocityY += sin(angle) * thrust;
  }
  if (keyIsPressed[DOWN]) {
    velocityX -= cos(angle) * thrust;
    velocityY -= sin(angle) * thrust;
  }

  background(60);
  pushMatrix();
  fill(#ff88ff);
  translate(x, y);
  rotate(angle);
  noStroke();
  fill(100);
  ellipse(0,0,35,25);
  fill(#ffcc00);
  triangle(-10, -10, 15, 0, -10, 10);
  popMatrix();  
  float distanceToCollision = dist(x,y,10,10);
  println(distanceToCollision);

  //circles!!
  for (int i = 0; i < circles.length; i++) {
    // Look, this is just like what we had before!
    
    circles[i].display();
    if (circles[i].collided()) {
      fill(#1BAA85);
      ellipse(x,y,10,10);
      noFill();
    }
//    if (distanceToCollision < 200){
//      background(200);
//  }
  }
}



// Objects stop touching each other
void endContact(Contact cp) {
}


void keyPressed() {
  keyIsPressed[keyCode] = true;
}

void keyReleased() {
  keyIsPressed[keyCode] = false;
}

