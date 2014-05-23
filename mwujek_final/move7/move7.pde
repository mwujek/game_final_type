//You have to add a processing library first!!
//sketch > import library > add library > "box2d for processing"

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
String plusOrMinus="";
String plusOrMinusLife="";
float circleTop=5;
boolean runOnceInv=true;
float seconds;
float shieldOpacity = 150;
int i = 9;
boolean newInv = false;
int flashScore;
int flashLife;
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
float invAmt;
float addedWidth;



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

int amtLives = 3;
String lives="lives: ";
String scoreString="score: ";

String levelEnd = "level complete! ";
String yourScore = "Your score is: ";
boolean addScoreTime = true;
float counter = 0;
float counterLife = 0;
float counterSpeed= 6;

boolean runonce = true;
boolean onlyGreen = false;
//keys and coins

boolean keyFound = false;
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
boolean runOnceLife=true;
float opacity = 0;
PImage keyIcon;
PImage bg;
PImage ship;

float bgXPos =2;
float bgYPos =2;





float x, y, thrust, inverseDrag, velocityX, velocityY, angle, torque;
boolean[] keyIsPressed = new boolean[256];
//Circle[] circles = new Circle[10];

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
ArrayList<Circle> circles;

float targetX;
float targetY;
//timing 
int savedTime;
int totalTime = 2500;
int savedTimeInv;
int totalTimeInv = 6000;

void setup() {
  //timing
  savedTime = millis();
  keyIcon = loadImage("star.png");
  bg = loadImage("bg.jpg");
  ship = loadImage("ship.png");
  apercu = loadFont("Apercu-Bold-48.vlw");
  textFont(apercu);


  size(600, 400);
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
  //
  //  for (int i = 0; i < circles.length; i++) {
  //    circles[i] = new Circle((width/2+100), random(height-50), 50, radiusDifference, 4, margin, int(random(50, 100)), int(random(-50, -200)));
  //  }


  boundaries = new ArrayList<Boundary>();

  boundaries.add(new Boundary(0, height-5, width*2, 10));
  boundaries.add(new Boundary(0, 5, width*2, 10));
  boundaries.add(new Boundary(width-5, height/2, 10, height));
  boundaries.add(new Boundary(5, height/2, 10, height));


  //setup attractors
  easyAttractor = new Attractor(12, mouseX, mouseY);
  attractedCircles = new ArrayList<AttractedCircle>();
  circles = new ArrayList<Circle>();
}


void draw() {
  //print(runOnceLife);
  // Calculate how much time has passed
  int passedTime = millis() - savedTime;
  int passedTimeInv = millis() - savedTimeInv;
  targetX = x;
  targetY = y;
  //if(

  image(bg, -50+(targetX/35), -50+(targetY/35));
  bgXPos = constrain(bgXPos, -50, 500);
  bgYPos = constrain(bgXPos, -50, 500);


  //invincibility

  if (displayScore>50) {
    // resetInv();
  }

  if (newInv) {
    image(keyIcon, xPosInv, yPosInv);
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
  if (distFromKey<36) {
    keyFound = true;
    flashScore =addscore(50);
    addInvTally();
     circleTop--;
  }



  if (keyFound) {

    xPosKey = -100;
    yPosKey = -100;
    runOnceInv=true;
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
    seconds = int(passedTimeInv/600);  
    if (state) {
      //
      if (invAmt%5==0 && invAmt!=0) {
        onlyGreen = true;
        stroke(#82FC7A);
        fill(#10FF00, shieldOpacity);
        shieldOpacity-=0.8;
        shieldOpacity = constrain(shieldOpacity, 5, 255);
        ellipse(0, 0, 50, 50);
      }
    }

    if ((frameCount%(14-seconds)==0)) {
      state=!state;
    }
    //reset invincibility?
    if (passedTime > totalTime) {
      //println( " 5 seconds have passed! " );
      invincibility =false;
      
    } 
    else {
      shieldOpacity=150;
    }

    if (onlyGreen ==false) {
      tint(100, opacity);
      fill(255, 100);
      ellipse(0, 0, 50, 50);
    }
  }
  //add extra life
  if (invAmt%20==0 && invAmt!=0) {
    if (runOnceLife) {

      plusOne();
      runOnceLife=false;
      invAmt++;
    } // Save
  }
  else {
    runOnceLife=true;
  }
  if (invAmt%5==0 && invAmt!=0) {
    if (runOnceInv) {
      savedTimeInv = millis();
      runOnceInv=false;
    } // Save the current time to restart the timer!
    if (passedTimeInv > totalTimeInv) {
      //println( " 5 seconds have passed! " );
      invincibility =false;
      
      onlyGreen=false;
    } 
    else {
      invincibility=true;
    }
  }


  //origin
  //ellipse(0,0,2,2);
  popMatrix();  

  showScore();

  //circles!!

  for (int i = 0; i < circles.size()-1; i++) {
    // Look, this is just like what we had before!
    circles.get(i).display();
    if (frameCount%500==0) {
      circles.get(i).energy();
    }
    if (circles.get(i).collided()&&invincibility ==false) {
      fill(#1BAA85);
      ellipse(x, y, 10, 10);
      noFill();
      
      circles.get(i).done();
      restart();
    }
  }

  //display and update attractors
  float randomNumber = random(1);
  if (frameCount % 160 == 0) {
    if (randomNumber<0.25) {
      AttractedCircle ea = new AttractedCircle(width-8, 8, random(20, 30), 10, 0.5, -1); //top right
      attractedCircles.add(ea);
    } 
    else if (randomNumber>0.25 && randomNumber<0.5) {
      AttractedCircle ea = new AttractedCircle(8, 8, random(20, 30), 10, 0.5, -1); //top left
      attractedCircles.add(ea);
    } 
    else if (randomNumber>0.5 && randomNumber<0.75) {
      AttractedCircle ea = new AttractedCircle(width-8, height-8, random(20, 30), 10, 0.5, -1); //bottom right
      attractedCircles.add(ea);
    }
    else {
      AttractedCircle ea = new AttractedCircle(8, height-8, random(20, 30), 10, 0.5, -1); //bottom left
      attractedCircles.add(ea);
    }



    //Circle ca = new Circle(0, 0, 50, radiusDifference, 4, margin, 50, 50);
    //circles.add(ca);
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
      for (int i =0; i<circleTop;i++){
    fill(#10FF00,200);
    if(onlyGreen){
      ellipse(250+i*20,-20,10,10);
    }else{
  ellipse(250+i*20,20,10,10);
  }
  }
    
  }

  if (flashing && addScoreTime) {
    fill(255, flashOpacity);
    flashOpacity-=5;
    flashHeight-=0.5;
    if (flashScore>0) {
      plusOrMinus="+";
    } 
    else {
      plusOrMinus="";
    }
    text(plusOrMinus+flashScore, 68, (height-20)+flashHeight);
    if (flashOpacity<0) {
      flashing=false;
    }
  }
  else {
    flashOpacity=255;
    flashHeight= 0;
  }

  if (flashingL && addScoreTime) {
    fill(255, 100, 0, flashOpacityL);
    flashOpacityL-=5;
    flashHeightL-=0.5;
    if (flashLife>0) {
      plusOrMinusLife="+";
    } 
    else {
    }
    text(plusOrMinusLife+flashLife, 178, (height-20)+flashHeightL);
    if (flashOpacityL<0) {
      flashingL=false;
    }
  }
  else {
    flashOpacityL=255;
    flashHeightL= 0;
  }
  //println(addedScore);
  println(circleTop);
 
if (circleTop<1){
  circleTop=5;

}
} //end draw loop 

//void levelCompleted() {
//  addScoreTime = false;
//  background(0);
//  fill(#ffcc00);
//  textSize(28);
//  if (runonce) {
//    addscore(100);
//    runonce = false;
//  }
//  text(levelEnd + yourScore +displayScore, 50, height/2);
//}


void gameOver() {

  addScoreTime = false;
   circleTop=5;
  displayScore = displayScore;
  rectMode(CENTER);
  fill(0);
  x=-50;
  y=-50;

  if (growingBox<width) {
    growingBox+=10;
  }
  rectMode(CORNER);
  rect(growingBox-width, 0, width, 400);

  fill(#ffcc00);
  //textSize(28);
  text("Game Over!", 100, height/2);
  text("Your final score is: " + displayScore, 100, (height/2)+35);
  fill(255);
  tint(255, opacity);
  text("Press 'R' to Restart!", 100, (height/2)+120);
}




void keyPressed() {
  keyIsPressed[keyCode] = true;
  if (key =='r' && addScoreTime==false || key=='R' && addScoreTime==false) {
    setup();
    invAmt=0;
    addScoreTime = true;
    amtLives = 3;
    growingBox=0;
    displayScore=0;
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
  if (displayScore>999) {
    addedWidth=15;
  }
  else {
    addedWidth=0;
  }

  text(lives + amtLives, 130+addedWidth, height-10);

  if (addScoreTime) {
    if (frameCount % 60 == 0) {
      targetScore+=1;
    }
  }
}
void plusOne() {
  flashingL=true; 
  flashLife = addlife(1);
}

void restart() {

  invincibility=true;

  savedTime = millis();
  savedTimeInv = millis(); // Save the current time to restart the timer!
  x=15;
  y=15;
  flashingL=true;
  velocityX = 0;
  velocityY = 0;
  if (addScoreTime) {
    flashLife = addlife(-1);
    flashScore = addscore(-30);
  }
  //invincibility=true;
}

int addscore (int addedScore) {
  targetScore += addedScore;

  flashDifference(addedScore);
  int diff = targetScore-displayScore;
  onlyGreen=false;


  return addedScore;
}

void flashDifference(int addedScore) {
  flashing=true;
}





void resetKey() {
  xPosKey =random(50, width-50);
  yPosKey = random(50, height-50);
 
}

//void resetInv() {
//  xPosInv =random(50, width-50);
//  yPosInv = random(50, height-50);
//}



//void flashingScore(int addedScore){
//  fill(0);
//  text(addedScore, 150,150);
//}

//void mousePressed(){
//  amtLives = 5;
//}

void addInvTally() {
  invAmt++;
}

int addlife( int amtAdded) {
  amtLives+=amtAdded;
  return amtAdded;
}

