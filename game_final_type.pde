PFont apercu;
String title="dis dis dat";
String credits="matt wujek";
String start="press any key to start";
int score=100;
String input="";


float filling;
float speed = 5;
boolean goingDown;
boolean titleVisible = true;
int bgFill=200;
float boxX;
float boxY;

float angle;
float c;
float jitter;
float x,y,r,theta;
float speedTri=1;


void setup() {
  size(600, 400);
  apercu = loadFont("Apercu-Bold-48.vlw");
  textFont(apercu);
}

void draw() {
x = r * cos( theta );
y = r * sin( theta );

  background(bgFill);
  //titleisSHOWING
  if (titleVisible) {
    if (goingDown) {
      filling -=speed;
    } 
    else {
      filling +=speed;
    }
    if (filling > 200) {
      goingDown = true;
    } 
    if (filling<-1) {
      goingDown = false;
    }


    fill(255);
    textSize(48);
    text(title, 20, 100);
    text(credits, 20, 150);
    fill(0, filling);
    textSize(28);
    text(start, 20, 220);
  } 
  else {
    showScore();
    showBox();
  }
}
void showBox() {
  float c = 3.14*sin(angle);
  
  translate(boxX, boxY);
  rotate(theta);
  point(0,0);
  fill(0,50);
  triangle((boxX-10), boxY-10, boxX, boxY+10, (boxX+10), boxY-10);
  if (mousePressed) {
theta+=0.2;
}

}
void keyPressed() {
  titleVisible= false;
  input = input + key;
  if (key == CODED) {
    if (keyCode ==LEFT) {
      bgFill=(128);
      boxX-=speedTri;
    } 
    else if (keyCode ==RIGHT) {
      bgFill=255;
      boxX+=speedTri;
    } 
    else if (keyCode ==UP) {
      boxY-=speedTri;
    }
    
    else if (keyCode ==DOWN) {
      boxY+=speedTri;
    }
  }
}


void showScore() {
  fill(0);
  textSize(28);
  text(score, 50,50);
  text(input, 50, 80);
  if (frameCount %10==0) {
    score-=1;
  }
}

