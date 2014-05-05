//You have to add processing library first!!
//sketch > import library > add library > "box2d for processing"


import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

int i = 9;
boolean newInv = false;
//collision detection
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
float xPosInv;
float yPosInv;



Box2DProcessing box2d; 

boolean flashingL;
float flashOpacityL;    
float flashHeightL;

ArrayList<Boundary> boundaries;


//score, lives, and text stuff
PFont apercu;
float flashHeight;
int targetScore;
int displayScore;
boolean flashDifference;
boolean state=false;
boolean flashing=false;
int addedScore;
int diff;
float flashOpacity=255;

float growingBox;
boolean invincibility=true;

int amtLives = 5;
String lives="lives: ";
String scoreString="score: ";

String levelEnd = "level complete! ";
String yourScore = "Your score is: ";
boolean addScoreTime = true;
float counter = 0;
float counterLife = 0;
float counterSpeed= 6;

boolean runonce = true;

//keys and coins

boolean keyFound = false;
boolean InvFound = false;
boolean invFound = false;

float xPosKey;
float yPosKey;
float distFromKey;
float distFromInv;
boolean levelComplete = false;
float filling;
float speed = 5;
boolean goingDown;
boolean down;
float opacity = 0;
PImage keyIcon;
PImage bg;
PImage ship;

float bgXPos =2;
float bgYPos =2;





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

float backgroundColor = 255;

//Easing Trail
int num = 20;
float mx[] = new float[num];
float my[] = new float[num];


//attractor objects
Attractor easyAttractor;

ArrayList<AttractedCircle> attractedCircles;
float targetX;
float targetY;
//timing 
int savedTime;
int totalTime = 2500;

void setup() {
  //timing
  savedTime = millis();
  keyIcon = loadImage("star.png");
  bg = loadImage("bg.jpg");
  ship = loadImage("ship.png");
  apercu = loadFont("Apercu-Bold-48.vlw");
  textFont(apercu);


  size(600, 600);
  xPosKey = random(0, width/3);
  //yPosKey = random(height/2, height-40);
  yPosKey = 100;

  x = 50;
  y = 200;
  thrust = 0.20;
  inverseDrag = 0.97;
  velocityX = 0;
  velocityY = 0;
  angle = 0.0;
  torque = radians(5.0);

  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  box2d.createWorld();
  box2d.setGravity(0, 0);

  for (int i = 0; i < circles.length; i++) {
    circles[i] = new Circle((width/2+100), random(height-50), 50, radiusDifference, 4, margin, int(random(50, 100)), int(random(-50, -200)));
  }


  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(0, height-5, width*2, 10));
  boundaries.add(new Boundary(0, 5, width*2, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));


  //setup attractors
  easyAttractor = new Attractor(12, mouseX, mouseY);
  attractedCircles = new ArrayList<AttractedCircle>();
}


void draw() {

  // Calculate how much time has passed
  int passedTime = millis() - savedTime;
  targetX = x;
  targetY = y;
  //if(

  image(bg, -50+(targetX/25), -50+(targetY/25));
  bgXPos = constrain(bgXPos, -50, 500);
  bgYPos = constrain(bgXPos, -50, 500);



//invincibility

if(displayScore>50){
  resetInv();
  
}

if(newInv){
  image(keyIcon,xPosInv,yPosInv);
}





  //score constraints
  displayScore = constrain(displayScore, 0, 1000000); 
  targetScore = constrain(targetScore, 0, 1000000); 
  if (targetScore > displayScore) {
    displayScore++;
    flashDifference=true;
    //println(addedScore);
  }

  if (displayScore > targetScore) {
    displayScore--;
    flashDifference=true;
  }

  if (displayScore == targetScore) {
    flashDifference = false;
  }

  if (flashDifference) {
    //println(diff);
  }



  //println("target: " + targetScore);





  x = constrain(x, 10, width-10);
  y = constrain(y, 10, height-10);

  //flux opacity
  if (down) {
    opacity -=speed;
  } 
  else {
    opacity +=speed;
  }
  if (opacity > 255) {
    down = true;
  } 
  if (opacity<50) {
    down = false;
  }

  // update before stepping
  easyAttractor.update(x, y);

  box2d.step();   
  //looks for distance from key

  //opacity tint below
  //fill(backgroundColor, opacity);
  //rect(xPosKey, yPosKey, 50, 50);

  //ellipse(xPosKey, yPosKey, 30, 30);
  distFromKey = dist(x, y, xPosKey, yPosKey);
  distFromInv = dist(x, y, xPosInv, yPosInv);
  if (distFromKey<32) {
    keyFound = true;
    addscore(50);
  }
  
    if (distFromInv<32) {
    invFound = true;
    addscore(50);
  }
  
  if(invFound){
    ellipse(xPosInv,xPosInv,40,40);
  }

  if (keyFound) {
    xPosKey = -100;
    yPosKey = -100;
    if (frameCount % 50 ==0) {
      resetKey();
      keyFound = false;
    }
  }

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

  //triangle(-10, -10, 15, 0, -10, 10);
  if (keyIsPressed[UP]) {
    fill(255, random(200), 0);
    ellipse(-16, 0, random(1, 6), random(1, 6));
    ellipse(-9, 10, random(1, 4), random(1, 4));
    ellipse(-9, -10, random(1, 4), random(1, 4));
  }
  tint(255);
  image(ship, -15, -17);
  if (invincibility) {
    noFill();
    if (state) {
      stroke(255);
      fill(255, 100);
    }
    else {
      noStroke();
    }
    if (frameCount%10==0) {
      state=!state;
    }
    ellipse(0, 0, 50, 50);

    if (passedTime > totalTime) {
      println( " 5 seconds have passed! " );
      invincibility =false;
    }
  }


  //origin
  //ellipse(0,0,2,2);
  popMatrix();  

  showScore();

  //circles!!

  for (int i = 0; i < circles.length; i++) {
    // Look, this is just like what we had before!
    circles[i].display();
    if (frameCount%500==0) {
      circles[i].energy();
    }
    if (circles[i].collided()&&invincibility ==false) {
      fill(#1BAA85);
      ellipse(x, y, 10, 10);
      noFill();
      restart();
    }
  }

  //display and update attractors
  if (frameCount % 350 == 0 || frameCount<4) {
    AttractedCircle ea = new AttractedCircle(width-20, 20, random(20, 30), 10, 0.5, -1);
    attractedCircles.add(ea);
    //circles =  append(circles, circles);

  }

  for (int i = 0; i < attractedCircles.size()-1; i++) {
    // Look, this is just like what we had before!
    Vec2 force = easyAttractor.attract(attractedCircles.get(i));
    attractedCircles.get(i).applyForce(force);
    attractedCircles.get(i).displayEasyCircles();


    if (attractedCircles.get(i).collidedA() && invincibility ==false) {
      fill(#1BAA85);
      ellipse(x, y, 10, 10);
      noFill();
      restart();
    }
  }

  //Is there more than 1 life?
  if (amtLives < 1) {
    gameOver();
  }
  tint(255, opacity);  // Display at half opacity
  if (addScoreTime) {
    image(keyIcon, xPosKey, yPosKey);
  }

  if (flashing) {
    fill(255, flashOpacity);
    flashOpacity-=5;
    flashHeight-=0.5;
    text("+10", 68, (height-20)+flashHeight);
    if (flashOpacity<0) {
      flashing=false;
    }
  }
  else {
    flashOpacity=255;
    flashHeight= 0;
  }

  if (flashingL) {
    fill(255, 100, 0, flashOpacityL);
    flashOpacityL-=5;
    flashHeightL-=0.5;
    text("-1", 168, (height-20)+flashHeightL);
    if (flashOpacityL<0) {
      flashingL=false;
    }
  }
  else {
    flashOpacityL=255;
    flashHeightL= 0;
  }
  println(addedScore);
} //end draw loop 

void levelCompleted() {
  addScoreTime = false;
  background(0);
  fill(#ffcc00);
  textSize(28);
  if (runonce) {
    addscore(100);
    runonce = false;
  }
  text(levelEnd + yourScore +displayScore, 50, height/2);
}


void gameOver() {
  addScoreTime = false;
  displayScore = displayScore;
  rectMode(CENTER);
  fill(0);
  x=-50;
  y=-50;

  if (growingBox<width+100) {
    growingBox+=10;
  }
  rect(width/2, height/2, growingBox, growingBox);

  fill(#ffcc00);
  //textSize(28);
  text("Game Over!", 100, height/2);
  text("Your final score is: " + displayScore, 100, (height/2)+35);
}




void keyPressed() {
  keyIsPressed[keyCode] = true;
  if (key =='r' && addScoreTime==false || key=='R' && addScoreTime==false) {
    setup();
    addScoreTime = true;
    amtLives = 5;
    targetScore=0;
  }
}



void keyReleased() {
  keyIsPressed[keyCode] = false;
}


void showScore() {
  fill(255);
  textSize(22);
  if (displayScore < targetScore) {
    fill(#ffcc00);
  }
  if (displayScore > targetScore) {
    fill(#FF0000);
  }
  text(scoreString + displayScore, 10, height-10);
  fill(255);
  text(lives + amtLives, 120, height-10);

  if (addScoreTime) {
    if (frameCount % 60 == 0) {
      targetScore+=1;
    }
  }
}

void restart() {
  invincibility=true;

  savedTime = millis(); // Save the current time to restart the timer!
  x=15;
  y=15;
  flashingL=true;
  velocityX = 0;
  velocityY = 0;
  if (addScoreTime) {
    amtLives-=1;
    addscore(-30);
  }
  //invincibility=true;
}

int addscore (int addedScore) {
  targetScore += addedScore;

  flashDifference(addedScore);
  int diff = targetScore-displayScore;

  return addedScore;
}

void flashDifference(int addedScore) {
  flashing=true;
}





void resetKey() {
  xPosKey =random(50, width-50);
  yPosKey = random(50, height-50);
}

void resetInv() {
  xPosInv =random(50, width-50);
  yPosInv = random(50, height-50);
}



//void flashingScore(int addedScore){
//  fill(0);
//  text(addedScore, 150,150);
//}

//void mousePressed(){
//  amtLives = 5;
//}

