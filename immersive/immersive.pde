//immersive screen

PImage img;
PImage orange1;
PImage orange2;
PImage orange3;
PImage orange4;
PImage bird1;
PImage bird2;
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

boolean stage1_flytoOrange = false;
boolean stage2_poking = false;
boolean stage3_flyBack = false;
boolean stage4_sleep = false;

String quadrant = "";

import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;
Table table;
PGraphics offscreen;
boolean dropOrange = false;

void saveOrangePosition(float orangex, float orangey) {
  table = new Table();

  table.addColumn("OrangeX");
  table.addColumn("OrangeY");

  TableRow newRow = table.addRow();
  newRow.setFloat("OrangeX", orangex);
  newRow.setFloat("OrangeY", orangey);

  saveTable(table, "../data/position.csv");
}

void loadOrangePosition() {
  table = loadTable("../data/position.csv", "header");

  println(table.getRowCount() + " total rows in table");

  float x_ = table.getFloat(0, "OrangeX");
  float y_ = table.getFloat(0, "OrangeY");

  println("x_:", x_, "y_:", y_);
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

  // Keystone will only work with P3D or OPENGL renderers,
  // since it relies on texture mapping to deform
  size(2500, 1500, P3D);

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





  if (dropOrange == false) {
    offscreen.imageMode(CENTER);
    offscreen.image(orange2, orangeXLocation, orangeYLocation, 40, 40);
  }

  offscreen.pushMatrix();
  offscreen.translate(birdX, birdY);

  offscreen.rotate(angle); // rotating



  offscreen.imageMode(CORNER);
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
    } // if
  } // if


  //translated origin / red cross
  offscreen.stroke(200, 0, 0);
  offscreen.line(-10, 0, 10, 0);
  offscreen.line(0, -10, 0, 10);

  offscreen.popMatrix();

  //println("quadrant: ", quadrant);
  if (stage1_flytoOrange == false) {
    //record the state of the bird before flying to the orange

    //record angle from bird's original position to the target orange
    angle = atan2(orangeYLocation - birdY, orangeXLocation-birdX) + PI/2;


    ratio = (abs(orangeXLocation-birdX)/abs(orangeYLocation-birdY));

    //record quadrant and change speed
    setSpeed(orangeXLocation, orangeYLocation, birdX, birdY);


    stage1_flytoOrange = true;
  } else if (stage1_flytoOrange == true && stage2_poking == false) {

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

    //start poking the orange

    if (startTime == false) {
      time = millis();
      startTime = true;
    } else {
      birdX += xSpeed;
      birdY += ySpeed;

      if (millis() > time + 250) {

        startTime = false;
        ySpeed *=-1;
        xSpeed *=-1;
      }
    }

    //call robot push and drop the orange
    //here we will just wait for some time
    if (startTime2 == false) {
      time2 = millis();
      startTime2 = true;
    } else {

      if (millis() > time2 + 1000) {



        startTime2 = false;
        dropOrange = true;
        stage3_flyBack = true;

        //record go back angles
        angle = atan2(birdNestY - birdY, birdNestX-birdX) + PI/2;

        ratio = (abs(birdNestY-birdX)/abs(birdNestX-birdY));

        //record quadrant and change speed
        setSpeed(birdNestX, birdNestY, birdX, birdY);

      }
    }
  } else if (stage3_flyBack == true && stage4_sleep == false) {

    //bird fly back now
    if (abs(birdX - (birdNestX)) < 3 && abs(birdY -(birdNestY)) < 3) {
      stage4_sleep = true;
    } else {

      birdX += xSpeed;
      birdY += ySpeed;
    }
  } else if (stage4_sleep == true) {

    //bird go to sleep
    offscreen.textSize(25);
    offscreen.fill(0);
    offscreen.text("ZZZZ", 150, 100);
  }

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
  case 'd':
    dropOrange = true;
    break;
  case 'r':
    dropOrange = false;
    break;
  }
}
