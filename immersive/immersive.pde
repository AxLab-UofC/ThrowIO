//immersive screen

PImage img;
PImage orange1;
PImage orange2;
PImage orange3;
PImage orange4;
PImage bird1;
PImage bird2;
PImage bird3;
float orangeXLocation = 500;
float orangeYLocation = 200;



boolean startTime = false;
int time = millis();
boolean startTime2 = false;
int time2 = millis();

final int HowLongIsItWaiting1 = 300;
final int HowLongIsItWaiting2 = 300;
float m = millis(); // sores millis()
char state='A';  // A or B
float birdX = 0;
float birdY = 0;
float birdNestX = 50;
float birdNestY = 50;
float angle = 0.0;

float xSpeed = 1.0;
float ratio = (orangeXLocation/orangeYLocation);
float ySpeed = 1.0*ratio;

boolean stage1_flyToOrange = false;
boolean stage2_poking = false;
boolean stage3_flyBack = false;
boolean stage4_sleep = false;
boolean birdRest = false;

String quadrant = "";

import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
Table table;
PGraphics offscreen;
boolean dropOrange = false;
int flyToOrange = 0;
int dropFruit = 0;
int nextOrange = 0;
float OrangeX1 = 0;
float OrangeY1 = 0;
float OrangeX2 = 0;
float OrangeY2 = 0;
int orangeCount = 0;


void loadOrangePosition() {
  table = loadTable("../data/position.csv", "header");

  //println(table.getRowCount() + " total rows in table");

  float OrangeX1_ = table.getFloat(0, "OrangeX1");
  float OrangeY1_ = table.getFloat(0, "OrangeY1");
  float OrangeX2_ = table.getFloat(0, "OrangeX2");
  float OrangeY2_ = table.getFloat(0, "OrangeY2");
  int flyToOrange_ = table.getInt(0, "flyToOrange");
  int dropFruit_ = table.getInt(0, "dropFruit");
  int nextOrange_ = table.getInt(0, "nextOrange");


  //println("x_:", x_, "y_:", y_, "flyToOrange_:", flyToOrange_, "dropFruit_:", dropFruit);

  OrangeX1 = OrangeX1_;
  OrangeY1 = OrangeY1_;
  OrangeX2 = OrangeX2_;
  OrangeY2 = OrangeY2_;

  //if (orangeCount == 0) {
  //  orangeXLocation = OrangeX1;
  //  orangeYLocation = OrangeY1;
  //} else {
  //  orangeXLocation = OrangeX2;
  //  orangeYLocation = OrangeY2;
  //}

  flyToOrange = flyToOrange_;
  dropFruit = dropFruit_;
  nextOrange = nextOrange_;
}

void setSpeed(float targetX, float targetY, float bx, float by) {

  if (targetX > bx && targetY < by ) {
    //Q1
    quadrant = "1";
    xSpeed = +1.0*ratio;
    ySpeed = -1.0;
  } else if (targetX < bx && targetY < by) {
    //Q2
    quadrant = "2";
    xSpeed = -1.0*ratio;
    ySpeed = -1.0;
  } else if (targetX < bx && targetY > by) {
    //Q3
    quadrant = "3";
    xSpeed = -1.0*ratio;
    ySpeed = +1.0;
  } else if (targetX > bx && targetY > by) {
    //Q4
    quadrant = "4";
    xSpeed = 1.0*ratio;
    ySpeed = 1.0;
  } else if (targetX == bx && targetY < by) {

    quadrant = "12";
    xSpeed = 0.0;
    ySpeed = -1.0;
  } else if (targetX < bx && targetY == by) {

    quadrant = "23";
    xSpeed = -1.0;
    ySpeed = 0.0;
  } else if (targetX == bx && targetY > by) {

    quadrant = "34";
    xSpeed = 0.0;
    ySpeed = 1.0;
  } else if (targetX > bx && targetY == by) {

    quadrant = "14";
    xSpeed = 1.0;
    ySpeed = 0.0;
  }
}

void setup() {
  //size(614,433);
  img = loadImage("tree.jpeg");
  orange1 = loadImage("orange.png");
  orange2 = loadImage("orange2.png");
  orange3 = loadImage("orange3.png");
  orange4 = loadImage("orange4.png");


  bird1 = loadImage("birdFly1.png");
  bird2 = loadImage("birdFly2.png");
  bird3 = loadImage("birdRest.png");

  // Keystone will only work with P3D or OPENGL renderers,
  // since it relies on texture mapping to deform
  //size(2500, 1500, P3D);

  size(614, 433, P3D);



  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(614, 433, 20); //614, 433, 20

  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(614, 433, P3D);
  birdX = birdNestX;
  birdY = birdNestY;

  loadOrangePosition();
}


void draw() {

  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the
  // surface from your screen.
  PVector surfaceMouse = surface.getTransformedMouse();

  //// Draw the scene, offscreen
  offscreen.beginDraw();

  offscreen.imageMode(CORNER);
  offscreen.image(img, 0, 0, 614, 433); //tree image





  if (dropOrange == false && orangeCount == 0) {
    offscreen.imageMode(CENTER);
    offscreen.image(orange2, OrangeX1, OrangeY1, 40, 40);
    offscreen.imageMode(CENTER);
    offscreen.image(orange2, OrangeX2, OrangeY2, 40, 40);
  } else if (dropOrange == true && orangeCount == 0) {
    offscreen.imageMode(CENTER);
    offscreen.image(orange2, OrangeX2, OrangeY2, 40, 40);
  } else if (dropOrange == false && orangeCount == 1) {
    offscreen.imageMode(CENTER);
    offscreen.image(orange2, OrangeX2, OrangeY2, 40, 40);
  }

  offscreen.pushMatrix();
  offscreen.translate(birdX, birdY);

  offscreen.rotate(angle); // rotating



  offscreen.imageMode(CORNER);
  if (birdRest == true) {

    offscreen.image(bird2, -745/8, 0, 745/4, 293/4);
  } else {
    if (state=='B') {
      offscreen.image(bird1, -745/8, 0, 745/4, 355/4);

      if (millis()-m>HowLongIsItWaiting1) {
        m = millis();
        state='A';
      } // if
    } else if (state=='A') {
      offscreen.image(bird2, -745/8, 0, 745/4, 293/4);



      if (millis()-m>HowLongIsItWaiting2) {
        m = millis();
        state='B';
      }
    }
  }



  //translated origin / red cross
  offscreen.stroke(200, 0, 0);
  offscreen.line(-10, 0, 10, 0);
  offscreen.line(0, -10, 0, 10);

  offscreen.popMatrix();

  //println("quadrant: ", quadrant);
  if (stage1_flyToOrange == false) {
    println("Stage 0 preparing ");
    println("orangeYLocation: ", orangeYLocation);

    if (orangeCount == 0) {
      orangeXLocation = OrangeX1;
      orangeYLocation = OrangeY1;
    } else {
      orangeXLocation = OrangeX2;
      orangeYLocation = OrangeY2;
    }
    
    //record the state of the bird before flying to the orange

    //record angle from bird's original position to the target orange
    angle = atan2(orangeYLocation - birdY, orangeXLocation-birdX) + PI/2;


    ratio = (abs(orangeXLocation-birdX)/abs(orangeYLocation-birdY));

    //record quadrant and change speed
    setSpeed(orangeXLocation, orangeYLocation, birdX, birdY);

    if (flyToOrange == 1) {

      stage1_flyToOrange = true;
    } else {
      loadOrangePosition();
    }
  } else if (stage1_flyToOrange == true && stage2_poking == false) {
    println("Stage 1 fly to orange ");
    if (abs(birdX - (orangeXLocation)) < 3 && abs(birdY -(orangeYLocation)) < 3) {
      stage2_poking = true;

      //making speed the opposite direction so that bird would go backwards first when start poking
      ySpeed *=-1;
      xSpeed *=-1;
    } else {

      birdX += xSpeed;
      birdY += ySpeed;
    }
  } else if (stage2_poking == true && stage3_flyBack == false) {
    println("Stage 2 Poking ");
    //start poking the orange

    if (startTime == false) {
      time = millis();
      startTime = true;
    } else {
      birdX += xSpeed;
      birdY += ySpeed;

      if (millis() > time + 100) {

        startTime = false;
        ySpeed *=-1;
        xSpeed *=-1;
      }
    }

    //call robot push and drop the orange
    //here we will just wait for some time


    if (dropFruit == 1) {

      dropOrange = true;
      stage3_flyBack = true;
    } else {

      loadOrangePosition();
    }

    //record go back angles
    //angle = atan2(birdNestY - birdY, birdNestX-birdX) + PI/2;

    //ratio = (abs(birdNestY-birdX)/abs(birdNestX-birdY));

    ////record quadrant and change speed
    //setSpeed(birdNestX, birdNestY, birdX, birdY);
  } else if (stage3_flyBack == true) {

    println("Stage3 Fly Back");
    //bird go to sleep
    birdRest = true;
    offscreen.textSize(25);
    offscreen.fill(0);
    offscreen.text("ZZZZ", birdX+10, birdY+10);

    if (nextOrange == 0) {
      loadOrangePosition();
    } else if(nextOrange == 1 && orangeCount == 0){
      //set the orange position to the second orange position
      orangeCount+=1;
      stage1_flyToOrange = false;
      stage2_poking = false;
      stage3_flyBack = false;
      //stage4_sleep = false;
      dropOrange = false;
    }
  }




  //else if (stage3_flyBack == true && stage4_sleep == false) {

  //  //bird fly back now
  //  if (abs(birdX - (birdNestX)) < 3 && abs(birdY -(birdNestY)) < 3) {
  //    stage4_sleep = true;
  //  } else {

  //    birdX += xSpeed;
  //    birdY += ySpeed;
  //  }
  //}


  //offscreen.image(orange1, 50, 50, 40, 40);
  //offscreen.image(orange2, 200, 200, 40, 40);
  //offscreen.image(orange3, 450, 70, 40, 40);
  //offscreen.image(orange4, 500, 300, 40, 40);
  //offscreen.image(orange1, 260, 30, 40, 40);
  //offscreen.image(orange2, 510, 250, 40, 40);
  //offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);
  //offscreen.ellipse(100, 100, 40, 40);
  //offscreen.ellipse(500, 120, 40, 40);
  //offscreen.ellipse(450, 70, 40, 40);
  //offscreen.ellipse(400, 100, 40, 40);
  //offscreen.ellipse(420, 176, 40, 40);
  //offscreen.ellipse(300, 67, 40, 40);
  //offscreen.ellipse(260, 30, 40, 40);
  //offscreen.ellipse(500, 370, 40, 40);
  //offscreen.ellipse(450, 400, 40, 40);
  //offscreen.ellipse(510, 250, 40, 40);

  offscreen.endDraw();


  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  case 'b':
    if (flyToOrange == 0) {
      flyToOrange = 1;
    } else {
      flyToOrange = 0;
    }
    break;
  case 'n':
    if (dropFruit == 0) {
      dropFruit = 1;
    } else {
      dropFruit = 0;
    }
    break;
  case 'm':
    orangeCount+=1;
    nextOrange = orangeCount;
    dropFruit = 0;
    flyToOrange = 0;
    stage1_flyToOrange = false;
    stage2_poking = false;
    stage3_flyBack = false;
    stage4_sleep = false;
    dropOrange = false;
    break;
  }
}
