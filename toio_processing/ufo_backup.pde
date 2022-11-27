////Basketball game application
////This is the code for demo for dropping
//import oscP5.*;
//import netP5.*;
//import processing.serial.*;
//import org.openkinect.freenect.*;
//import org.openkinect.freenect2.*;
//import org.openkinect.tests.*;
//import processing.video.*;
//import org.openkinect.processing.*;
//import org.openkinect.*;
//import javax.swing.*;
//import shiffman.box2d.*;
//import org.jbox2d.common.*;
//import org.jbox2d.dynamics.joints.*;
//import org.jbox2d.collision.shapes.*;
//import org.jbox2d.collision.shapes.Shape;
//import org.jbox2d.common.*;
//import org.jbox2d.dynamics.*;
//import org.jbox2d.dynamics.contacts.*;
//import processing.sound.*;

////camera
//Capture video;
//Kinect kinect;
//color trackColor;
//float threshold = 40; //150 for red
//int clickCount = 0;
//int mouseXLocation = -50;
//int mouseYLocation = -50;
//boolean flag_ballSticks = false;
//int[] mouseXLocationList = new int[4];
//int[] mouseYLocationList = new int[4];
////float scaledX = -1000;
////float scaledY = -1000;
//int global_closer_toio_id = 0;
////for OSC
//OscP5 oscP5;
////where to send the commands to
//NetAddress[] server;
////int cubesPerHost = 4; // each BLE bridge can have up to 4 cubes

////we'll keep the cubes here
//Cube[] cubes;
////int nCubes =  4;

//boolean mouseDrive = false;
//boolean chase = false;
//boolean spin = false;


//float global_radius = 120;
//float global_x = 0.0;
//float global_y = 0.0;
//float global_x2 = 0.0;
//float global_y2 = 0.0;
//float global_finalx = 0.0;
//float global_finaly = 0.0;
//float global_xprime = 0.0;
//float global_yprime = 0.0;
//boolean flag_findTangentPoints = false;

//float global_c0_dist = 0.0;
//float global_c1_dist = 0.0;
//float global_ball_x = 0; //sx
//float global_ball_y = 0; //sy
//float global_toio_center_x = 0; //cx
//float global_toio_center_y = 0; //cy
//float global_scaledX = 60;
//float global_scaledY = 100;
//float c0_dist_ball = 0.0;
//float c1_dist_ball = 0.0;
//String global_furtherTangentPoint;
//float global_backoutx0 = 0;
//float global_backouty0 = 0;
//float global_backoutx1 = 0;
//float global_backouty1 = 0;
//float global_bitMoreThanRadius = global_radius+20;


//boolean flag_outsideRadius = true;
//boolean flag_converge = false;
//boolean flag_knockSucceed = false;
//int closeDistance = 45;
//int closeDistance2 = 45;
//boolean flag_seeBall = false;
//int time = millis();
//boolean startTime = false;
//boolean turnFlag = false;
//boolean turnFlag1 = false;
//boolean turnFlag2 = false;
//boolean recordDegree = false;
//boolean flag_recordPushingToioPushLocationAngle = false;
//boolean prepareBackout = false;
//float turnDegree1 = 0;
//float turnDegree0 = 0;
//boolean findDistBall = false;
//boolean findDist = false;
//float tangentX = 0;
//float tangentY = 0;
//boolean firstRotation = false;
//boolean secondRotation = false;
//boolean separate = false;
//boolean killUFO = false;
//boolean bombSound = false;

//float[] xHist = {};
//float[] yHist = {};
//float[] dHist = {};
//int rawDepth = 0;
//float depthDiff;
//float xDiff;
//float throwDegree;
//float avgZVelocity = 0.0;
//float avgXVelocity = 0.0;
//boolean addParticle = false;
//int time2 = millis();
//boolean startTime2 = false;
//float bulletx = 0;
//float bullety = 0;
//float monitorAdjustment = 130;

//// A reference to our box2d world
//Box2DProcessing box2d;
//float monitorWidth = 0;
//float monitorHeight = 0;
//float ySpeed = 1;
//float xSpeed = 1;
//float ycoord = 300;
//float xcoord = 400;
//boolean hitTarget = false;
//float hitX = 720;
//float pushx = 360; //400
//float pushy = 240; //300
//boolean travelOut = false;
//boolean travelToPush = false;
//boolean turning = false;
//boolean flag_pushDone = false;
//boolean findDistBall2 = false;
//boolean facePushLocation = false;
//boolean findPushedBallLocation = false;
//int pushToio = 0;
//boolean nextBall = false;
//boolean startSprinkle = false;
//boolean ballDidNotStick = false;
//int scoreCount = 0;

////global variables that helper functions would modify
//float global_avgX = 0;
//float global_avgY = 0;
//int global_count = 0;
//float global_avgDepth = 0;
//float[] global_xHist = {};
//float[] global_yHist = {};
//float[] global_dHist = {};

//SoundFile file;
//boolean startCrash = false;
//boolean startSelfCrash = false;
//String instruction = "Throw ball! Hit UFO!";
////text("Nice try!\nThrow slower!", 605, 450);

//void captureEvent(Capture video) {
//  video.read();
//}

//void setup() {
//  // for OSC
//  // receive messages on port 3333
//  oscP5 = new OscP5(this, 3333);

//  //send back to the BLE interface
//  //we can actually have multiple BLE bridges
//  server = new NetAddress[1]; //only one for now
//  //send on port 3334
//  server[0] = new NetAddress("127.0.0.1", 3334);
//  //server[1] = new NetAddress("192.168.0.103", 3334);
//  //server[2] = new NetAddress("192.168.200.12", 3334);

//  //create cubes
//  cubes = new Cube[nCubes];
//  for (int i = 0; i< cubes.length; ++i) {
//    cubes[i] = new Cube(i, true);
//  }

//  //camera
//  size(640, 360);
//  kinect = new Kinect(this);
//  kinect.initDepth();
//  kinect.initVideo();

//  //do not send TOO MANY PACKETS
//  //we'll be updating the cubes every frame, so don't try to go too high
//  frameRate(30);

//  box2d = new Box2DProcessing(this);
//  box2d.createWorld();
//  box2d.setGravity(0, -50); //we can change the gravity in box2D world here, currently using -120

//  //allow two windows showing up at the same time
//  //one for camera, the other for monitor screen
//  String[] args = {"TwoFrameTest"};
//  SecondApplet sa = new SecondApplet();
//  PApplet.runSketch(args, sa);

//  file = new SoundFile(this, "explosion.wav");

//  //local saved data
//  //mouseXLocationList[0] = 66;
//  //mouseYLocationList[0] = 2;
//  //mouseXLocationList[1] = 564;
//  //mouseYLocationList[1] = 353;
//}

////visual displays in the monitor window
//public class SecondApplet extends PApplet {

//  //an ArrayList of particles that will fall on the surface
//  ArrayList<Particle> particles;

//  //a list we'll use to track fixed objects
//  ArrayList<Boundary> boundaries;

//  ArrayList<smallParticle> smallParticles;
//  ArrayList<smallSelfParticle> smallSelfParticles;

//  class Boundary {

//    //a boundary is a simple rectangle with x,y,width, and height
//    float x;
//    float y;
//    float w;
//    float h;
//    //but we also have to make a body for box2d to know about it
//    Body b;

//    Boundary(float x_, float y_, float w_, float h_, float a) {
//      x = x_;
//      y = y_;
//      w = w_;
//      h = h_;

//      // Define the polygon
//      PolygonShape sd = new PolygonShape();
//      // Figure out the box2d coordinates
//      float box2dW = box2d.scalarPixelsToWorld(w/2);
//      float box2dH = box2d.scalarPixelsToWorld(h/2);
//      // We're just a box
//      sd.setAsBox(box2dW, box2dH);

//      // Create the body
//      BodyDef bd = new BodyDef();
//      bd.type = BodyType.STATIC;
//      bd.angle = a;
//      bd.position.set(box2d.coordPixelsToWorld(x, y));
//      b = box2d.createBody(bd);

//      // Attached the shape to the body using a Fixture
//      b.createFixture(sd, 1);
//    }

//    // Draw the boundary, it doesn't move so we don't have to ask the Body for location
//    void display() {
//      fill(0);
//      stroke(0);
//      strokeWeight(1);
//      rectMode(CENTER);
//      float a = b.getAngle();
//      pushMatrix();
//      translate(x, y);
//      rotate(-a);
//      rect(0, 0, w, h);
//      popMatrix();
//    }
//  }

//  //particle class is the ball that show up in our monitor
//  class Particle {

//    // We need to keep track of a Body and a radius
//    Body body;
//    float r;
//    color col;

//    Particle(float x, float y, float r_, float l, float v) { //x will be x velocity and y will be z velocity
//      r = r_;
//      // This function puts the particle in the Box2d world
//      makeBody(x, y, r, l, v);
//      body.setUserData(this);
//      col = color(204, 102, 0);
//    }

//    // This function removes the particle from the box2d world
//    void killBody() {
//      box2d.destroyBody(body);
//    }

//    // Change color when hit
//    void change() {
//      col = color(255, 0, 0);
//    }

//    // Is the particle ready for deletion?
//    boolean done() {
//      // Let's find the screen position of the particle
//      Vec2 pos = box2d.getBodyPixelCoord(body);
//      // Is it off the bottom of the screen?
//      if (pos.y > height+r*2) {
//        killBody();
//        return true;
//      } else if (pos.y < 200) {

//        //this is when you did not hit the UFO
//        startSelfCrash = true;
//        bulletx = pos.x;
//        bullety = pos.y;
//        killBody();
//        return true;
//      } else if (abs(pos.x - xcoord) < 80 && abs(pos.y - ycoord) < 80 && killUFO == false) {

//        //this is when you hit the UFO
//        instruction = "Good job! Next ball!";
//        bombSound = true;
//        killUFO = true;
//        startCrash = true;
//        scoreCount+=1;

//        killBody();
//        return true;
//      }

//      return false;
//    }

//    //check if a ball went into the hoop
//    boolean goal() {
//      // Let's find the screen position of the particle
//      Vec2 pos = box2d.getBodyPixelCoord(body);
//      if (pos.y > 350 && pos.y <= 550 && pos.x >= 450 && pos.x <= 750) { //this is the condition for scoring
//        return true;
//      }
//      return false;
//    }

//    void display() {
//      // We look at each body and get its screen position
//      Vec2 pos = box2d.getBodyPixelCoord(body);
//      // Get its angle of rotation
//      float a = body.getAngle();
//      pushMatrix();
//      translate(pos.x, pos.y);
//      rotate(a);
//      fill(col);
//      stroke(0);
//      strokeWeight(1);
//      ellipse(0, 0, r*2, r*2);
//      // Let's add a line so we can see the rotation
//      //line(0, 0, r, 0);
//      popMatrix();
//    }

//    // Here's our function that adds the particle to the Box2D world
//    // x is x position, y is y position, r is radius, l is linear velocity, v is vertical velocity
//    //x = 400, y = 720, r , l = 15, v = 95
//    void makeBody(float x, float y, float r, float l, float v) {
//      // Define a body
//      BodyDef bd = new BodyDef();
//      // Set its position

//      bd.position = box2d.coordPixelsToWorld(x, y); //monitor is 720 height and 1280 width
//      bd.type = BodyType.DYNAMIC;
//      body = box2d.createBody(bd);

//      // Make the body's shape a circle
//      CircleShape cs = new CircleShape();
//      cs.m_radius = box2d.scalarPixelsToWorld(r);

//      FixtureDef fd = new FixtureDef();
//      fd.shape = cs;
//      // Parameters that affect physics
//      fd.density = 1;
//      fd.friction = 0.01;
//      fd.restitution = 0.3;

//      // Attach fixture to body
//      body.createFixture(fd);

//      MassData massData = new MassData();
//      massData.mass = 1000;
//      //body.setAngularVelocity(random(-10, 10));
//      body.setLinearVelocity(new Vec2(l, v));
//      body.setMassData(massData);
//    }
//  }

//  class smallParticle {

//    // We need to keep track of a Body and a radius
//    Body body2;
//    float r;
//    color col;

//    smallParticle(float x, float y, float r_, color col_) {
//      r = r_;
//      col = col_;
//      // This function puts the particle in the Box2d world
//      makeBody(x, y, r);
//    }

//    // This function removes the particle from the box2d world
//    void killBody() {
//      box2d.destroyBody(body2);
//    }

//    // Is the particle ready for deletion?
//    boolean done() {
//      // Let's find the screen position of the particle
//      Vec2 pos = box2d.getBodyPixelCoord(body2);
//      // Is it off the bottom of the screen?

//      if (pos.y > 350) {
//        killBody();
//        return true;
//      }
//      return false;
//    }

//    //
//    void display() {
//      // We look at each body and get its screen position
//      Vec2 pos = box2d.getBodyPixelCoord(body2);
//      // Get its angle of rotation
//      float a = body2.getAngle();
//      pushMatrix();
//      translate(pos.x, pos.y);
//      rotate(-a);
//      fill(col);
//      stroke(0);
//      strokeWeight(1);
//      ellipse(0, 0, r*2, r*2);
//      // Let's add a line so we can see the rotation
//      //line(0,0,r,0);
//      popMatrix();
//    }

//    // Here's our function that adds the particle to the Box2D world
//    void makeBody(float x, float y, float r) {
//      // Define a body
//      BodyDef bd2 = new BodyDef();
//      // Set its position
//      bd2.position = box2d.coordPixelsToWorld(x, y);
//      bd2.type = BodyType.DYNAMIC;
//      body2 = box2d.world.createBody(bd2);

//      // Make the body's shape a circle
//      CircleShape cs = new CircleShape();
//      cs.m_radius = box2d.scalarPixelsToWorld(r);

//      FixtureDef fd = new FixtureDef();
//      fd.shape = cs;
//      // Parameters that affect physics
//      fd.density = 1;
//      fd.friction = 0.01;
//      fd.restitution = 0.3;

//      // Attach fixture to body
//      body2.createFixture(fd);

//      // Give it a random initial velocity (and angular velocity)
//      body2.setLinearVelocity(new Vec2(random(-10f, 10f), random(5f, 10f)));
//      body2.setAngularVelocity(random(-10, 10));
//    }
//  }

//  class smallSelfParticle {

//    // We need to keep track of a Body and a radius
//    Body body3;
//    float r;
//    color col;

//    smallSelfParticle(float x, float y, float r_, color col_) {
//      r = r_;
//      col = col_;
//      // This function puts the particle in the Box2d world
//      makeBody(x, y, r);
//    }

//    // This function removes the particle from the box2d world
//    void killBody() {
//      box2d.destroyBody(body3);
//    }

//    // Is the particle ready for deletion?
//    boolean done() {
//      // Let's find the screen position of the particle
//      Vec2 pos = box2d.getBodyPixelCoord(body3);
//      // Is it off the bottom of the screen?

//      if (pos.y > 250) {
//        killBody();
//        return true;
//      }

//      return false;
//    }

//    //
//    void display() {
//      // We look at each body and get its screen position
//      Vec2 pos = box2d.getBodyPixelCoord(body3);
//      // Get its angle of rotation
//      float a = body3.getAngle();
//      pushMatrix();
//      translate(pos.x, pos.y);
//      rotate(-a);
//      fill(col);
//      stroke(0);
//      strokeWeight(1);
//      ellipse(0, 0, r*2, r*2);
//      // Let's add a line so we can see the rotation
//      //line(0,0,r,0);
//      popMatrix();
//    }

//    // Here's our function that adds the particle to the Box2D world
//    void makeBody(float x, float y, float r) {
//      // Define a body
//      BodyDef bd3 = new BodyDef();
//      // Set its position
//      bd3.position = box2d.coordPixelsToWorld(x, y);
//      bd3.type = BodyType.DYNAMIC;
//      body3 = box2d.world.createBody(bd3);

//      // Make the body's shape a circle
//      CircleShape cs = new CircleShape();
//      cs.m_radius = box2d.scalarPixelsToWorld(r);

//      FixtureDef fd = new FixtureDef();
//      fd.shape = cs;
//      // Parameters that affect physics
//      fd.density = 1;
//      fd.friction = 0.01;
//      fd.restitution = 0.3;

//      // Attach fixture to body
//      body3.createFixture(fd);

//      // Give it a random initial velocity (and angular velocity)
//      body3.setLinearVelocity(new Vec2(random(-10f, 10f), random(5f, 10f)));
//      body3.setAngularVelocity(random(-10, 10));
//    }
//  }

//  public void settings() {

//    fullScreen(2);
//    //size(1000,800);
//    monitorWidth = displayWidth;
//    monitorHeight = displayHeight;

//    particles = new ArrayList<Particle>();
//    boundaries = new ArrayList<Boundary>();
//    smallParticles = new ArrayList<smallParticle>();
//    smallSelfParticles = new ArrayList<smallSelfParticle>();

//    //this is the boundaries I made in the box2D world

//    boundaries.add(new Boundary(displayWidth-20, displayHeight-100, 20, 200, 9.8));
//    boundaries.add(new Boundary(displayWidth-140, displayHeight-50, 20, 200, 9.8));
//    //boundaries.add(new Boundary(750, 460, 20, 200, 0));
//    //boundaries.add(new Boundary(450, 460, 20, 200, 0));
//    //boundaries.add(new Boundary(600, 550, 300, 20, 0));
//    //boundaries.add(new Boundary(750, 0, 20, 200, 0));
//    //boundaries.add(new Boundary(950, 0, 20, 200, 0));
//  }

//  public void draw() {
//    box2d.step(); //step through time in box2d
//    background(203, 235, 255);

//    noStroke();
//    fill(255);

//    //cloud one
//    ellipse (1530-600, 395, 50, 40);
//    ellipse (1510-600, 405, 50, 40);
//    ellipse (1460-600, 395, 50, 40);
//    ellipse (1480-600, 405, 50, 40);
//    ellipse (1470-600, 385, 50, 40);
//    ellipse (1510-600, 385, 50, 40);
//    ellipse (1490-600, 380, 50, 40);

//    //cloud two
//    ellipse (1530-1000, 395-220, 50, 40);
//    ellipse (1510-1000, 405-220, 50, 40);
//    ellipse (1460-1000, 395-220, 50, 40);
//    ellipse (1480-1000, 405-220, 50, 40);
//    ellipse (1470-1000, 385-220, 50, 40);
//    ellipse (1510-1000, 385-220, 50, 40);
//    ellipse (1490-1000, 380-220, 50, 40);

//    //cloud three
//    ellipse (1530-1400, 395+100, 50, 40);
//    ellipse (1510-1400, 405+100, 50, 40);
//    ellipse (1460-1400, 395+100, 50, 40);
//    ellipse (1480-1400, 405+100, 50, 40);
//    ellipse (1470-1400, 385+100, 50, 40);
//    ellipse (1510-1400, 385+100, 50, 40);
//    ellipse (1490-1400, 380+100, 50, 40);

//    //message board
//    //stroke(0);
//    //strokeWeight(5);

//    //line(750, 400, 800, 350);
//    //line(750, 400, 700, 350);
//    //rect(600+monitorAdjustment, 100, 300, 200);
//    //line(650, 600, 650, 650);
//    //line(850, 600, 850, 650);

//    textSize(75);
//    fill(0);
//    text(instruction, 40, 150);



//    xcoord += xSpeed;

//    if ((xcoord > 500) || (xcoord < 200)) {
//      xSpeed *=-1;
//    }

//    //UFO
//    if (killUFO == false) {

//      stroke(0);
//      strokeWeight(1);
//      fill(255);
//      ellipse(xcoord, ycoord-25, 80, 100);

//      noStroke();
//      fill(0);
//      ellipse(xcoord, ycoord, 150, 60);

//      noStroke();
//      fill(255);
//      ellipse(xcoord, ycoord-23, 80, 15);
//    }

//    if (bombSound == true) {

//      file.play();
//      bombSound = false;
//    }


//    //the text for score
//    textSize(75);
//    fill(0);
//    text("Score: "+str(scoreCount), 40, 60);



//    if (startSprinkle == false) {

//      //this is the list of particles add into the world
//      //particles.add(new Particle(570, 200, 40, 0, 0));
//      //particles.add(new Particle(500, 250, 40, 0, 0));
//      //particles.add(new Particle(600, 100, 40, 0, 0));
//      //particles.add(new Particle(700, 300, 40, 0, 0));
//      //particles.add(new Particle(600, 350, 40, 0, 0));

//      startSprinkle = true;
//    }

//    if (startCrash == true) {
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));
//      smallParticles.add(new smallParticle(xcoord, ycoord, random(2, 20), color(0)));

//      startCrash = false;
//    }

//    if (startSelfCrash == true) {

//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));
//      smallSelfParticles.add(new smallSelfParticle(bulletx, bullety, random(2, 10), color(204, 102, 0)));

//      startSelfCrash = false;
//    }

//    // Display all the boundaries
//    for (Boundary wall : boundaries) {
//      wall.display();
//    }

//    //we add a new ball when nextBall flag is true
//    if (nextBall == true) {
//      particles.add(new Particle(width-50, height, 40, -30, 65)); //this is the ball that drops from the tube
//      nextBall = false;
//    }


//    //display ball
//    if (hitTarget == true) {

//      if (addParticle == false) {

//        //particles.add(new Particle(random(330, 360), 720, 40, random(10, 11), random(120, 140))); //this is where we currently define the ball speed and velocity

//        if (avgXVelocity > 0) {
//          particles.add(new Particle(hitX, 720, 40, random(10, 11), random(65, 70))); //this is where we currently define the ball speed and velocity //random(120, 140)
//        } else {
//          particles.add(new Particle(hitX, 720, 40, -random(10, 11), random(65, 70))); //this is where we currently define the ball speed and velocity //random(120, 140)
//        }

//        addParticle = true;
//      }
//    }

//    //scoreCount = 0;

//    //display debris
//    for (int i = smallParticles.size()-1; i >= 0; i--) {
//      smallParticle p = smallParticles.get(i);
//      p.display();
//      if (p.done()) {
//        smallParticles.remove(i);
//      }
//    }

//    //display bullet debirs
//    for (int i = smallSelfParticles.size()-1; i >= 0; i--) {
//      smallSelfParticle p = smallSelfParticles.get(i);
//      p.display();
//      if (p.done()) {
//        smallSelfParticles.remove(i);
//      }
//    }

//    for (int i = particles.size()-1; i >= 0; i--) {
//      Particle p = particles.get(i);
//      p.display();
//      // Particles that leave the screen, we delete them
//      // (note they have to be deleted from both the box2d world and our list
//      if (p.done()) {
//        particles.remove(i);
//        hitTarget = false;
//        addParticle = false;
//      }
//      //if (p.goal()) {
//      //  scoreCount += 1;
//      //}
//    }
//  };
//}


//float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
//  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
//  return d;
//}

//boolean detectBall(boolean recordHistory) {

//  global_avgX = 0;
//  global_avgY = 0;
//  global_avgDepth = 0;
//  global_count = 0;

//  //begin loop to walk through every pixel
//  for (int x = 0; x < kinect.getVideoImage().width; x++ ) {
//    for (int y = 0; y < kinect.getVideoImage().height; y++ ) {

//      int loc = x + y * kinect.getVideoImage().width; //find the location of each pixel

//      float pixelDepth = kinect.getRawDepth()[loc];
//      color currentColor = kinect.getVideoImage().pixels[loc];
//      float r1 = red(currentColor);
//      float g1 = green(currentColor);
//      float b1 = blue(currentColor);
//      float r2 = red(trackColor);
//      float g2 = green(trackColor);
//      float b2 = blue(trackColor);

//      float d = distSq(r1, g1, b1, r2, g2, b2);

//      //compared the pixel color to the ball color
//      if (d < threshold*threshold) {
//        stroke(255);
//        strokeWeight(1);
//        point(x, y);
//        global_avgX += x;
//        global_avgY += y;
//        global_avgDepth += pixelDepth;
//        global_count++;
//      }
//    }
//  }

//  // we find the ball if count > 50 (this threshold can be changed)
//  if (global_count > 50) {
//    global_avgX = global_avgX / global_count;
//    global_avgY = global_avgY / global_count;
//    global_avgDepth = global_avgDepth / global_count;
//    println("depth within detect ball: ", global_avgDepth);
//    //we are appending the historical positions here
//    if (recordHistory) {
//      global_xHist = append(global_xHist, global_avgX);
//      global_yHist = append(global_yHist, global_avgY);
//      global_dHist = append(global_dHist, global_avgDepth);
//    }

//    return true;
//  } else {
//    return false;
//  }
//}

//boolean setTangentPoint(float theta1, float theta2, float theta3, float d2, String mode) {

//  //for the case of finding xprime and yprime, theta1 and theta2 will not be used, theta3 is theta4, d2 is diameter

//  float x = 0.0;
//  float y = 0.0;

//  float tempx = 0.0;
//  float tempy = 0.0;

//  if (mode == "firstTangentPoint") { //angleaugmentation
//    theta3 = theta2+theta1;
//  } else if (mode == "secondTangentPoint") {
//    theta3 = theta2-theta1;
//  }

//  if (mode == "findOppositePoint") {
//    tempx = global_finalx;
//    tempy = global_finaly;
//  } else {
//    tempx = global_toio_center_x;
//    tempy = global_toio_center_y;
//  }


//  if ((global_ball_x - tempx)> 0 & (global_ball_y - tempy) < 0) { //we already convert quadrant coordinates to toio mat coordinates

//    println("ball in quadrant 1");
//    x = tempx+d2*cos(theta3);
//    y = tempy-d2*sin (theta3);
//  } else if ((global_ball_x - tempx) < 0 & (global_ball_y - tempy) < 0) {

//    println("ball in quadrant 2");
//    x = tempx-d2*cos(theta3);
//    y = tempy-d2*sin (theta3);
//  } else if ((global_ball_x - tempx) < 0 & (global_ball_y - tempy) > 0) {

//    println("ball in quadrant 3");
//    x = tempx-d2*cos(theta3);
//    y = tempy+d2*sin (theta3);
//  } else if ((global_ball_x - tempx) > 0 & (global_ball_y - tempy) > 0) {

//    println("ball in quadrant 4");

//    x = tempx+d2*cos(theta3);
//    y = tempy+d2*sin (theta3);
//  } else {

//    //theta3 == NAN
//    //if theta2-theta1, then we say theta3 = -theta1
//    //if theta2+theta1, then we say theta3 = theta1

//    if (mode == "firstTangentPoint") {
//      theta3 = theta1;
//    } else if (mode == "secondTangentPoint") {
//      theta3 = -theta1;
//    } else {
//      //case for theta4 == NAN, we make it to 0
//      theta3 = 0;
//    }

//    if ((global_ball_x - tempx) == 0 & (global_ball_y - tempy) > 0) {

//      println("ball in between 3 and 4 quadrants");
//      x = tempx+d2*sin(theta3);
//      y = tempy+d2*cos(theta3);
//    } else if ((global_ball_x - tempx) > 0 & (global_ball_y - tempy) == 0) {

//      println("ball in between 1 and 4 quadrants");
//      x = tempx+d2*cos(theta3);
//      y = tempy-d2*sin(theta3);
//    } else if ((global_ball_x - tempx) == 0 & (global_ball_y - tempy) < 0) {

//      println("ball in between 1 and 2 quadrants");
//      x = tempx+d2*sin(theta3);
//      y = tempy-d2*cos(theta3);
//    } else if ((global_ball_x - tempx) < 0 & (global_ball_y - tempy) == 0) {

//      println("ball in between 2 and 3 quadrants");
//      x = tempx-d2*cos(theta3);
//      y = tempy-d2*sin(theta3);
//    } else {
//      println("Something is wrong here!!");
//    }
//  }

//  if (mode == "firstTangentPoint") {
//    global_x = x;
//    global_y = y;
//  } else if (mode == "secondTangentPoint") {
//    global_x2 = x;
//    global_y2 = y;
//  } else {
//    global_xprime = x;
//    global_yprime = y;
//  }
//  return true;
//}

//boolean findLocation() {

//  float c0_dist = 0.0;
//  float c1_dist = 0.0;

//  float d1 = 0.0;
//  float d2 = 0.0;
//  PVector v1, v2, v3, v4;
//  float theta1 = 0.0;
//  float theta2 = 0.0;
//  float theta3 = 0.0;
//  float theta4 = 0.0;

//  //1. Use closer toio to find two tangent points
//  //c0_dist = sqrt ( pow ( global_scaledX - c0x, 2 ) + pow (global_scaledY - c0y, 2 ));
//  //c1_dist = sqrt ( pow ( global_scaledX - c1x, 2 ) + pow (global_scaledY - c1y, 2 ));
//  c0_dist = cubes[0].distance(global_scaledX, global_scaledY);
//  c1_dist = cubes[1].distance(global_scaledX, global_scaledY);

//  println("c0_dist: ", c0_dist);
//  println("c1_dist: ", c1_dist);

//  //set toio center x and y using closer toio x and y
//  if (c0_dist < c1_dist) {
//    println("0 is closer toio");
//    global_closer_toio_id = 0; //closer toio
//    global_toio_center_x = cubes[0].x;
//    global_toio_center_y = cubes[0].y;
//    //global_toio_center_x = c0x; //comment this out later
//    //global_toio_center_y = c0y; //comment this out later
//  } else {

//    println("1 is closer toio");
//    global_closer_toio_id = 1; //further toio
//    global_toio_center_x = cubes[1].x;
//    global_toio_center_y = cubes[1].y;
//    //global_toio_center_x = c1x; //comment this out later
//    //global_toio_center_y = c1y; //comment this out later
//  }

//  //check if the dropper is outside the radius of the circle
//  //if it is inside, we will need to move it out to the two corners
//  if (sqrt ( pow ( global_scaledX - global_toio_center_x, 2 ) + pow ( global_scaledY - global_toio_center_y, 2 )) > global_radius) {

//    //set the ball's location by scaledX and scaledY
//    global_ball_x = global_scaledX;
//    global_ball_y = global_scaledY;

//    //find distance from ball to closer toio
//    d1 = sqrt ( pow ( global_ball_x - global_toio_center_x, 2 ) + pow ( global_ball_y - global_toio_center_y, 2 ));

//    //find distance from closer toio to lower tangent point
//    d2 = sqrt ( pow ( d1, 2 ) - pow ( global_radius, 2 ));

//    //find vectors for angle calculation
//    v1 = new PVector(global_ball_x - global_toio_center_x, global_toio_center_y - global_toio_center_y); //closer toio horizontal extension
//    v2 = new PVector(global_ball_x - global_toio_center_x, global_ball_y - global_toio_center_y); //closer toio to ball

//    //determine angles
//    theta1 = acos(d2/d1);
//    theta2 = acos(v1.dot(v2)/(v1.mag()*v2.mag()));

//    //println("theta1: ", theta1);
//    //println("theta2: ", theta2);
//    //println("theta3: ", theta3);
//    setTangentPoint(theta1, theta2, theta3, d2, "firstTangentPoint");
//    setTangentPoint(theta1, theta2, theta3, d2, "secondTangentPoint");

//    //2. use the further toio to find the tangent point that has longer distance
//    if (global_closer_toio_id == 0) {
//      //toio id 1 is the further toio

//      //if (sqrt ( pow ( global_x - c1x, 2 ) + pow (global_y - c1y, 2 )) > sqrt ( pow ( global_x2 - c1x, 2 ) + pow (global_y2 - c1y, 2 ))) {
//      if (cubes[1].distance(global_x, global_y) > cubes[1].distance(global_x2, global_y2)) {
//        //x and y point is further
//        global_furtherTangentPoint = "xy";
//      } else {
//        //x2 and y2 is further
//        global_furtherTangentPoint = "x2y2";
//      }
//    } else {
//      //toio id 0 is the further toio

//      //if (sqrt ( pow ( global_x - c0x, 2 ) + pow (global_y - c0y, 2 )) > sqrt ( pow ( global_x2 - c0x, 2 ) + pow (global_y2 - c0y, 2 ))) {
//      if (cubes[0].distance(global_x, global_y) > cubes[0].distance(global_x2, global_y2)) {
//        //x and y point is further
//        global_furtherTangentPoint = "xy";
//      } else {
//        //x2 and y2 is further
//        global_furtherTangentPoint = "x2y2";
//      }
//    }

//    //3. use the furtherTangentPoint to find the opposite point
//    if (global_furtherTangentPoint.equals("xy")) {
//      global_finalx = global_x;
//      global_finaly = global_y;
//    } else {
//      global_finalx = global_x2;
//      global_finaly = global_y2;
//    }

//    v3 = new PVector(global_ball_x-global_finalx, global_ball_y-global_finaly); //final x and final y to ball
//    v4 = new PVector(global_ball_x-global_finalx, global_finaly-global_finaly); //final x and final y horizontal extension

//    theta4 = acos(v3.dot(v4)/(v3.mag()*v4.mag()));

//    setTangentPoint(0, 0, theta4, 2*global_radius, "findOppositePoint");

//    println("global_ball_x: ", global_ball_x);
//    println("global_ball_y: ", global_ball_y);
//    println("global_x: ", global_x);
//    println("global_y: ", global_y);
//    println("global_x2: ", global_x2);
//    println("global_y2: ", global_y2);
//    println("global_furtherTangentPoint: ", global_furtherTangentPoint);
//    println("global_finalx: ", global_finalx);
//    println("global_finaly: ", global_finaly);
//    println("global_xprime: ", global_xprime);
//    println("global_yprime: ", global_yprime);

//    flag_findTangentPoints = true;
//  } else {
//    //case when the ball is in the radius of the circle
//    flag_outsideRadius = false; // outsideRadius is a global variable
//    println("toio is within radius, which is bad");
//  }

//  return true;
//}


//boolean findbackoutLocation(int toio_number) {
//  float x = 0.0;
//  float y = 0.0;
//  PVector v5, v6;
//  float theta5 = 0.0;

//  float tempx = 0.0;
//  float tempy = 0.0;

//  if (toio_number == 0) {
//    //change this to cube[0].x for example
//    tempx = cubes[0].x;
//    tempy = cubes[0].y;
//  } else {
//    tempx = cubes[1].x;
//    tempy = cubes[1].y;
//  }

//  float tempDist = sqrt ( pow ( global_scaledX - tempx, 2 ) + pow (global_scaledY - tempy, 2 ));
//  float ratio = global_bitMoreThanRadius/tempDist;

//  v5 = new PVector(global_scaledX-tempx, global_scaledY-tempy); //final x and final y to ball
//  v6 = new PVector(global_scaledX-tempx, tempy-tempy); //final x and final y horizontal extension

//  theta5 = acos(v5.dot(v6)/(v5.mag()*v6.mag()));


//  if ((global_scaledX - tempx)> 0 & (global_scaledY - tempy) < 0) { //we already convert quadrant coordinates to toio mat coordinates

//    println("ball in quadrant 1");
//    x = global_scaledX-ratio*tempDist*cos(theta5);
//    y = global_scaledY+ratio*tempDist*sin(theta5);
//  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) < 0) {

//    println("ball in quadrant 2");
//    x = global_scaledX+ratio*tempDist*cos(theta5);
//    y = global_scaledY+ratio*tempDist*sin(theta5);
//  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) > 0) {

//    println("ball in quadrant 3");
//    x = global_scaledX+ratio*tempDist*cos(theta5);
//    y = global_scaledY-ratio*tempDist*sin(theta5);
//  } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) > 0) {

//    println("ball in quadrant 4");

//    x = global_scaledX-ratio*tempDist*cos(theta5);
//    y = global_scaledY-ratio*tempDist*sin(theta5);
//  } else {

//    theta5 = 0;

//    if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) > 0) {

//      println("ball in between 3 and 4 quadrants");
//      x = global_scaledX-ratio*tempDist*sin(theta5);
//      y = global_scaledY-ratio*tempDist*cos(theta5);
//    } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) == 0) {

//      println("ball in between 1 and 4 quadrants");
//      x = global_scaledX-ratio*tempDist*cos(theta5);
//      y = global_scaledY+ratio*tempDist*sin(theta5);
//    } else if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) < 0) {

//      println("ball in between 1 and 2 quadrants");
//      x = global_scaledX-ratio*tempDist*sin(theta5);
//      y = global_scaledY+ratio*tempDist*cos(theta5);
//    } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) == 0) {

//      println("ball in between 2 and 3 quadrants");
//      x = global_scaledX+ratio*tempDist*cos(theta5);
//      y = global_scaledY+ratio*tempDist*sin(theta5);
//    } else {

//      println("Something is wrong here!!");
//    }
//  }

//  if (toio_number == 0) {
//    global_backoutx0 = x;
//    global_backouty0 = y;
//  } else {
//    global_backoutx1 = x;
//    global_backouty1 = y;
//  }
//  println("x: ", x);
//  println("y: ", y);
//  println("global_scaledX: ", global_scaledX);
//  println("global_scaledY: ", global_scaledY);
//  println("global_backoutx0: ", global_backoutx0);
//  println("global_backouty0: ", global_backouty0);
//  println("global_backoutx1: ", global_backoutx1);
//  println("global_backouty1: ", global_backouty1);
//  return true;
//}

//void draw() {

//  background(255);
//  stroke(0);
//  long now = System.currentTimeMillis();

//  //draw the "mat"
//  fill(255);
//  rect(45, 45, 415, 410);

//  image(kinect.getVideoImage(), 0, 0);
//  //image(kinect.getDepthImage(), 640, 0);

//  if (clickCount < 4) {

//    if (clickCount == 1 || clickCount == 2) {
      
//      //draw dot on the corners
//      fill(color(255, 0, 0));
//      strokeWeight(1.0);
//      stroke(255, 255, 255);
//      ellipse(mouseXLocation, mouseYLocation, 10, 10);
//    }

//    if (clickCount == 3) {

//      //We use the information here to check the depth information of the ball
//      detectBall(false);
//    }

//    //robots travel to the starting position
//    aimCubeSpeed(0, 100, 100);
//    aimCubeSpeed(1, 600, 250);
    
//  } else {

//    //Phase 1. Check if the camera sees a ball
//    if (flag_seeBall == false && flag_ballSticks == false) {
//      println("System starts to detect the ball");

//      //call detectBall function

//      if (detectBall(false)) {
//        flag_seeBall = true;
//      } else {
//        flag_seeBall = false;
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == false) {

//      println("Seen ball, check if it sticks");

//      if (startTime == false) {
//        time = millis();
//        startTime = true;
//      } else {

//        if (startTime2 == false) {
//          time2 = millis();
//          startTime2 = true;
//        } else {
//          println("I am here");
//          if (millis() > time2 + 50) { //every 50 millisecond record a point
//            startTime2 = false;

//            //detect ball while also record the ball's travel history
//            detectBall(true);
//          }
//        }

//        if (millis() > time + 500) { //wait for the ball to stick properly maybe 300 (if we always sticks, then we need to use 300 to show a smooth transition)
//          startTime = false;


//          //detect the location of the ball
//          if (detectBall(false)) {
//            global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//            global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

//            //use depth information to check if a ball sticks or not
//            //2047 means that there is no depth information

//            println("global_avgDepth: ", global_avgDepth);
//            if (global_avgDepth > 710 || global_avgDepth == 2047) { //we may need to adjust this number depending on the environment


//              flag_ballSticks = false;
//              flag_seeBall = false;
//              instruction = "Nice try! Throw carefully!" ;
//            }

//            // Draw a circle at the tracked pixel
//            fill(255);
//            strokeWeight(4.0);
//            stroke(0);
//            ellipse(global_avgX, global_avgY, 20, 20);

//            hitX = map(global_scaledX, 32, 614+32, 0, displayWidth); //store the position of hitX (since we run many times for image detection, we may lose the hitX information)

//            println("hitX: ", hitX);
//            println("global_scaledX: ", global_scaledX);
//            println("width: ", width);


//            //find ball velocity and angle
//            //depthDiff  = global_dHist[global_dHist.length-1]-global_dHist[int(global_dHist.length/2)]; // this value should be positive
//            //xDiff  = global_xHist[global_xHist.length-1]-global_xHist[int(global_xHist.length/2)];

//            //throwDegree = degrees(atan2(depthDiff, xDiff));
//            throwDegree = degrees(atan2(3, 4));

//            //caculate velocity, we can just find the velocty of the five points after mid point

//            avgZVelocity = ((global_dHist[int(global_dHist.length/2)] - global_dHist[0]))/3;

//            avgXVelocity = ((global_xHist[int(global_xHist.length/2)] - global_xHist[0]))/3; //here we adjust the x velocity

//            flag_ballSticks = true;

//            //upper left corber coordinate is (32, 32) and lower right corver is (646, 465)
//            if (global_scaledX > 596 || global_scaledY > 415 || global_scaledY < 82 || global_scaledX < 82) {
//              flag_ballSticks = false;
//              flag_seeBall = false;
//              instruction = "Nice try! Throw carefully!" ;
//            }
//          } else {
//            flag_ballSticks = false;
//            flag_seeBall = false;
//            instruction = "Nice try! Throw carefully!" ;
//          }
//        }
//      }

//      println("flag_ballSticks :", flag_ballSticks);
//    } else if (flag_seeBall == true && flag_ballSticks == true && travelOut == false && facePushLocation == false && travelToPush == false && turning == false && flag_pushDone == false) {

//      println("toio travelling out and prepare for pushing");
//      //this is the block of code where we can have some travel code to move toios outward
//      hitTarget = true;

//      if (startTime == false) {
//        time = millis();
//        startTime = true;
//      } else {

//        if (millis() > time + 200) { //wait for the ball to stick properly maybe 200
//          startTime = false;
//          travelOut = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && travelOut == true && facePushLocation == false && travelToPush == false && turning == false && flag_pushDone == false) {

//      println("toio rotates to the correct angle");
//      if (flag_recordPushingToioPushLocationAngle == false) {

//        //assuming that the ball always sticks in between the spaces between the toio robots
//        if (global_scaledX < pushx) {
//          //cube 0 will push
//          pushToio = 0;

//          turnDegree0 = degrees(atan2(global_scaledY-cubes[0].y, global_scaledX-cubes[0].x));
//          if (turnDegree0 < 0) {
//            turnDegree0+=360;
//          }
//        } else {
//          //cube 1 will push
//          pushToio = 1;
//          turnDegree1 = degrees(atan2(global_scaledY-cubes[1].y, global_scaledX-cubes[1].x));

//          if (turnDegree1 < 0) {
//            turnDegree1+=360;
//          }
//        }

//        flag_recordPushingToioPushLocationAngle = true;
//      } else {

//        if (pushToio == 0) {
//          if (rotateCube(0, turnDegree0-180)) {
//            facePushLocation = true;
//          }
//        } else {
//          if (rotateCube(1, turnDegree1-180)) {
//            facePushLocation = true;
//          }
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == false && turning == false && flag_pushDone == false) {

//      println("one toio travels to ball, preparing to push");
//      //depending on where the toio wants to go (push x and push y)

//      if (pushToio == 0) {
//        //cube 0 will push

//        aimCubeSpeed(0, global_scaledX, global_scaledY); //may need to control distance

//        if (abs(cubes[0].x - global_scaledX) < closeDistance2 && abs(cubes[0].y - global_scaledY) < closeDistance2) {

//          travelToPush = true;
//        }
//      } else {
//        //cube 1 will push

//        aimCubeSpeed(1, global_scaledX, global_scaledY);

//        if (abs(cubes[1].x - global_scaledX) < closeDistance2 && abs(cubes[1].y - global_scaledY) < closeDistance2) {

//          travelToPush = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == true && turning == false && flag_pushDone == false) {
//      println("toio rotates with the ball to face push location");

//      if (pushToio == 0) {
//        //0 is the pushing toio

//        if (rotateCubeMax(0, turnDegree1-180)) {
//          turning = true;
//        }
//      } else {
//        //1 is the pushing toio
//        if (rotateCubeMax(1, turnDegree1-180)) {
//          turning = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == true && turning == true && flag_pushDone == false) {
//      println("toio pushes ball to the location");

//      if (pushToio == 0) {
//        //0 is the pushing toio
//        aimCubeSpeed(0, pushx, pushy);
//        if (abs(cubes[0].x - pushx) < 25 && abs(cubes[0].y - pushy) < 25) {
//          flag_pushDone = true;
//        }
//      } else {
//        //1 is the pushing toio
//        aimCubeSpeed(1, pushx, pushy);
//        if (abs(cubes[1].x - pushx) < 25 && abs(cubes[1].y - pushy) < 25) {
//          flag_pushDone = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && flag_pushDone == true && flag_outsideRadius == true && flag_findTangentPoints == false && global_scaledX != global_ball_x && global_scaledY != global_ball_y) {



//      println("xcoord: ", xcoord);

//      println("find tangent points");

//      //flag_findTangentPoints means checking if we can find tangent points

//      if (findPushedBallLocation == false) {

//        //you must find ball here
//        if (detectBall(false)) {
//          global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);
//          global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);

//          // Draw a circle at the tracked pixel
//          fill(255);
//          strokeWeight(4.0);
//          stroke(0);
//          ellipse(global_avgX, global_avgY, 20, 20);
//        } else {
//          //this would happen if we let the ball reached similar height to the ceiling but didn't stick
//          println("something is wrong here, you should see the ball");



//          //In this case, we need to kill the particle and reset the flags (by jumping to the end) and make the robot go back.



//          exit();
//        }

//        findPushedBallLocation = true;
//      }

//      //find the tangent points
//      findLocation();
//    } else if (flag_seeBall == true && flag_ballSticks == true && flag_outsideRadius == false) {

//      println("handle case when the ball is within radius");
//      //new below
//      if (prepareBackout == false) {
//        if (detectBall(false)) {
//          global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//          global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382
//          findbackoutLocation(0);
//          findbackoutLocation(1);

//          prepareBackout = true;
//        }
//      } else {

//        aimCubeSpeed(0, global_backoutx0, global_backouty0);
//        aimCubeSpeed(1, global_backoutx1, global_backouty1);

//        if (abs(cubes[0].x - global_backoutx0) < 15 && abs(cubes[0].y - global_backouty0) < 15 && abs(cubes[1].x - global_backoutx1) < 15 && abs(cubes[1].y - global_backouty1) < 15 ) {
//          println("hahahaha");
//          flag_outsideRadius = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true &&
//      flag_findTangentPoints == true && flag_outsideRadius == true && flag_converge == false && flag_knockSucceed == false) {
//      println("toios are travelling");
//      //maybe I would want the toios to move back to the tangent points after they converge

//      if (global_closer_toio_id == 0) {
//        aimCubeSpeed(0, global_finalx, global_finaly);
//        aimCubeSpeed(1, global_xprime, global_yprime);
//        if (abs(cubes[0].x - global_finalx) < 15 && abs(cubes[0].y - global_finaly) < 15 && abs(cubes[1].x - global_xprime) < 15 && abs(cubes[1].y - global_yprime) < 15 ) {
//          //flag_findTangentPoints = false;
//          flag_converge = true;
//          nextBall = true;
//        }
//      } else {
//        aimCubeSpeed(1, global_finalx, global_finaly);
//        aimCubeSpeed(0, global_xprime, global_yprime);
//        if (abs(cubes[1].x - global_finalx) < 15 && abs(cubes[1].y - global_finaly) < 15 && abs(cubes[0].x - global_xprime) < 15 && abs(cubes[0].y - global_yprime) < 15) {
//          //flag_findTangentPoints = false;
//          flag_converge = true;
//          nextBall = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && flag_outsideRadius == true && flag_findTangentPoints == true &&
//      flag_converge == true && turnFlag == false && flag_knockSucceed == false) {

//      println("turn angle!");


//      //spin to the right direction
//      //say let 0 be front and let 1 be back

//      if (recordDegree == false) {
//        turnDegree0 = degrees(atan2(global_scaledY-cubes[0].y, global_scaledX-cubes[0].x));
//        if (turnDegree0 < 0) {
//          turnDegree0+=360;
//        }

//        turnDegree1 = degrees(atan2(global_scaledY-cubes[1].y, global_scaledX-cubes[1].x));

//        if (turnDegree1 < 0) {
//          turnDegree1+=360;
//        }
//        recordDegree = true;
//      } else {


//        if (abs(cubes[0].deg - turnDegree0) < 10) {
//          turnFlag1 = true;
//        } else {
//          rotateCube(0, turnDegree0);
//        }


//        if (abs(cubes[1].deg - (turnDegree1-180)) < 10 || abs(cubes[1].deg - (turnDegree1-180+360)) < 10) {

//          turnFlag2 = true;
//        } else {
//          rotateCube(1, turnDegree1-180); //cube 1 use chopstick side
//        }

//        if (turnFlag1 && turnFlag2) {

//          turnFlag = true;
//        }
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && flag_outsideRadius == true && flag_findTangentPoints == true
//      && flag_converge == true && turnFlag == true && flag_knockSucceed == false) {
//      println("converging");
//      if (startTime == false) {
//        time = millis();
//        startTime = true;
//      } else {

//        if (millis() > time + 2000) { //wait for virtual ball to drop

//          aimCubeSpeed(0, global_scaledX, global_scaledY);
//          aimCubeSpeed(1, global_scaledX, global_scaledY);
//        }
//      }



//      if (abs(cubes[0].x - global_scaledX) < closeDistance && abs(cubes[1].x - global_scaledX) < closeDistance &&
//        abs(cubes[0].y - global_scaledY) < closeDistance &&  abs(cubes[1].y - global_scaledY) < closeDistance) {
//        flag_knockSucceed = true;
//        startTime = false;
//      }
//    } else if (flag_seeBall == true && flag_ballSticks == true && flag_outsideRadius == true &&  flag_findTangentPoints == true
//      && flag_converge == true && turnFlag == true && flag_knockSucceed == true) {
//      //  println("knocksucceed");
//      if (startTime == false) {
//        time = millis();
//        startTime = true;
//      } else {

//        if (millis() > time + 1000) { //wait for the ball to stick properly maybe 2 seconds

//          aimCubeSpeed(0, 100, 100);
//          aimCubeSpeed(1, 600, 250);

//          if (abs(cubes[0].x - 100) < 15 && abs(cubes[1].x - 600) < 15 &&
//            abs(cubes[0].y - 100) < 15 &&  abs(cubes[1].y - 250) < 15) {
//            flag_seeBall = false;
//            flag_ballSticks = false;
//            flag_findTangentPoints = false;
//            flag_converge = false;
//            turnFlag = false;
//            turnFlag1 = false;
//            turnFlag2 = false;
//            recordDegree = false;
//            flag_recordPushingToioPushLocationAngle = false;
//            flag_knockSucceed = false;
//            prepareBackout = false;
//            findDistBall = false;
//            findDistBall2 = false;
//            findDist = false;
//            separate = false;
//            xHist = new float[] {};
//            yHist = new float[] {};
//            dHist = new float[] {};

//            hitTarget = false;
//            travelOut = false;
//            travelToPush = false;
//            turning = false;
//            flag_pushDone = false;
//            facePushLocation = false;
//            flag_outsideRadius = true;
//            turnDegree1 = 0;
//            turnDegree0 = 0;
//            tangentX = 0;
//            tangentY = 0;
//            addParticle = false;
//            hitTarget = false;
//            findPushedBallLocation = false;
//            nextBall = false;
//            killUFO = false;
//            instruction = "Throw ball! Hit UFO!";
//          }
//        }
//      }
//    }
//  }




//  //did we lost some cubes?
//  for (int i=0; i<nCubes; ++i) {
//    // 500ms since last update
//    if (cubes[i].lastUpdate < now - 1500 && cubes[i].isLost==false) {
//      cubes[i].isLost= true;
//    }
//  }
//}

////helper functions to drive the cubes
//boolean rotateCubeMax(int id, float ta) {
//  float diff = ta-cubes[id].deg;
//  if (diff>180) diff-=360;
//  if (diff<-180) diff+=360;
//  if (abs(diff)<20) return true;
//  int dir = 1;
//  int strength = int(abs(diff) / 10);
//  strength = 1;//
//  if (diff<0)dir=-1;
//  float left = ( 10*(1*strength)*dir);
//  float right = (-10*(1+strength)*dir);

//  //println("rotate speed", id, left, right); //maybe the speed here is kinda slow and can adjust the constant
//  int duration = 300;
//  motorControl(id, left, right, duration);
//  //println("rotate false "+diff +" "+ id+" "+ta +" "+cubes[id].deg);
//  return false;
//}
