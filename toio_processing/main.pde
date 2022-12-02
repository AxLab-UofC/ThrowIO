//This is the main ThrowIO code

import oscP5.*;
import netP5.*;
import processing.serial.*;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.tests.*;
import processing.video.*;
import org.openkinect.processing.*;
import org.openkinect.*;
import javax.swing.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

//camera
Capture video;
Kinect kinect;
color trackColor;
float threshold = 40; //150 for red
int clickCount = 0;
int mouseXLocation = -50;
int mouseYLocation = -50;
boolean phase2_ballSticks = false;
int[] mouseXLocationList = new int[4];
int[] mouseYLocationList = new int[4];
//float scaledX = -1000;
//float scaledY = -1000;
int global_closer_toio_id = 0;
//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;
//int cubesPerHost = 4; // each BLE bridge can have up to 4 cubes

//we'll keep the cubes here
Cube[] cubes;
//int nCubes =  4;

boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;

//global variables that helper functions would modify
float global_radius = 120;
float global_x = 0.0;
float global_y = 0.0;
float global_x2 = 0.0;
float global_y2 = 0.0;
float global_finalx = 0.0;
float global_finaly = 0.0;
float global_xprime = 0.0;
float global_yprime = 0.0;
float global_c0_dist = 0.0;
float global_c1_dist = 0.0;
float global_ball_x = 0; //sx
float global_ball_y = 0; //sy
float global_toio_center_x = 0; //cx
float global_toio_center_y = 0; //cy
float global_scaledX = 60;
float global_scaledY = 100;
String global_furtherTangentPoint;
float global_backoutx0 = 0;
float global_backouty0 = 0;
float global_backoutx1 = 0;
float global_backouty1 = 0;
float global_bitMoreThanRadius = global_radius+20;
float global_avgX = 0;
float global_avgY = 0;
int global_count = 0;
float global_avgDepth = 0;
float[] global_xHist = {};
float[] global_yHist = {};
float[] global_dHist = {};
int convergeDistance = 45;
int distanceBetweenPushingToioAndBall = 45;
int distanceBetweenPushingToioAndPushLocation = 25;
int time = millis();
boolean startTime = false;
float turnDegree1 = 0;
float turnDegree0 = 0;

boolean phase7_findTangentPoints = false;
boolean phase8_toioTravelToPrepLocation = false;
boolean phase10_dropSucceed = false;
boolean phase1_seeBall = false;
boolean phase9_rotateToDrop = false;
boolean phase4_travelToBallToPush = false;
boolean phase5_rotateBallToPushLocation = false;
boolean phase6_pushDone = false;
boolean phase3_facePushLocation = false;

boolean flag_rotate0 = false;
boolean flag_rotate1 = false;
boolean flag_recordToioAndBallAngle = false;
boolean flag_recordPushingToioAndBallAngle = false;
boolean flag_prepareBackout = false;


boolean ufo_flag_killUFO = false;
boolean ufo_flag_bombSound = false;
boolean ufo_flag_kill_particle = false;
boolean ufo_flag_killBall = false;

float[] xHist = {};
float[] yHist = {};
float[] dHist = {};
int rawDepth = 0;
float depthDiff;
float xDiff;
float throwDegree;
float avgZVelocity = 0.0;
float avgXVelocity = 0.0;
boolean ufo_flag_addParticle = false;
int time2 = millis();
boolean startTime2 = false;
float bulletx = 0;
float bullety = 0;
float monitorAdjustment = 130;

// A reference to our box2d world
Box2DProcessing box2d;
float monitorWidth = displayWidth;
float monitorHeight = displayHeight;
float ySpeed = 1;
float xSpeed = 1;
float ycoord = 300;
float xcoord = 600;
boolean ufo_flag_hitTarget = false;
float hitX = 720;
float pushx = 360; //400
float pushy = 240; //300

boolean flag_findPushedBallLocation = false;
int pushToio = 0;
boolean ufo_flag_nextBall = false;
boolean second_flag_startSprinkle = false;
boolean ballDidNotStick = false;
int scoreCount = 0;
boolean flag_needBackout = false;

SoundFile file;
boolean second_flag_startCrash = false;
boolean second_flag_startSelfCrash = false;
String ufo_instruction = "Throw ball! Hit UFO!";

void captureEvent(Capture video) {
  video.read();
}

void jumpToPhase1() {
  phase1_seeBall = false; //phase 1
  phase2_ballSticks = false; //phase 2
  phase3_facePushLocation = false; //phase 3
  phase4_travelToBallToPush = false; //phase 4
  phase5_rotateBallToPushLocation = false; //phase 5
  phase6_pushDone = false; //phase 6
  phase7_findTangentPoints = false; //phase 7
  phase8_toioTravelToPrepLocation = false; //phase 8
  phase9_rotateToDrop = false; //phase 9
  phase10_dropSucceed = false; //phase 10
}

void jumpToPhase10() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
  phase7_findTangentPoints = true; //phase 7
  phase8_toioTravelToPrepLocation = true; //phase 8
  phase9_rotateToDrop = true; //phase 9
  phase10_dropSucceed = false; //phase 10
}

void setup() {
  // for OSC
  // receive messages on port 3333
  oscP5 = new OscP5(this, 3333);

  //send back to the BLE interface
  //we can actually have multiple BLE bridges
  server = new NetAddress[1]; //only one for now
  //send on port 3334
  server[0] = new NetAddress("127.0.0.1", 3334);
  //server[1] = new NetAddress("192.168.0.103", 3334);
  //server[2] = new NetAddress("192.168.200.12", 3334);

  //create cubes
  cubes = new Cube[nCubes];
  for (int i = 0; i< cubes.length; ++i) {
    cubes[i] = new Cube(i, true);
  }

  //camera
  //size(640, 360);
  size(1280, 720);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -50); //we can change the gravity in box2D world here, currently using -120


  if (applicationMode == "ufo") {
    //allow two windows showing up at the same time
    //one for camera, the other for monitor screen
    String[] args = {"TwoFrameTest"};
    SecondApplet sa = new SecondApplet();
    PApplet.runSketch(args, sa);

    file = new SoundFile(this, "explosion.wav");
  } else if (applicationMode == "story") {
    println("launching immersive storytelling application");
    exit();
  }

  loadCalibration();
}


void draw() {

  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  drawDebugWindow();

  //println("monitorWidth: ", monitorWidth); //1920
  //println("monitorHeight: ", monitorHeight); //1080

  if (calibrationMode > 0) {

    //move toio to standby positions while calibrating
    aimCubeSpeed(0, 100, 100);
    aimCubeSpeed(1, 600, 250);
    detectBall(false);
  } else {


    if (phase1_seeBall == false) {
      //Phase 1. Check if the camera sees a ball
      println("Phase 1. Check if the camera sees a ball");

      //call detectBall function
      if (detectBall(false)) {
        phase1_seeBall = true;
      } else {
        phase1_seeBall = false;
      }
    } else if (phase1_seeBall == true && phase2_ballSticks == false) {

      //Phase 2. Check if ball sticks
      println("Phase 2. Check if ball sticks");
      println("We may need to adjust global_avgDepth > 710 depending on the environment");

      if (startTime == false) {
        time = millis();
        startTime = true;
      } else {

        if (startTime2 == false) {
          time2 = millis();
          startTime2 = true;
        } else {

          if (millis() > time2 + 50) { //every 50 millisecond record a point
            startTime2 = false;

            //detect ball with true flag will also record the ball's travel history
            detectBall(true);
          }
        }

        if (millis() > time + 500) { //time waited for the ball to stick properly
          startTime = false;

          //detect the location of the ball
          if (detectBall(false)) {
            global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
            global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

            //use depth information of the ball to check if a ball sticks or not

            println("global_avgDepth: ", global_avgDepth);

            if (global_avgDepth > 710) { //we may need to adjust this number depending on the environment

              phase2_ballSticks = false;
              phase1_seeBall = false;
              ufo_instruction = "Nice try! Throw carefully!" ;
            }

            //draw a circle at the tracked pixel
            fill(255);
            strokeWeight(4.0);
            stroke(0);
            ellipse(global_avgX, global_avgY, 20, 20);

            hitX = map(global_scaledX, 32, 614+32, 0, monitorWidth); //store the position of hitX

            println("global_scaledX: ", global_scaledX);
            println("hitX: ", hitX);



            //find ball velocity and angle
            //depthDiff  = global_dHist[global_dHist.length-1]-global_dHist[int(global_dHist.length/2)]; // this value should be positive
            //xDiff  = global_xHist[global_xHist.length-1]-global_xHist[int(global_xHist.length/2)];

            //throwDegree = degrees(atan2(depthDiff, xDiff));
            throwDegree = degrees(atan2(3, 4));

            //caculate velocity, we can just find the velocty of the five points after mid point
            avgZVelocity = ((global_dHist[int(global_dHist.length/2)] - global_dHist[0]))/3;
            avgXVelocity = ((global_xHist[int(global_xHist.length/2)] - global_xHist[0]))/3;

            phase2_ballSticks = true;

            //upper left corber coordinate is (32, 32) and lower right corver is (646, 465)
            if (global_scaledX > 596 || global_scaledY > 415 || global_scaledY < 82 || global_scaledX < 82) {
              //this is the case when ball sticks on the edge of the ceiling so that robot can't travel to drop it
              //in this case, a user needs to manually grab the ball and re-throw it again
              phase2_ballSticks = false;
              phase1_seeBall = false;
              ufo_instruction = "Nice try! Throw carefully!" ;
            }
          } else {

            //this is the case when ball enters the camera but didn't stick
            //it is most likely causes by a user throwing to hard or too soft
            phase2_ballSticks = false;
            phase1_seeBall = false;
            ufo_instruction = "Nice try! Throw carefully!" ;
          }
        }
      }
    } else if (phase2_ballSticks == true && phase3_facePushLocation == false) {

      //Phase 3. Let toio prong side face the ball
      //This is an important step because we want the prong side to face the ball or else toio might use the wedge side to approach the object

      println("Phase 3. Let toio prong side face the ball");

      //this flag is used to tell the second window that the ball hits and sticks on the ceilling
      //so that the vertical screen can show the trajectory of the ball
      if (detectBall(false)) {
        ufo_flag_hitTarget = true;
      } else {
        println("Ball did not stick check point in Phase 3");
        ufo_instruction = "Nice try! Throw carefully!" ;
        ufo_flag_killBall = true;
        jumpToPhase1();
      }

      if (ufo_flag_killBall == false) {
        //we need to record the angle between the pushing toio and the ball location
        if (flag_recordPushingToioAndBallAngle == false) {

          //here we always assume that the ball sticks in between the spaces between the toio robots
          //TODO: please check the algorithm here!!

          if (global_scaledX < pushx) {
            //record that cube 0 will push
            pushToio = 0;

            //turnDegree0 is to what degrees that toio0 needs to spin to so that it will face its front (wedge) side to ball location
            turnDegree0 = degrees(atan2(global_scaledY-cubes[0].y, global_scaledX-cubes[0].x));
            if (turnDegree0 < 0) {
              turnDegree0+=360;
            }
          } else {
            //record that cube 1 will push
            pushToio = 1;

            //turnDegree1 is to what degrees that toio1 needs to spin to so that it will face its front (wedge) side to ball location
            turnDegree1 = degrees(atan2(global_scaledY-cubes[1].y, global_scaledX-cubes[1].x));

            if (turnDegree1 < 0) {
              turnDegree1+=360;
            }
          }

          flag_recordPushingToioAndBallAngle = true;
        } else {


          if (pushToio == 0) {
            // we rotate the cube0 180 degress so that now its back (prong) side is facing toward the ball location
            if (rotateCube(0, turnDegree0-180)) {
              phase3_facePushLocation = true;
            }
          } else {
            // we rotate the cube1 180 degress so that now its back (prong) side is facing toward the ball location
            if (rotateCube(1, turnDegree1-180)) {
              phase3_facePushLocation = true;
            }
          }
        }
      }
    } else if (phase3_facePushLocation == true && phase4_travelToBallToPush == false) {

      //Phase 4. Let pushing toio travel to ball (preparing to push)
      println("Phase 4. Let pushing toio travel to ball (preparing to push)");


      if (pushToio == 0) {
        //cube 0 is pushing so it travels to the ball location

        aimCubeSpeed(0, global_scaledX, global_scaledY); //may need to control distance

        if (abs(cubes[0].x - global_scaledX) < distanceBetweenPushingToioAndBall && abs(cubes[0].y - global_scaledY) < distanceBetweenPushingToioAndBall) {

          phase4_travelToBallToPush = true;
        }
      } else {
        //cube 1 is pushing so it travels to the ball location

        aimCubeSpeed(1, global_scaledX, global_scaledY);

        if (abs(cubes[1].x - global_scaledX) < distanceBetweenPushingToioAndBall && abs(cubes[1].y - global_scaledY) < distanceBetweenPushingToioAndBall) {

          phase4_travelToBallToPush = true;
        }
      }
    } else if (phase4_travelToBallToPush == true && phase5_rotateBallToPushLocation == false) {

      //Phase 5. Pushing toio rotates the ball such that they face the push location
      println("Phase 5. Pushing toio rotates the ball such that they face the push location");

      if (pushToio == 0) {
        //cube0 is the pushing toio and rotates itself with the ball facing push location

        if (rotateCubeMax(0, turnDegree1-180)) {
          phase5_rotateBallToPushLocation = true;
        }
      } else {
        //cube1 is the pushing toio and rotates itself with the ball facing push location
        if (rotateCubeMax(1, turnDegree1-180)) {
          phase5_rotateBallToPushLocation = true;
        }
      }
    } else if (phase5_rotateBallToPushLocation == true && phase6_pushDone == false) {

      //Phase 6. Pushing toio pushes the ball to the push location
      println("Phase 6. Pushing toio pushes the ball to the push location");

      if (pushToio == 0) {
        //cube0 is the pushing toio and pushes the ball to push location
        aimCubeSpeed(0, pushx, pushy);
        if (abs(cubes[0].x - pushx) < distanceBetweenPushingToioAndPushLocation && abs(cubes[0].y - pushy) < distanceBetweenPushingToioAndPushLocation) {
          phase6_pushDone = true;
        }
      } else {
        //cube1 is the pushing toio and pushes the ball to push location
        aimCubeSpeed(1, pushx, pushy);
        if (abs(cubes[1].x - pushx) < distanceBetweenPushingToioAndPushLocation && abs(cubes[1].y - pushy) < distanceBetweenPushingToioAndPushLocation) {
          phase6_pushDone = true;
        }
      }
    } else if (phase6_pushDone == true && phase7_findTangentPoints == false && global_scaledX != global_ball_x
      && global_scaledY != global_ball_y) { //TODO: why do we need global_scaledX != global_ball_x && global_scaledY != global_ball_y again?

      //Phase 7. Calculate prep location for both toios to travel
      println("Phase 7. Calculate prep location for both toios to travel");


      //We need to re-identify where the ball is now
      if (flag_findPushedBallLocation == false) {

        //we must find a ball because we just push the ball to its pushed location
        if (detectBall(false)) {
          global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);
          global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);

          //draw a circle at the tracked pixel
          fill(255);
          strokeWeight(4.0);
          stroke(0);
          ellipse(global_avgX, global_avgY, 20, 20);
        } else {
          println("Special case: ball actually did not stick in Phase 7");

          //this would happen if we let the ball reached similar height to the ceiling but didn't stick
          //so we just to the last phase

          //we need to kill the particle that falsely show up in the monitor, and jump to phase 10 for reset
          ufo_flag_killBall = true;
          //jump to phase 10
          jumpToPhase10();
        }

        flag_findPushedBallLocation = true;
      }

      //If we are not killBall due to it not sticking, we can should run the following block of code
      if (ufo_flag_killBall == false) {
        //After finding the ball's new position (which should be close to the push location), we find the prep location for both toios to travel
        if (flag_needBackout == false) {
          //If toios don't need to backout, we call findLocation() to find the prep location

          if (findLocation() == true) {
            //If we find the prep location, we move on to the next phase
            phase7_findTangentPoints = true;
          } else {
            //If we can't find the prep locations, that means that at least one toio is too close the ball, so we need to move them out
            flag_needBackout = true;
          }
        } else {

          //By calling findbackoutLocation(), we can move toio back (on the line formed by toio and the ball)
          println("Back out toio because they are within radius");

          if (flag_prepareBackout == false) {
            if (detectBall(false)) {
              global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
              global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382
              findbackoutLocation(0);
              findbackoutLocation(1);

              flag_prepareBackout = true;
            }
          } else {

            aimCubeSpeed(0, global_backoutx0, global_backouty0);
            aimCubeSpeed(1, global_backoutx1, global_backouty1);

            if (abs(cubes[0].x - global_backoutx0) < 15 && abs(cubes[0].y - global_backouty0) < 15 && abs(cubes[1].x - global_backoutx1) < 15 && abs(cubes[1].y - global_backouty1) < 15 ) {
              //when toios finally backout, we set flag_needBackout to false so that we can once again call findLocation() to find the prep locaiton
              flag_needBackout = false;
            }
          }
        }
      }
    } else if (phase7_findTangentPoints == true && phase8_toioTravelToPrepLocation == false) {

      //Phase 8. Both toios travel to prep locations
      println("Phase 8. Both toios travel to prep locations");

      if (global_closer_toio_id == 0) {
        //If closer toio is cube0, we let it travel to global_finalx, global_finaly and let cube1 travel to global_xprime, global_yprime.
        aimCubeSpeed(0, global_finalx, global_finaly);
        aimCubeSpeed(1, global_xprime, global_yprime);
        if (abs(cubes[0].x - global_finalx) < 15 && abs(cubes[0].y - global_finaly) < 15 && abs(cubes[1].x - global_xprime) < 15 && abs(cubes[1].y - global_yprime) < 15 ) {

          phase8_toioTravelToPrepLocation = true;

          //ufo_flag_nextBall controls when the next ball in the vertical screen shoould appear
          ufo_flag_nextBall = true;
        }
      } else {

        //If closer toio is cube1, we let it travel to global_finalx, global_finaly and let cube0 travel to global_xprime, global_yprime.
        aimCubeSpeed(1, global_finalx, global_finaly);
        aimCubeSpeed(0, global_xprime, global_yprime);
        if (abs(cubes[1].x - global_finalx) < 15 && abs(cubes[1].y - global_finaly) < 15 && abs(cubes[0].x - global_xprime) < 15 && abs(cubes[0].y - global_yprime) < 15) {

          phase8_toioTravelToPrepLocation = true;


          //ufo_flag_nextBall controls when the next ball in the vertical screen shoould appear
          ufo_flag_nextBall = true;
        }
      }
    } else if (phase8_toioTravelToPrepLocation == true && phase9_rotateToDrop == false) {

      //Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation
      println("Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation");

      //We arbitrarily let 0 use the front (wedge) and let 1 use the back (prong)

      if (flag_recordToioAndBallAngle == false) {
        turnDegree0 = degrees(atan2(global_scaledY-cubes[0].y, global_scaledX-cubes[0].x));

        if (turnDegree0 < 0) {
          turnDegree0+=360;
        }

        turnDegree1 = degrees(atan2(global_scaledY-cubes[1].y, global_scaledX-cubes[1].x));

        if (turnDegree1 < 0) {
          turnDegree1+=360;
        }

        flag_recordToioAndBallAngle = true;
      } else {

        //rotate cube0 first
        if (abs(cubes[0].deg - turnDegree0) < 10) {
          flag_rotate0 = true;
        } else {
          rotateCube(0, turnDegree0);
        }

        //based on cube0 degree, we rotate cube1
        if (abs(cubes[1].deg - (turnDegree1-180)) < 10 || abs(cubes[1].deg - (turnDegree1-180+360)) < 10) {

          flag_rotate1 = true;
        } else {

          rotateCube(1, turnDegree1-180); //cube 1 use chopstick side
        }

        //once both toios finish rotating, we move on to the next phase
        if (flag_rotate0 && flag_rotate1) {

          phase9_rotateToDrop = true;
        }
      }
    } else if (phase9_rotateToDrop == true && phase10_dropSucceed == false) {

      //Phase 10. Toio converge to drop the object
      println("Phase 10. Toio converge to drop the object");

      if (startTime == false) {
        time = millis();
        startTime = true;
      } else {

        if (millis() > time + 3000) { //wait for virtual ball to drop

          //both toios travel to the ball's location
          aimCubeSpeed(0, global_scaledX, global_scaledY);
          aimCubeSpeed(1, global_scaledX, global_scaledY);
        }
      }

      //we are finally done with all the phases after the toios drop the ball
      if (abs(cubes[0].x - global_scaledX) < convergeDistance && abs(cubes[1].x - global_scaledX) < convergeDistance &&
        abs(cubes[0].y - global_scaledY) < convergeDistance &&  abs(cubes[1].y - global_scaledY) < convergeDistance) {

        phase10_dropSucceed = true;
        startTime = false;
      }
    } else if (phase10_dropSucceed == true) {

      //Phase 11. Reset all of the flags so that we can start the algorithm again

      if (startTime == false) {
        time = millis();
        startTime = true;
      } else {

        if (millis() > time + 1000) {

          aimCubeSpeed(0, 100, 100);
          aimCubeSpeed(1, 600, 250);

          if (abs(cubes[0].x - 100) < 15 && abs(cubes[1].x - 600) < 15 &&
            abs(cubes[0].y - 100) < 15 &&  abs(cubes[1].y - 250) < 15) {

            //reset phase flags to false
            phase1_seeBall = false; //phase 1
            phase2_ballSticks = false; //phase 2
            phase3_facePushLocation = false; //phase 3
            phase4_travelToBallToPush = false; //phase 4
            phase5_rotateBallToPushLocation = false; //phase 5
            phase6_pushDone = false; //phase 6
            phase7_findTangentPoints = false; //phase 7
            phase8_toioTravelToPrepLocation = false; //phase 8
            phase9_rotateToDrop = false; //phase 9
            phase10_dropSucceed = false; //phase 10

            //reset flags
            flag_rotate0 = false;
            flag_rotate1 = false;
            flag_recordToioAndBallAngle = false;
            flag_recordPushingToioAndBallAngle = false;
            flag_prepareBackout = false;
            flag_findPushedBallLocation = false;


            xHist = new float[] {};
            yHist = new float[] {};
            dHist = new float[] {};
            turnDegree1 = 0;
            turnDegree0 = 0;

            //reset flags in SecondApplet
            ufo_flag_addParticle = false;
            ufo_flag_nextBall = false;
            ufo_flag_hitTarget = false;
            ufo_flag_killUFO = false;

            ufo_instruction = "Throw ball! Hit UFO!";

            startTime = false; //newly added
          }
        }
      }
    }
  }




  //did we lost some cubes?
  for (int i=0; i<nCubes; ++i) {
    // 500ms since last update
    if (cubes[i].lastUpdate < now - 1500 && cubes[i].isLost==false) {
      cubes[i].isLost= true;
    }
  }
}

//helper functions to drive the cubes
boolean rotateCubeMax(int id, float ta) {
  float diff = ta-cubes[id].deg;
  if (diff>180) diff-=360;
  if (diff<-180) diff+=360;
  if (abs(diff)<20) return true;
  int dir = 1;
  int strength = int(abs(diff) / 10);
  strength = 1;//
  if (diff<0)dir=-1;
  //float left = ( 10*(1*strength)*dir);
  //float right = (-10*(1+strength)*dir);

  float left = (12*(1*strength)*dir);
  float right = (-12*(1*strength)*dir);


  //println("rotate speed", id, left, right); //maybe the speed here is kinda slow and can adjust the constant
  int duration = 300;
  motorControl(id, left, right, duration);
  //println("rotate false "+diff +" "+ id+" "+ta +" "+cubes[id].deg);
  return false;
}
