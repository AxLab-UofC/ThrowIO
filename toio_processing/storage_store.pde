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

////camera
//Capture video;
//Kinect kinect;
//color trackColor;
//float threshold = 40; //150 for red
//int clickCount = 0;
//int mouseXLocation;
//int mouseYLocation;
//boolean ballSticks = false;
//int[] mouseXLocationList = new int[4];
//int[] mouseYLocationList = new int[4];
//float scaledX = -1000;
//float scaledY = -1000;
//float hitX = -1000;
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
//float cx = 0;
//float cy = 0;
//float sx = 0;
//float sy = 0;
//float radius = 120;
//float diameter = 2*radius;
//float d1 = 0.0;
//float d2 = 0.0;
//float theta1 = 0;
//PVector v1, v2, v3, v4;
//float theta2 = 0.0;
//float theta3 = 0.0;
//float theta4 = 0.0;
//float x = 0.0;
//float y = 0.0;
//float x2 = 0.0;
//float y2 = 0.0;
//float finalx = 0.0;
//float finaly = 0.0;
//float xprime = 0.0;
//float yprime = 0.0;
//boolean findTangentPoints = false;
//float c0_dist = 0.0;
//float c1_dist = 0.0;
//float c0_dist_ball = 0.0;
//float c1_dist_ball = 0.0;
//int closer_toio_id = 0;
//String furtherTangentPoint;
//boolean errorFlag = false;
//boolean errorFlag2 = false;
//boolean errorFlag3 = false;
//boolean outsideRadius = true;
//boolean convergeFlag = false;
//boolean knockSucceed = false;
//int closeDistance = 45;
//int closeDistance2 = 45;
//boolean seeBall = false;
//int time = millis();
//boolean startTime = false;
//boolean turnFlag = false;
//boolean turnFlag1 = false;
//boolean turnFlag2 = false;
//boolean recordDegree = false;
//boolean flag_recordPushingToioPushLocationAngle = false;
//float turnDegree1 = 0;
//float turnDegree0 = 0;
//boolean findDistBall = false;
//boolean findDist = false;
//float tangentX = 0;
//float tangentY = 0;
//float ySpeed = 1;
//float xSpeed = 1;
//float ycoord = 100;
//float xcoord = 100;
//float pushx = 240;
//float pushy = 270;
//boolean hitTarget = false;
//float monitorWidth = 0;
//int pushToio = 0;

//boolean travelOut = false;
//boolean travelToPush = false;
//boolean turning = false;
//boolean pushDone = false;
//boolean findDistBall2 = false;
//boolean facePushLocation = false;
//boolean findPushedBallLocation = false;

//// A reference to our box2d world
//Box2DProcessing box2d;

////void settings() {
////  size(500, 500);
////}

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
//  //String[] args = {"TwoFrameTest"};

//  //SecondApplet sa = new SecondApplet();
//  //PApplet.runSketch(args, sa);
//}

//public class SecondApplet extends PApplet {


//  // An ArrayList of particles that will fall on the surface
//  ArrayList<Particle> particles;

      
//  class Particle {

//  // We need to keep track of a Body and a radius
//  Body body;
//  float r;

//  color col;


//  Particle(float x, float y, float r_) {
//    r = r_;
//    // This function puts the particle in the Box2d world
//    makeBody(x, y, r);
//    body.setUserData(this);
//    col = color(175);
//  }

//  // This function removes the particle from the box2d world
//  void killBody() {
//    box2d.destroyBody(body);
//  }

//  // Change color when hit
//  void change() {
//    col = color(255, 0, 0);
//  }

//  // Is the particle ready for deletion?
//  boolean done() {
//    // Let's find the screen position of the particle
//    Vec2 pos = box2d.getBodyPixelCoord(body);
//    // Is it off the bottom of the screen?
//    if (pos.y > height+r*2) {
//      killBody();
//      return true;
//    }
//    return false;
//  }


//  //
//  void display() {
//    // We look at each body and get its screen position
//    Vec2 pos = box2d.getBodyPixelCoord(body);
//    // Get its angle of rotation
//    float a = body.getAngle();
//    pushMatrix();
//    translate(pos.x, pos.y);
//    rotate(a);
//    fill(col);
//    stroke(0);
//    strokeWeight(1);
//    ellipse(0, 0, r*2, r*2);
//    // Let's add a line so we can see the rotation
//    //line(0, 0, r, 0);
//    popMatrix();
//  }

//  // Here's our function that adds the particle to the Box2D world
//  void makeBody(float x, float y, float r) {
//    // Define a body
//    BodyDef bd = new BodyDef();
//    // Set its position
//    bd.position = box2d.coordPixelsToWorld(900, 900);
//    bd.type = BodyType.DYNAMIC;
//    body = box2d.createBody(bd);

//    // Make the body's shape a circle
//    CircleShape cs = new CircleShape();
//    cs.m_radius = box2d.scalarPixelsToWorld(r);

//    FixtureDef fd = new FixtureDef();
//    fd.shape = cs;
//    // Parameters that affect physics
//    fd.density = 1;
//    fd.friction = 0.01;
//    fd.restitution = 0.3;

//    // Attach fixture to body
//    body.createFixture(fd);

//    //body.setAngularVelocity(random(-10, 10));
//    body.setLinearVelocity(new Vec2(-5, 40));
//  }
//}

//  public void settings() {

//    fullScreen();
//    monitorWidth = width;

//    particles = new ArrayList<Particle>();
//    particles.add(new Particle(width/2, -20, 100));
//  }
  
//  public void draw() {
//    box2d.step(); //step through time in box2d
//    background(255);

//    if (hitTarget == false) {
//      xcoord += xSpeed;

//      if ((xcoord > width) || (xcoord < 0)) {
//        xSpeed *=-1;
//      }
//    }


//    //UFO structure
//    if (hitTarget == false) {
//      //stroke(0);
//      //fill(255);
//      //ellipse(xcoord, ycoord-25, 80, 100);

//      //noStroke();
//      //fill(0);
//      //ellipse(xcoord, ycoord, 150, 60);

//      //noStroke();
//      //fill(255);
//      //ellipse(xcoord, ycoord-23, 80, 15);

//      for (int i = particles.size()-1; i >= 0; i--) {
//        Particle p = particles.get(i);
//        p.display();
//        // Particles that leave the screen, we delete them
//        // (note they have to be deleted from both the box2d world and our list
//        if (p.done()) {
//          particles.remove(i);
//        }
//      }
      
//    } else {
//      stroke(0);
//      fill(255, 0, 0);
//      ellipse(xcoord, ycoord-25, 80, 100);

//      noStroke();
//      fill(0);
//      ellipse(xcoord, ycoord, 150, 60);

//      noStroke();
//      fill(255, 0, 0);
//      ellipse(xcoord, ycoord-23, 80, 15);
//    }




//    //if(hitTarget == true) {
//    //  fill(255, 0, 255);
//    //  ellipse(300, 300, 200, 200);
//    //}else{
//    //  fill(0, 0, 0);
//    //  noStroke();
//    //  ellipse(300, 300, 200, 200);

//    //}
//    //show the ball in the image to hit target


//    //  fill(256);
//    //  ellipse(x, y, 400, 400);
//    //  if (startTime == false){
//    //    time = millis();
//    //    startTime = true;
//    //  }else{
//    //    if (millis() > time + 5000){
//    //      hitTarget = false;
//    //      startTime = false;
//    //    }

//    //  }
//  };





//  //y += ySpeed;
//  //if (y > height || y < 0){
//  //  ySpeed *=-1;
//  //}




//  //}

//  //if (paintx != null){
//  //  for (int i = 0; i <= paintcount; i += 1) {
//  //  fill(255, 0, 255);

//  //  paintscaledX = map(paintx[i], 0, 615, 0, width);
//  //  paintscaledY = map(painty[i], 0, 382, 0, height);
//  //  if(paintscaledX != 0 || paintscaledY != 0){
//  //     ellipse(paintscaledX, paintscaledY, 400, 400);
//  //  }

//  //  }

//  //}

//  //draw rectangles
//  //if (upperleft == false){
//  //  fill(255, 255, 255);
//  //  rect(0, 0, width/2, height/2);
//  //}else if (upperleft == true){
//  //   fill(255, 0, 0);
//  //  rect(0, 0, width/2, height/2);
//  //}

//  //if (upperright == false){
//  //  fill(255, 255, 255);
//  //  rect(width/2, 0, width/2, height/2);
//  //}else if (upperright == true){
//  //   fill(0, 255, 0);
//  //  rect(width/2, 0, width/2, height/2);
//  //}

//  //if (lowerright == false){
//  //  fill(255, 255, 255);
//  //  rect(width/2, height/2, width/2, height/2);
//  //}else if (lowerright == true){
//  //   fill(0, 0, 255);
//  //   rect(width/2, height/2, width/2, height/2);
//  //}

//  //if (lowerleft == false){
//  //  fill(255, 255, 255);
//  //  rect(0, height/2, width/2, height/2);
//  //}else if (lowerleft == true){
//  //  fill(255, 0, 255);
//  //  rect(0, height/2, width/2, height/2);

//  //}
//}

//float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
//  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
//  return d;
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

//  float avgX = 0;
//  float avgY = 0;

//  int count = 0;


//  if (clickCount < 4) {

//    fill(255);
//    strokeWeight(1.0);
//    stroke(0);
//    ellipse(mouseXLocation, mouseYLocation, 10, 10);
//    //1
//    //  2

////    println("x0:", cubes[0].x);
////    println("y0:", cubes[0].y);

//    aimCubeSpeed(0, 75, 300);
//    aimCubeSpeed(1, 550, 400);
//  }

//  //println("scaledX: ", scaledX);
//  //println("scaledY: ", scaledY);
//  if (clickCount >= 4 && seeBall == false && ballSticks == false) { //must include other flags as well //we actually can't include ballSticks == false
//    //println("start detect if see ball");
//    // Begin loop to walk through every pixel
//    for (int x = 0; x < kinect.getVideoImage().width; x++ ) {
//      for (int y = 0; y < kinect.getVideoImage().height; y++ ) {
//        int loc = x + y * kinect.getVideoImage().width;
//        // What is current color
//        color currentColor = kinect.getVideoImage().pixels[loc];
//        float r1 = red(currentColor);
//        float g1 = green(currentColor);
//        float b1 = blue(currentColor);
//        float r2 = red(trackColor);
//        float g2 = green(trackColor);
//        float b2 = blue(trackColor);

//        float d = distSq(r1, g1, b1, r2, g2, b2);

//        if (d < threshold*threshold) {
//          stroke(255);
//          strokeWeight(1);
//          point(x, y);
//          avgX += x;
//          avgY += y;
//          count++;
//        }
//      }
//    }

//    // We only consider the color found if its color distance is less than 10.
//    // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
//    if (count > 50) {


//      seeBall = true;
//    } else {
//      seeBall = false;
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == false) {
//    //check if ball sticks or not

//    if (startTime == false) {
//      time = millis();
//      startTime = true;
//    } else {
//      if (millis() > time + 1000) { //wait for the ball to stick properly maybe 2 seconds
//        startTime = false;

//        //we can do the detect here!

//        println("check if ballSticks and find its location");
//        //redo color detection
//        for (int x = 0; x < kinect.getVideoImage().width; x++ ) {
//          for (int y = 0; y < kinect.getVideoImage().height; y++ ) {
//            int loc = x + y * kinect.getVideoImage().width;
//            // What is current color
//            color currentColor = kinect.getVideoImage().pixels[loc];
//            float r1 = red(currentColor);
//            float g1 = green(currentColor);
//            float b1 = blue(currentColor);
//            float r2 = red(trackColor);
//            float g2 = green(trackColor);
//            float b2 = blue(trackColor);

//            float d = distSq(r1, g1, b1, r2, g2, b2);

//            if (d < threshold*threshold) {
//              stroke(255);
//              strokeWeight(1);
//              point(x, y);
//              avgX += x;
//              avgY += y;
//              count++;
//            }
//          }
//        }

//        // We only consider the color found if its color distance is less than 10.
//        // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
//        if (count > 50) {

//          avgX = avgX / count;
//          avgY = avgY / count;

//          println("avgX", avgX);
//          println("avgY", avgY);

//          scaledX = map(avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//          scaledY = map(avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

//          // Draw a circle at the tracked pixel
//          fill(255);
//          strokeWeight(4.0);
//          stroke(0);
//          ellipse(avgX, avgY, 20, 20);


//          ballSticks = true;

//          //upper left corber coordinate is (32, 32) and lower right corver is (646, 465)
//          if (scaledX > 596 || scaledY > 415 || scaledY < 82 || scaledX < 82) {
//            ballSticks = false;
//            seeBall = false;
//          }
//        } else {
//          ballSticks = false;
//          seeBall = false;
//        }
//      }
//    }

//    println("ballSticks :", ballSticks); //need to determine which toio to push
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && travelOut == false && facePushLocation == false && travelToPush == false && turning == false && pushDone == false) {
//    println("toio travelling out and prepare for pushing");
//    //give push x location and push y location
//    if (findDistBall2 == false) {
//      c0_dist_ball = cubes[0].distance(scaledX, scaledY);
//      c1_dist_ball = cubes[1].distance(scaledX, scaledY);

//      findDistBall2 = true;

//      if (c0_dist_ball < c1_dist_ball) {
//        tangentX = cubes[0].x;
//        tangentY = cubes[0].y;
//      } else {
//        tangentX = cubes[1].x;
//        tangentY = cubes[1].y;
//      }
//    }


//    //if ( (scaledX >= tangentX && scaledY <= tangentY) ||  (scaledX <= tangentX && scaledY >= tangentY)) {
//    //  //ball is in first and third quadrant

//    //  c0_dist = cubes[0].distance(150, 100);
//    //  c1_dist = cubes[1].distance(150, 100); //in this example, we use cube 1 as the other dropper

//    //  if (c0_dist < c1_dist) {
//    //    //println("0 is closer toio to (150, 100)");
//    //    aimCubeSpeed(0, 150, 100);
//    //    aimCubeSpeed(1, 550, 400);
//    //  } else {
//    //    //println("1 is closer toio  to (150, 100)");
//    //    aimCubeSpeed(1, 150, 100);
//    //    aimCubeSpeed(0, 550, 400);
//    //  }

//    //  ///TODO: Found a bug. if the toios are at the original position and the ball is still within radius, then the toios won't move
//    //  if (c0_dist < c1_dist) {
//    //    if (abs(cubes[0].x - 150) < 15 && abs(cubes[0].y - 100) < 15 && abs(cubes[1].x - 550) < 15 && abs(cubes[1].y - 400) < 15 ) {
//    //      println("outside radius true? [1]");
//    //      travelOut = true;
//    //    }
//    //  } else {
//    //    if (abs(cubes[0].x - 550) < 15 && abs(cubes[0].y - 400) < 15 && abs(cubes[1].x - 150) < 15 && abs(cubes[1].y - 100) < 15 ) {
//    //      println("outside radius true? [2]");
//    //      travelOut = true;
//    //    }
//    //  }
//    //} else {

//    //  c0_dist = cubes[0].distance(150, 400);
//    //  c1_dist = cubes[1].distance(150, 400); //in this example, we use cube 1 as the other dropper

//    //  if (c0_dist < c1_dist) {
//    //    //println("0 is closer toio to (150, 400)");
//    //    aimCubeSpeed(0, 150, 400);
//    //    aimCubeSpeed(1, 550, 100);
//    //  } else {
//    //    //println("1 is closer toio  to (150, 400)");
//    //    aimCubeSpeed(1, 150, 400);
//    //    aimCubeSpeed(0, 550, 100);
//    //  }


//    //  ///TODO: Found a bug. if the toios are at the original position and the ball is still within radius, then the toios won't move
//    //  if (c0_dist < c1_dist) {
//    //    if (abs(cubes[0].x - 150) < 15 && abs(cubes[0].y - 400) < 15 && abs(cubes[1].x - 550) < 15 && abs(cubes[1].y - 100) < 15 ) {
//    //      println("outside radius true? [1]");
//    //      travelOut = true;
//    //    }
//    //  } else {
//    //    if (abs(cubes[0].x - 550) < 15 && abs(cubes[0].y - 100) < 15 && abs(cubes[1].x - 150) < 15 && abs(cubes[1].y - 400) < 15 ) {
//    //      println("outside radius true? [2]");
//    //      travelOut = true;
//    //    }
//    //  }
//    //}
    
//    travelOut = true;
    

//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && travelOut == true && facePushLocation == false && travelToPush == false && turning == false && pushDone == false) {

//    if (flag_recordPushingToioPushLocationAngle == false) {

//      if (cubes[0].x > pushx) {
//        //cube 0 will push
//        pushToio = 0;

//        turnDegree0 = degrees(atan2(scaledY-cubes[0].y, scaledX-cubes[0].x));
//        if (turnDegree0 < 0) {
//          turnDegree0+=360;
//        }
//      } else {
//        //cube 1 will push
//        pushToio = 1;
//        turnDegree1 = degrees(atan2(scaledY-cubes[1].y, scaledX-cubes[1].x));
//        if (turnDegree1 < 0) {
//          turnDegree1+=360;
//        }
//      }

//      flag_recordPushingToioPushLocationAngle = true;
//    } else {

//      if (pushToio == 0) {
//        if (rotateCube(0, turnDegree0-180)) {
//          facePushLocation = true;
//        }
//      } else {
//        if (rotateCube(1, turnDegree1-180)) {
//          facePushLocation = true;
//        }
//      }
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == false && turning == false && pushDone == false) {

//    println("one toio travels to push");
//    //depending on where the toio wants to go (push x and push y)
//    if (pushToio == 0) {
//      //cube 0 will push
//      aimCubeSpeed(0, scaledX, scaledY); //may need to control distance

//      if (abs(cubes[0].x - scaledX) < closeDistance2 && abs(cubes[0].y - scaledY) < closeDistance2) {

//        travelToPush = true;
//      }
//    } else {
//      //cube 1 will push
      
//      aimCubeSpeed(1, scaledX, scaledY);

//      if (abs(cubes[1].x - scaledX) < closeDistance2 && abs(cubes[1].y - scaledY) < closeDistance2) {

//        travelToPush = true;
//      }
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == true && turning == false && pushDone == false) {
//    println("toio turns angle to face push location");
//    if (pushToio == 0) {
//      //0 is the pushing toio

//      if (rotateCubeMax(0, turnDegree1-180)) {
//        turning = true;
//      }
//    } else {
//      //1 is the pushing toio
//      if (rotateCubeMax(1, turnDegree1-180)) {
//        turning = true;
//      }
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && travelOut == true && facePushLocation == true && travelToPush == true && turning == true && pushDone == false) {
//    println("toio pushes");
//    if (pushToio == 0) {
//      //0 is the pushing toio
//      if (aimCubeSpeed(0, pushx, pushy)) {
//        pushDone = true;
//      }
//    } else {
//      //1 is the pushing toio
//      if (aimCubeSpeed(1, pushx, pushy)) {
//        pushDone = true;
//      }
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && pushDone == true && outsideRadius == true && findTangentPoints == false && scaledX != sx && scaledY != sy) {

//    if (aimCubeSpeed(1, 500, 300)){
//      outsideRadius = true;
//    }
   

//  //  hitX = map(scaledX, 32, 614+32, 0, 1440);

//  //  println("hitX: ", hitX);
//  //  println("xcoord: ", xcoord);
//  //  if (abs(hitX - xcoord) < 500) {
//  //    hitTarget = true; //determine whether the ball hits the UFO or not (only care about x axis)
//  //  }

//  //  println("find tangent points");

//  //  //findTangentPoints means checking if we can find tangent points
//  //  //recordpoint

//  //  if (findPushedBallLocation == false) {

//  //    for (int x = 0; x < kinect.getVideoImage().width; x++ ) {
//  //      for (int y = 0; y < kinect.getVideoImage().height; y++ ) {
//  //        int loc = x + y * kinect.getVideoImage().width;
//  //        // What is current color
//  //        color currentColor = kinect.getVideoImage().pixels[loc];
//  //        float r1 = red(currentColor);
//  //        float g1 = green(currentColor);
//  //        float b1 = blue(currentColor);
//  //        float r2 = red(trackColor);
//  //        float g2 = green(trackColor);
//  //        float b2 = blue(trackColor);

//  //        float d = distSq(r1, g1, b1, r2, g2, b2);

//  //        if (d < threshold*threshold) {
//  //          stroke(255);
//  //          strokeWeight(1);
//  //          point(x, y);
//  //          avgX += x;
//  //          avgY += y;
//  //          count++;
//  //        }
//  //      }
//  //    }

//  //    // We only consider the color found if its color distance is less than 10.
//  //    // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
//  //    if (count > 50) {

//  //      avgX = avgX / count;
//  //      avgY = avgY / count;

//  //      println("avgX", avgX);
//  //      println("avgY", avgY);

//  //      scaledX = map(avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//  //      scaledY = map(avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

//  //      // Draw a circle at the tracked pixel
//  //      fill(255);
//  //      strokeWeight(4.0);
//  //      stroke(0);
//  //      ellipse(avgX, avgY, 20, 20);
//  //    }

//  //    findPushedBallLocation = true;
//  //  }





//  //  c0_dist = cubes[0].distance(scaledX, scaledY);
//  //  c1_dist = cubes[1].distance(scaledX, scaledY); //in this example, we use cube 1 as the other dropper

//  //  if (c0_dist < c1_dist) {
//  //    closer_toio_id = 0; //closer toio
//  //    println("0 is closer toio");
//  //  } else {
//  //    closer_toio_id = 1; //further toio
//  //    println("1 is closer toio");
//  //  }

//  //  //find two points around the ball
//  //  if (closer_toio_id == 0) {
//  //    cx = cubes[0].x;
//  //    cy = cubes[0].y;
//  //  } else {
//  //    cx = cubes[1].x;
//  //    cy = cubes[1].y;
//  //  }

//  //  //check if the dropper is outside the radius of the circle
//  //  //if it is inside, we will need to move it out to the two corners
//  //  if (sqrt ( pow ( scaledX - cx, 2 ) + pow ( scaledY - cy, 2 )) > radius) {
//  //    sx = scaledX;
//  //    sy = scaledY;

//  //    //distance from ball to cube
//  //    d1 = sqrt ( pow ( sx - cx, 2 ) + pow ( sy - cy, 2 ));

//  //    //distance from ball to lower tangent point
//  //    d2 = sqrt ( pow ( d1, 2 ) - pow ( radius, 2 ));

//  //    //vectors for angle calculation
//  //    v1 = new PVector(sx-cx, cy-cy);
//  //    v2 = new PVector(sx-cx, sy-cy);

//  //    //angles
//  //    theta1 = acos(d2/d1);
//  //    theta2 = acos(v1.dot(v2)/(v1.mag()*v2.mag()));
//  //    theta3 = theta2+theta1;

//  //    if ((sx - cx)> 0 & (sy-cy) < 0) { //we already convert quadrant coordinates to toio mat coordinates
//  //      println("ball in quadrant 1 [1]");
//  //      x = cx+d2*cos(theta3);
//  //      y = cy-d2*sin (theta3);
//  //    } else if ((sx - cx) < 0 & (sy-cy) < 0) {
//  //      println("ball in quadrant 2 [1]");
//  //      x = cx-d2*cos(theta3);
//  //      y = cy-d2*sin (theta3);
//  //    } else if ((sx - cx) < 0 & (sy-cy) > 0) {
//  //      println("ball in quadrant 3 [1]");
//  //      x = cx-d2*cos(theta3);
//  //      y = cy+d2*sin (theta3);
//  //    } else if ((sx - cx) > 0 & (sy-cy) > 0) {
//  //      println("ball in quadrant 4 [1]");

//  //      x = cx+d2*cos(theta3);
//  //      y = cy+d2*sin (theta3);
//  //    } else {

//  //      //ball on x axis or y axis
//  //      //we let the robot move a little bit

//  //      if (abs(sx - cx) < 5) {
//  //        //same Y

//  //        //for math debug let toio move for 10, run the process again
//  //        if (closer_toio_id == 0) {
//  //          aimCubeSpeed(0, cx+10, cy);
//  //        } else {
//  //          aimCubeSpeed(1, cx+10, cy);
//  //        }
//  //      } else if (abs(sy - cy) < 5) {
//  //        //same X

//  //        if (closer_toio_id == 0) {
//  //          aimCubeSpeed(0, cx, cy+10);
//  //        } else {
//  //          aimCubeSpeed(1, cx, cy+10);
//  //        }
//  //      } else {
//  //        println("Something is wrong with the lower tangent point");
//  //      }

//  //      //no lower tangent point
//  //      errorFlag = true;
//  //    }

//  //    if (errorFlag == false) {
//  //      theta3 = theta2-theta1; //find the other tangent point

//  //      if ((sx - cx)> 0 & (sy-cy) < 0) { //we already convert quadrant coordinates to toio mat coordinates
//  //        println("ball in quadrant 1 [2]");
//  //        x2 = cx+d2*cos(theta3);
//  //        y2 = cy-d2*sin (theta3);
//  //      } else if ((sx - cx) < 0 & (sy-cy) < 0) {
//  //        println("ball in quadrant 2 [2]");
//  //        x2 = cx-d2*cos(theta3);
//  //        y2 = cy-d2*sin (theta3);
//  //        println("q2 x: ", x);
//  //        println("q2 y: ", y);
//  //      } else if ((sx - cx) < 0 & (sy-cy) > 0) {
//  //        println("ball in quadrant 3 [2]");
//  //        x2 = cx-d2*cos(theta3);
//  //        y2 = cy+d2*sin (theta3);
//  //      } else if ((sx - cx) > 0 & (sy-cy) > 0) {
//  //        println("ball in quadrant 4 [2]");

//  //        x2 = cx+d2*cos(theta3);
//  //        y2 = cy+d2*sin (theta3);
//  //      } else {
//  //        //ball on x axis or y axis
//  //        //we let the robot move a little bit

//  //        if (abs(sx - cx) < 5) {
//  //          //same Y

//  //          //for math debug let toio move for 10, run the process again
//  //          if (closer_toio_id == 0) {
//  //            aimCubeSpeed(0, cx+10, cy);
//  //          } else {
//  //            aimCubeSpeed(1, cx+10, cy);
//  //          }
//  //        } else if (abs(sy - cy) < 5) {
//  //          //same X

//  //          if (closer_toio_id == 0) {
//  //            aimCubeSpeed(0, cx, cy+10);
//  //          } else {
//  //            aimCubeSpeed(1, cx, cy+10);
//  //          }
//  //        } else {
//  //          println("Something is wrong with find the higher tangent point");
//  //        }

//  //        //no higher tangent point
//  //        errorFlag2 = true;
//  //      }
//  //    }


//  //    if (errorFlag == false && errorFlag2 == false) {
//  //      //2. use the further toio to find the tangent point that has longer distance
//  //      if (closer_toio_id == 0) {
//  //        //toio id 2 is the further toio
//  //        if (cubes[1].distance(x, y) > cubes[1].distance(x2, y2)) {
//  //          //x and y point is further
//  //          furtherTangentPoint = "xy";
//  //        } else {
//  //          //x2 and y2 is further
//  //          furtherTangentPoint = "x2y2";
//  //        }
//  //      } else {
//  //        //toio id 0 is the further toio
//  //        if (cubes[0].distance(x, y) > cubes[0].distance(x2, y2)) {
//  //          //x and y point is further
//  //          furtherTangentPoint = "xy";
//  //        } else {
//  //          //x2 and y2 is further
//  //          furtherTangentPoint = "x2y2";
//  //        }
//  //      }

//  //      //3. use the furtherTangentPoint to find the opposite point
//  //      if (furtherTangentPoint.equals("xy")) {
//  //        finalx = x;
//  //        finaly = y;
//  //      } else {

//  //        finalx = x2;
//  //        finaly = y2;
//  //      }

//  //      v3 = new PVector(sx-finalx, sy-finaly);
//  //      v4 = new PVector(sx-finalx, finaly-finaly);

//  //      theta4 = acos(v3.dot(v4)/(v3.mag()*v4.mag()));

//  //      if ((sx - finalx)> 0 & (sy-finaly) < 0) { //we already convert quadrant coordinates to toio mat coordinates

//  //        xprime = finalx+diameter*cos(theta4);
//  //        yprime = finaly-diameter*sin (theta4);
//  //      } else if ((sx - finalx) < 0 & (sy-finaly) < 0) {

//  //        xprime = finalx-diameter*cos(theta4);
//  //        yprime = finaly-diameter*sin (theta4);
//  //      } else if ((sx - finalx) < 0 & (sy-finaly) > 0) {

//  //        xprime = finalx-diameter*cos(theta4);
//  //        yprime = finaly+diameter*sin (theta4);
//  //      } else if ((sx - finalx) > 0 & (sy-finaly) > 0) {

//  //        xprime = finalx+diameter*cos(theta4);
//  //        yprime = finaly+diameter*sin (theta4);
//  //      } else {
//  //        //ball on x axis or y axis
//  //        //we let the robot move a little bit

//  //        if (abs(sx - finalx) < 5) {
//  //          //same Y

//  //          //for math debug let toio move for 10, run the process again
//  //          if (closer_toio_id == 0) {
//  //            aimCubeSpeed(0, cx+10, cy);
//  //          } else {
//  //            aimCubeSpeed(1, cx+10, cy);
//  //          }
//  //        } else if (abs(sy - finaly) < 5) {
//  //          //same X
//  //          if (closer_toio_id == 0) {
//  //            aimCubeSpeed(0, cx, cy+10);
//  //          } else {
//  //            aimCubeSpeed(1, cx, cy+10);
//  //          }
//  //        } else {
//  //          println("Something is wrong with finding tangent points");
//  //          exit();
//  //        }

//  //        //no tangent points found
//  //        errorFlag3 = true;
//  //      }

//  //      if (errorFlag == false && errorFlag2 == false && errorFlag3 == false && outsideRadius == true) {
//  //        findTangentPoints = true;
//  //      }
//  //    }
//  //  } else {
//  //    //case when the ball is in the radius of the circle
//  //    outsideRadius = false;
//  //  }

//  //  println("errorFlag: ", errorFlag);
//  //  println("errorFlag2: ", errorFlag2);
//  //  println("errorFlag3: ", errorFlag3);
//  //  println("findTangentPoints: ", findTangentPoints);
//  //  println("outsideRadius: ", outsideRadius);
//  //  println("convergeFlag: ", convergeFlag);
//  //  println("knockSucceed: ", knockSucceed);
//  //} else if (clickCount >= 4 && seeBall == true && ballSticks == true && outsideRadius == false) {

//  //  println("handle case when the ball is within radius");
//  //  //handle the case that the ball is within radius


//  //  //------extra notes------//

//  //  if (findDistBall == false) {
//  //    c0_dist_ball = cubes[0].distance(scaledX, scaledY);
//  //    c1_dist_ball = cubes[1].distance(scaledX, scaledY);

//  //    findDistBall = true;

//  //    if (c0_dist_ball < c1_dist_ball) {
//  //      tangentX = cubes[0].x;
//  //      tangentY = cubes[0].y;
//  //    } else {
//  //      tangentX = cubes[1].x;
//  //      tangentY = cubes[1].y;
//  //    }
//  //  }


//  //  //see which toio is closer to the ball

//  //  //println("1 is closer toio to the ball");
//  //  //find which quadrant the ball is in
//  //  if ( (scaledX >= tangentX && scaledY <= tangentY) ||  (scaledX <= tangentX && scaledY >= tangentY)) {
//  //    //ball is in first and thrid quadrant

//  //    c0_dist = cubes[0].distance(150, 100);
//  //    c1_dist = cubes[1].distance(150, 100); //in this example, we use cube 1 as the other dropper

//  //    if (c0_dist < c1_dist) {
//  //      //println("0 is closer toio to (150, 100)");
//  //      aimCubeSpeed(0, 150, 100);
//  //      aimCubeSpeed(1, 550, 400);
//  //    } else {
//  //      //println("1 is closer toio  to (150, 100)");
//  //      aimCubeSpeed(1, 150, 100);
//  //      aimCubeSpeed(0, 550, 400);
//  //    }

//  //    ///TODO: Found a bug. if the toios are at the original position and the ball is still within radius, then the toios won't move
//  //    if (c0_dist < c1_dist) {
//  //      if (abs(cubes[0].x - 150) < 15 && abs(cubes[0].y - 100) < 15 && abs(cubes[1].x - 550) < 15 && abs(cubes[1].y - 400) < 15 ) {
//  //        println("outside radius true? [1]");
//  //        outsideRadius = true;
//  //      }
//  //    } else {
//  //      if (abs(cubes[0].x - 550) < 15 && abs(cubes[0].y - 400) < 15 && abs(cubes[1].x - 150) < 15 && abs(cubes[1].y - 100) < 15 ) {
//  //        println("outside radius true? [2]");
//  //        outsideRadius = true;
//  //      }
//  //    }
//  //  } else {

//  //    c0_dist = cubes[0].distance(150, 400);
//  //    c1_dist = cubes[1].distance(150, 400); //in this example, we use cube 1 as the other dropper

//  //    if (c0_dist < c1_dist) {
//  //      //println("0 is closer toio to (150, 400)");
//  //      aimCubeSpeed(0, 150, 400);
//  //      aimCubeSpeed(1, 550, 100);
//  //    } else {
//  //      //println("1 is closer toio  to (150, 400)");
//  //      aimCubeSpeed(1, 150, 400);
//  //      aimCubeSpeed(0, 550, 100);
//  //    }

//  //    ///TODO: Found a bug. if the toios are at the original position and the ball is still within radius, then the toios won't move
//  //    if (c0_dist < c1_dist) {
//  //      if (abs(cubes[0].x - 150) < 15 && abs(cubes[0].y - 400) < 15 && abs(cubes[1].x - 550) < 15 && abs(cubes[1].y - 100) < 15 ) {
//  //        println("outside radius true? [1]");
//  //        outsideRadius = true;
//  //      }
//  //    } else {
//  //      if (abs(cubes[0].x - 550) < 15 && abs(cubes[0].y - 100) < 15 && abs(cubes[1].x - 150) < 15 && abs(cubes[1].y - 400) < 15 ) {
//  //        println("outside radius true? [2]");
//  //        outsideRadius = true;
//  //      }
//  //    }
//  //  }


//    //------extra notes------//
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && errorFlag == true) {
//    //just in case we don't find a lower tangent point
//    errorFlag = false;
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && errorFlag2 == true) {
//    //just in case we don't find a higer tangent point
//    errorFlag2 = false;
//  } else if (clickCount >= 4  && seeBall == true && ballSticks == true && errorFlag3 == true) {
//    errorFlag3 = false;
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && errorFlag == false && errorFlag2 == false && errorFlag3 == false &&
//    findTangentPoints == true && outsideRadius == true && convergeFlag == false && knockSucceed == false) {
    
//      exit();
          
//      println("toios are travelling");
    
    
//    //maybe I would want the toios to move back to the tangent points after they converge

//    if (closer_toio_id == 0) {
//      aimCubeSpeed(0, finalx, finaly);
//      aimCubeSpeed(1, xprime, yprime);
//      if (abs(cubes[0].x - finalx) < 15 && abs(cubes[0].y - finaly) < 15 && abs(cubes[1].x - xprime) < 15 && abs(cubes[1].y - yprime) < 15 ) {
//        //findTangentPoints = false;
//        convergeFlag = true;
//      }
//    } else {
//      aimCubeSpeed(1, finalx, finaly);
//      aimCubeSpeed(0, xprime, yprime);
//      if (abs(cubes[1].x - finalx) < 15 && abs(cubes[1].y - finaly) < 15 && abs(cubes[0].x - xprime) < 15 && abs(cubes[0].y - yprime) < 15) {
//        //findTangentPoints = false;
//        convergeFlag = true;
//      }
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && outsideRadius == true && findTangentPoints == true &&
//    convergeFlag == true && turnFlag == false && knockSucceed == false) {
 
//    println("turn angle!");
//    //spin to the right direction
//    //say let 0 be front and let 1 be back

//    if (recordDegree == false) {
//      turnDegree0 = degrees(atan2(scaledY-cubes[0].y, scaledX-cubes[0].x));
//      if (turnDegree0 < 0) {
//        turnDegree0+=360;
//      }

//      turnDegree1 = degrees(atan2(scaledY-cubes[1].y, scaledX-cubes[1].x));

//      if (turnDegree1 < 0) {
//        turnDegree1+=360;
//      }
//      recordDegree = true;
//    } else {
      
     
//      if (abs(cubes[0].deg - turnDegree0) < 10){
//        turnFlag1 = true;
      
//      }else{
//        rotateCube(0, turnDegree0);
//      }
      
      
//      if (abs(cubes[1].deg - (turnDegree1-180)) < 10 || abs(cubes[1].deg - (turnDegree1-180+360)) < 10) {

//        turnFlag2 = true;
//      }else{
//        rotateCube(1, turnDegree1-180); //cube 1 use chopstick side
//      }

//      if (turnFlag1 && turnFlag2){
        
//        turnFlag = true;
      
//      }


//      //println("cubes[0].deg: ", cubes[0].deg);
//      //println("turnDegree0: ", turnDegree0);
//      //println("cubes[1].deg: ", cubes[1].deg);
//      //println("turnDegree1: ", turnDegree1);
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && outsideRadius == true && findTangentPoints == true
//    && convergeFlag == true && turnFlag == true && knockSucceed == false) {
//    println("converging");
    
//    aimCubeSpeed(0, scaledX, scaledY);
//    aimCubeSpeed(1, scaledX, scaledY);

//    if (abs(cubes[0].x - scaledX) < closeDistance && abs(cubes[1].x - scaledX) < closeDistance &&
//      abs(cubes[1].y - scaledY) < closeDistance &&  abs(cubes[1].y - scaledY) < closeDistance) {
//      knockSucceed = true;
//    }
//  } else if (clickCount >= 4 && seeBall == true && ballSticks == true && outsideRadius == true &&  findTangentPoints == true
//    && convergeFlag == true && turnFlag == true && knockSucceed == true) {
//    //  println("knocksucceed");
//    seeBall = false;
//    ballSticks = false;
//    findTangentPoints = false;
//    convergeFlag = false;
//    turnFlag = false;
//    turnFlag1 = false;
//    turnFlag2 = false;
//    recordDegree = false;
//    knockSucceed = false;
//    findDistBall = false;
//    findDist = false;
//    hitTarget = false;

//    travelOut = false;
//    travelToPush = false;
//    turning = true;
//    pushDone = true;
//    findDistBall2 = false;
//    facePushLocation = false;
//    flag_recordPushingToioPushLocationAngle = false;
//    facePushLocation = false;
//  }



//  //if (chase) {
//  //  cubes[0].targetx = cubes[0].x;
//  //  cubes[0].targety = cubes[0].y;
//  //  cubes[1].targetx = cubes[0].x;
//  //  cubes[1].targety = cubes[0].y;
//  //}
//  //makes a circle with n cubes
//  //if (mouseDrive) {
//  //  float mx = (mouseX);
//  //  float my = (mouseY);
//  //  float cx = 45+410/2;
//  //  float cy = 45+410/2;

//  //  float mulr = 180.0;

//  //  float aMouse = atan2( my-cy, mx-cx);
//  //  float r = sqrt ( (mx - cx)*(mx-cx) + (my-cy)*(my-cy));
//  //  r = min(mulr, r);
//  //  for (int i = 0; i< nCubes; ++i) {
//  //    if (cubes[i].isLost==false) {
//  //      float angle = TWO_PI*i/nCubes;
//  //      float na = aMouse+angle;
//  //      float tax = cx + r*cos(na);
//  //      float tay = cy + r*sin(na);
//  //      fill(255, 0, 0);
//  //      ellipse(tax, tay, 10, 10);
//  //      cubes[i].targetx = tax;
//  //      cubes[i].targety = tay;
//  //    }
//  //  }
//  //}

//  //if (spin) {
//  //  motorControl(0, -100, 100, 30);
//  //}

//  //if (chase || mouseDrive) {
//  //  //do the actual aim
//  //  for (int i = 0; i< nCubes; ++i) {
//  //    if (cubes[i].isLost==false) {
//  //      fill(0, 255, 0);
//  //      ellipse(cubes[i].targetx, cubes[i].targety, 10, 10);
//  //      aimCubeSpeed(i, cubes[i].targetx, cubes[i].targety);
//  //    }
//  //  }
//  //}


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

////boolean rotateCube(int id, float ta) {
////  float diff = ta-cubes[id].deg;
////  if (diff>180) diff-=360;
////  if (diff<-180) diff+=360;
////  if (abs(diff)<10) return true;
////  int dir = 1;
////  int strength = int(abs(diff) / 10);
////  strength = 1;//
////  if (diff<0)dir=-1;
////  float left = ( 10*(1*strength)*dir);
////  float right = (-10*(1+strength)*dir);

////  //println("rotate speed", id, left, right); //maybe the speed here is kinda slow and can adjust the constant
////  int duration = 300;
////  motorControl(id, left, right, duration);
////  //println("rotate false "+diff +" "+ id+" "+ta +" "+cubes[id].deg);
////  return false;
////}

////// the most basic way to move a cube
////boolean aimCube(int id, float tx, float ty) {
////  if (cubes[id].distance(tx, ty)<25) return true;
////  int[] lr = cubes[id].aim(tx, ty);
////  float left = (lr[0]*.5);
////  float right = (lr[1]*.5);
////  int duration = (100);
////  motorControl(id, left, right, duration);
////  return false;
////}

////boolean aimCubeSpeed(int id, float tx, float ty) {
////  float dd = cubes[id].distance(tx, ty)/100.0;
////  dd = min(dd, 1);
////  if (dd <.15) return true;

////  int[] lr = cubes[id].aim(tx, ty);
////  float left = (lr[0]*dd);
////  float right = (lr[1]*dd);
////  int duration = (100);
////  motorControl(id, left, right, duration);
////  return false;
////}

////void keyPressed() {
////  switch(key) {
////  case 'm':
////    mouseDrive = !mouseDrive;
////    chase = false;
////    spin = false;
////    break;
////  case 'c':
////    chase = !chase;
////    spin = false;
////    mouseDrive = false;
////    break;
////  case 's':
////    chase = false;
////    mouseDrive = false;
////    spin = false;
////    break;
////  case 'p':
////    spin = !spin;
////    chase = false;
////    mouseDrive=false;
////  case 'a':
////    for (int i=0; i < nCubes; ++i) {
////      aimMotorControl(i, 380, 260);
////    }
////    break;
////  case 'l':
////    light(0, 100, 255, 0, 0);
////    break;
////  case 'u':
////    motorControl(0, 115, 115, 200);//(toioID, left-speed, right-speed, duration[ms])
////    break;
////  case 'n':
////    motorControl(0, -115, -115, 200);//(toioID, left-speed, right-speed, duration[ms])
////    break;
////  default:
////    break;
////  }
////}



////void mousePressed() {


////  //chase = false;  
////  //spin = false;
////  //mouseDrive=true;

////  // Save color where the mouse is clicked in trackColor variable
////  int loc = mouseX + mouseY*kinect.getVideoImage().width;
////  mouseXLocation = mouseX;
////  mouseYLocation = mouseY;
////  mouseXLocationList[clickCount] = mouseX;
////  mouseYLocationList[clickCount] = mouseY;
////  clickCount+=1;
  
////  if(clickCount == 3){
////    trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this
////  }

  
////}

////void mouseReleased() {
////  mouseDrive=false;
////}



////OSC message handling (receive)
