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
int amtLives = 5;
String lives="lives: ";
String scoreString="score: ";

String levelEnd = "level complete! ";
String yourScore = "Your score is: ";
boolean addScoreTime = true;
float counter = 0;
float counterLife = 0;
float counterSpeed= 5;



//keys and coins

boolean keyFound = false;
float xPosKey;
float yPosKey;
float distFromKey;
float distFromGate;
boolean levelComplete = false;
float filling;
float speed = 5;
boolean goingDown;
PImage keyIcon;


//gate

float gateX = width-2;
float gateY = 200;


float x, y, thrust, inverseDrag, velocityX, velocityY, angle, torque;
boolean[] keyIsPressed = new boolean[256];
Circle[] circles = new Circle[10];

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

int bonus;

void setup() {
  keyIcon = loadImage("key.png");
  apercu = loadFont("Apercu-Bold-48.vlw");
  textFont(apercu);


  size(600, 600);
  xPosKey = random(width);
  yPosKey = random(0, height/2);
  oscP5 = new OscP5(this, 8000); //new OSC object 
  x = 50;
  y = 50;
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
    circles[i] = new Circle((width/2+100), random(height-50), 50, radiusDifference, restitutionValue, margin,int(random(50,100)), int(random(-50,-200)));
  }


  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(0, height-5, width*2, 10));
  boundaries.add(new Boundary(0, 5, width*2, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));
}

void draw() {
  background(60);
  


  box2d.step();   
  //looks for distance from key
  fill(255);
  image(keyIcon,xPosKey,yPosKey);
  //ellipse(xPosKey, yPosKey, 30, 30);
  distFromKey = dist(x, y, xPosKey, yPosKey);
  if (distFromKey<30) {
    keyFound = true;
    xPosKey = -100;
    yPosKey = -100;
    gateY= height-100;
    gateX = width-10;
  }

  //  else{ 
  //  keyFound = false;
  //  }

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

  pushMatrix();
  fill(#ff88ff);
  translate(x, y);
  rotate(angle);
  noStroke();
  fill(100);
  ellipse(0, 0, 35, 25);
  fill(#ffcc00);
  triangle(-10, -10, 15, 0, -10, 10);
  popMatrix();  

  showScore();

  //circles!!
  
  for (int i = 0; i < circles.length; i++) {
    // Look, this is just like what we had before!
    circles[i].display();
    if (frameCount%500==0){
    circles[i].energy();
    println("refresh");
    }
    if (circles[i].collided()) {
      fill(#1BAA85);
      ellipse(x, y, 10, 10);
      noFill();
      restart();
    }
    //    if (distanceToCollision < 200){
    //      background(200);
    //  }
  }
  if (keyFound) {

    //flux opacity
    if (goingDown) {
      filling -=speed;
    } 
    else {
      filling +=speed;
    }
    if (filling > 255) {
      goingDown = true;
    } 
    if (filling<50) {
      goingDown = false;
    }

    fill(100, 255, filling);
    rectMode(CENTER);
    rect(gateX, gateY, 20, 50);
  }

  //check for gateDist
  distFromGate = dist(x, y, gateX, gateY);
  //println(distFromGate);
  if (distFromGate < 20) {
    levelComplete = true;
  }
  if (levelComplete == true){
  levelCompleted();
  addBonus();
   score= score+bonus;
  }
  
    //Is there more than 1 life?
  if(amtLives < 1){
  gameOver();}
}

void levelCompleted() {
  addScoreTime = false;
  score = score;
  background(0);
  fill(#ffcc00);
  textSize(28);
  text(levelEnd + yourScore +score, 50, height/2);
}


void gameOver() {
  addScoreTime = false;
  score = score;
  background(0);
  fill(#ffcc00);
  textSize(28);
  text("Game Over!", 50, height/2);
}




void keyPressed() {
  keyIsPressed[keyCode] = true;
}

void keyReleased() {
  keyIsPressed[keyCode] = false;
}


void showScore() {
  fill(0);
  textSize(28);
  text(scoreString + score, 10, 30);
  text(lives + amtLives, 10, 60);

  if (addScoreTime) {
    if(frameCount % 60 == 0){
    score-=1;
    
  }
}
}

void restart() {

  x=5;
  y=5;
  velocityX = 0;
  velocityY = 0;
  if(addScoreTime){
  amtLives-=1;
  score= score-20;

  
  }
}
  void addBonus(){
    counter+=counterSpeed;
    if (counter<500){
    score+=counterSpeed;
    }
  }

//  void minusLifeScore(){
//  counterLife+=counterSpeed;
//    if (counter<100){
//    score-=counterSpeed;
//    }
//  }
