//This is the main ThrowIO code
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

void jumpToPhase3() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = false; //phase 3
  phase4_travelToBallToPush = false; //phase 4
  phase5_rotateBallToPushLocation = false; //phase 5
  phase6_pushDone = false; //phase 6
  phase7_findTangentPoints = false; //phase 7
  phase8_toioTravelToPrepLocation = false; //phase 8
  phase9_rotateToDrop = false; //phase 9
  phase10_dropSucceed = false; //phase 10
}

void jumpToPhase7() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
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

void jumpToPhase11() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
  phase7_findTangentPoints = true; //phase 7
  phase8_toioTravelToPrepLocation = true; //phase 8
  phase9_rotateToDrop = true; //phase 9
  phase10_dropSucceed = true; //phase 10
}
void story_saveOrangePosition(float orangex1, float orangey1, float orangex2, float orangey2, int flyToOrange, int dropFruit, int nextOrange) {
  table = new Table();

  table.addColumn("OrangeX1");
  table.addColumn("OrangeY1");
  table.addColumn("OrangeX2");
  table.addColumn("OrangeY2");
  table.addColumn("flyToOrange");
  table.addColumn("dropFruit");
  table.addColumn("nextOrange");

  TableRow newRow = table.addRow();
  newRow.setFloat("OrangeX1", orangex1);
  newRow.setFloat("OrangeY1", orangey1);
  newRow.setFloat("OrangeX2", orangex2);
  newRow.setFloat("OrangeY2", orangey2);
  newRow.setInt("flyToOrange", flyToOrange);
  newRow.setInt("dropFruit", dropFruit);
  newRow.setInt("nextOrange", nextOrange);

  saveTable(table, "../data/position.csv");
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

    ufo_file = new SoundFile(this, "explosion.wav");
    cannon_file = new SoundFile(this, "cannon.wav");

    //set starting position for the robots
    startPositionX1 = 100;
    startPositionY1 = 100;
    startPositionX2 = 600;
    startPositionY2 = 250;

    pushx = 360; //400
    pushy = 180; //300
  } else if (applicationMode == "story") {
    println("launching immersive storytelling application");

    //save orange positions
    story_saveOrangePosition(story_orangex1, story_orangey1, story_orangex2, story_orangey2, 0, 0, story_orangeCount);

    //this is where the robot will push the ball to
    pushx = story_orangex1+50;
    pushy = story_orangey1+30; //TODO: needs to figure out a way to find where the robot should move so that the pushed ball in on top of the orange

    //set starting position for the robots
    startPositionX1 = 100;
    startPositionY1 = 100;
    startPositionX2 = 600;
    startPositionY2 = 250;
  } else if (applicationMode == "storage") {

    //set the position for storing
    pushx = storage_shelfX;
    pushy = storage_shelfY;


    //set starting position for the robots
    startPositionX1 = 100;
    startPositionY1 = 245;
    startPositionX2 = 600;
    startPositionY2 = 250;
  } else if (applicationMode == "practice") {

    //set starting position for the robots
    startPositionX1 = 100;
    startPositionY1 = 200;
    startPositionX2 = 550;
    startPositionY2 = 210;
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
    aimCubeSpeed(0, startPositionX1, startPositionY1);
    aimCubeSpeed(1, startPositionX2, startPositionY2);


    detectBall(false);
  } else {


    if (phase1_seeBall == false) {



      //Phase 1. Check if the camera sees a ball
      println("Phase 1. Check if the camera sees a ball");

      if (applicationMode == "story") {
        //since the experimentor will just click on where the ball sticks, we will just skip to phase3
        jumpToPhase3();
      } else if (applicationMode == "ufo" || (applicationMode == "storage" && storage_status == "store")) {
        //applicationMode == "ufo" and "storage"

        //call detectBall function
        if (detectBall(false)) {
          phase1_seeBall = true;
        } else {
          phase1_seeBall = false;
        }
      } else if ((applicationMode == "storage" && storage_status == "retrieve")) {

        smallBox_w = (mouseXLocationList[1] - mouseXLocationList[0])/2.5;
        smallBox_h = (mouseYLocationList[1] - mouseYLocationList[0])/2;
        handDetectStartAreaX = mouseXLocationList[0]+(mouseXLocationList[1] - mouseXLocationList[0])/2;
        handDetectStartAreaY = mouseYLocationList[0]+smallBox_h/2;
        handDetectEndAreaX = handDetectStartAreaX+smallBox_w;
        handDetectEndAreaY = handDetectStartAreaY+smallBox_h;

        noFill();
        stroke(255, 0, 0);
        rect(handDetectStartAreaX, handDetectStartAreaY, smallBox_w, smallBox_h);

        findHand(handDetectStartAreaX, handDetectStartAreaY, handDetectEndAreaX, handDetectEndAreaY);

        // Let's draw the raw location
        PVector v1 = storage_loc;

        //draw on main camera
        fill(50, 100, 250, 200);
        noStroke();
        ellipse(v1.x, v1.y, 20, 20);

        //draw on depth camera
        noStroke();
        ellipse(v1.x+640, v1.y, 20, 20);

        // Let's draw the "lerped" location
        PVector v2 = storage_lerpedLoc;
        fill(100, 250, 50, 200);
        noStroke();
        ellipse(v2.x, v2.y, 20, 20);

        //draw on depth camera
        noStroke();
        ellipse(v2.x+640, v2.y, 20, 20);

        if (v2.x > handDetectStartAreaX &&  v2.x < handDetectEndAreaX && v2.y > handDetectStartAreaY && v2.y < handDetectEndAreaY) {
          //record hand position
          handPositionX = v2.x;
          handPositionY = v2.y;

          //translate it to toio location as push location
          pushx = map(handPositionX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
          pushy = map(handPositionY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382


          println("handPositionX: ", handPositionX);
          println("handPositionY: ", handPositionY);
          println("pushx: ", pushx);
          println("pushy: ", pushy);

          //phase1 complete (it is technically see hand instead of see ball)
          phase1_seeBall = true;
        }
      } else if (applicationMode == "practice") {

        if (detectBall(false)) {

          phase1_seeBall = true;
        } else {
          phase1_seeBall = false;
        }
      } else {
        //quick debug area (set applicationMode to "debug")
        //print anything you want here!

        //as long as you don't make phase 1 flag true, then we can debug here!
      }
    } else if (phase1_seeBall == true && phase2_ballSticks == false) {

      //Phase 2. Check if ball sticks
      //applicationMode == "ufo" and "storage" use this phase
      println("Phase 2. Check if ball sticks");
      println("We may need to adjust global_avgDepth > 710 depending on the environment");
      if (applicationMode == "ufo") {
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
      } else if (applicationMode == "storage") {

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

          if (millis() > time + 2000) { //time waited for the ball to stick properly
            startTime = false;

            //detect the location of the ball
            if (detectBall(false)) {
              global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
              global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382


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
              }
            } else {

              //this is the case when ball enters the camera but didn't stick
              //it is most likely causes by a user throwing to hard or too soft
              phase2_ballSticks = false;
              phase1_seeBall = false;
            }
          }
        }
      } else if (applicationMode == "practice") {

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

          if (millis() > time + 2000) { //time waited for the ball to stick properly
            startTime = false;

            //detect the location of the ball
            if (detectBall(false)) {
              global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
              global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382


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

              //phase2_ballSticks = true;
              jumpToPhase7();


              //upper left corber coordinate is (32, 32) and lower right corver is (646, 465)
              if (global_scaledX > 596 || global_scaledY > 415 || global_scaledY < 82 || global_scaledX < 82) {
                //this is the case when ball sticks on the edge of the ceiling so that robot can't travel to drop it
                //in this case, a user needs to manually grab the ball and re-throw it again
                phase2_ballSticks = false;
                phase1_seeBall = false;
              }
            } else {

              //this is the case when ball enters the camera but didn't stick
              //it is most likely causes by a user throwing to hard or too soft
              phase2_ballSticks = false;
              phase1_seeBall = false;
            }
          }
        }
      }
    } else if (phase2_ballSticks == true && phase3_facePushLocation == false) {

      //Phase 3. Let toio prong side face the ball
      //This is an important step because we want the prong side to face the ball or else toio might use the wedge side to approach the object

      println("Phase 3. Let toio prong side face the ball");

      if (applicationMode == "ufo") {

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
      } else if (applicationMode == "story") {

        //if the experimentor sees that the ball thrown by the user is stuck, he will use the mouse to click on the ball's location in the camera window
        //By doing so, (1) we can tell the robot where to travel for pushing (2) we can also tell the bird to start flying to the orange

        println("Story: waiting the experimentor click on stuck ball in the camera...");
        if (story_flag_trackedStuckBall == true) {

          if (story_orangeCount == 1) {
            println("story_orangeCount: ", story_orangeCount);
            story_saveOrangePosition(story_orangex1, story_orangey1, story_orangex2, story_orangey2, 0, 0, story_orangeCount); //tell the immersive screen to start drop orange

            //update new pushx and pushy using the next orange location
            pushx = story_orangex2;
            pushy = story_orangey2+30; //TODO: need to know the position for robot to travel such that it will pushed the ball to the orange
          }


          //we tell the bird to move to the orange
          story_saveOrangePosition(story_orangex1, story_orangey1, story_orangex2, story_orangey2, 1, 0, story_orangeCount);

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
      } else if (applicationMode == "storage") {

        //this flag is used to tell the second window that the ball hits and sticks on the ceilling
        //so that the vertical screen can show the trajectory of the ball
        if (detectBall(false)) {
          if (storage_status == "store") {
            //set the position for storing
            pushx = storage_shelfX;
            pushy = storage_shelfY;
          } else {
            //set the pushed position for dropping
            pushx = storage_dropLocationX;
            pushy = storage_dropLocationY;
          }

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
        } else {
          println("Ball did not stick check point in Phase 3");
          jumpToPhase1();
        }
      }
    } else if (phase3_facePushLocation == true && phase4_travelToBallToPush == false) {

      //Phase 4. Let pushing toio travel to ball (preparing to push)
      //applicationMode == "ufo" and "story" "storage" use this phase
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
      //applicationMode == "ufo" "story" "storage" use this phase
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
      //applicationMode == "ufo" "story" "storage" use this phase
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
    } else if (phase6_pushDone == true && phase7_findTangentPoints == false && global_scaledX != global_ball_x && global_scaledY != global_ball_y) { //TODO: why do we need global_scaledX != global_ball_x && global_scaledY != global_ball_y again?

      //Phase 7. Calculate prep location for both toios to travel
      println("Phase 7. Calculate prep location for both toios to travel");

      if (applicationMode == "ufo") {
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
        //If we are not killBall due to it not sticking, we can run the following block of code
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
      } else if (applicationMode == "story") {

        println("Story: waiting the experimentor click on pushed ball in the camera...");
        if (story_flag_trackedPushedBall == true) {

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
              //if (detectBall(false)) {
              //  global_scaledX = map(global_avgX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
              //  global_scaledY = map(global_avgY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382
              //  findbackoutLocation(0);
              //  findbackoutLocation(1);

              //  flag_prepareBackout = true;
              //}

              findbackoutLocation(0);
              findbackoutLocation(1);
              flag_prepareBackout = true;
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
      } else if (applicationMode == "storage") {
        if (storage_status == "store") {
          //storing
          //it is fine if pushing toio did not backout precisely
          jumpToPhase11();
        } else {
          //retrieving

          //Note: in our application, the ball is pushed from left to right, once it is done pushing, the other toio should still be at the right of the ball

          //set prep location for pushing toio (which will be 0)
          global_finalx = cubes[0].x;
          global_finaly = cubes[0].y;

          //set prep location for the other toio (which will be 1)
          global_xprime = cubes[1].x;
          global_yprime = cubes[0].y;

          phase7_findTangentPoints = true;


          //Step3. Other toio rotates such that the wedge side faces to the pushing toio

          //Step4. Other toio approaches the pushing toio to drop the object
        }
      } else if (applicationMode == "practice") {
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


      if (applicationMode == "ufo" || applicationMode == "story") {
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
      } else if (applicationMode == "storage" ) {
        //pushing toio is 0, and other toio is 1
        //Step1. Other toio travel to the pushing toio y location
        aimCubeSpeed(0, global_finalx, global_finaly);
        aimCubeSpeed(1, global_xprime, global_yprime);


        if (abs(cubes[0].x - global_finalx) < 15 && abs(cubes[0].y - global_finaly) < 15 && abs(cubes[1].x - global_xprime) < 15 && abs(cubes[1].y - global_yprime) < 15 ) {

          phase8_toioTravelToPrepLocation = true;
        }
      } else if (applicationMode == "practice") {
        if (global_closer_toio_id == 0) {
          //If closer toio is cube0, we let it travel to global_finalx, global_finaly and let cube1 travel to global_xprime, global_yprime.
          aimCubeSpeed(0, global_finalx, global_finaly);
          aimCubeSpeed(1, global_xprime, global_yprime);
          if (abs(cubes[0].x - global_finalx) < 15 && abs(cubes[0].y - global_finaly) < 15 && abs(cubes[1].x - global_xprime) < 15 && abs(cubes[1].y - global_yprime) < 15 ) {

            phase8_toioTravelToPrepLocation = true;
          }
        } else {

          //If closer toio is cube1, we let it travel to global_finalx, global_finaly and let cube0 travel to global_xprime, global_yprime.
          aimCubeSpeed(1, global_finalx, global_finaly);
          aimCubeSpeed(0, global_xprime, global_yprime);
          if (abs(cubes[1].x - global_finalx) < 15 && abs(cubes[1].y - global_finaly) < 15 && abs(cubes[0].x - global_xprime) < 15 && abs(cubes[0].y - global_yprime) < 15) {

            phase8_toioTravelToPrepLocation = true;
          }
        }
      }
    } else if (phase8_toioTravelToPrepLocation == true && phase9_rotateToDrop == false) {

      //Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation
      println("Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation");

      if (applicationMode == "ufo" || applicationMode == "story") {
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
      } else if (applicationMode == "storage") {

        //Step2. Other toio record angle between pushing toio and itself

        //we should just ask pushing toio turn to face 0 degrees, and other toio turn to face 180 degrees

        //rotate cube0 first
        if (abs(cubes[0].deg - 180) < 5) {
          flag_rotate0 = true;
        } else {
          rotateCube(0, 180);
        }

        //based on cube0 degree, we rotate cube1
        if (abs(cubes[1].deg - 180) < 5) {

          flag_rotate1 = true;
        } else {

          rotateCube(1, 180); //cube 1 use chopstick side
        }

        //once both toios finish rotating, we move on to the next phase
        if (flag_rotate0 && flag_rotate1) {

          phase9_rotateToDrop = true;
        }
      } else if (applicationMode == "practice") {

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
      }
    } else if (phase9_rotateToDrop == true && phase10_dropSucceed == false) {

      //Phase 10. Toio converge to drop the object
      println("Phase 10. Toio converge to drop the object");
      if (applicationMode == "ufo") {

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
      } else if (applicationMode == "story") {

        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {

          if (millis() > time + 500) { //wait for virtual ball to drop

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
          story_saveOrangePosition(story_orangex1, story_orangey1, story_orangex2, story_orangey2, 1, 1, story_orangeCount);
        }
      } else if (applicationMode == "storage") {

        if (startTime == false) {

          time = millis();
          startTime = true;
          storage_recordPushingX = cubes[0].x;
          storage_recordPushingY = cubes[0].y;
        } else {

          if (millis() > time + 500) { //wait for the ball with key to drop

            //only other toio (cube1) travel toward the pushing toio
            aimCubeSpeed(1, storage_recordPushingX+convergeDistance, storage_recordPushingY);

            //the pushing toio apply forces to remain at the same location (we secret increase the speed)
            aimCubeSpeed(0, storage_recordPushingX+5, storage_recordPushingY);
          }
        }


        //we are finally done with all the phases after the toios drop the ball
        if (abs(storage_recordPushingX+convergeDistance - cubes[1].x) < 15 &&
          abs(storage_recordPushingY - cubes[1].y) < 15) {

          phase10_dropSucceed = true;
          startTime = false;
        }
      } else if (applicationMode == "practice") {
        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {

          if (millis() > time + 500) { //wait for virtual ball to drop

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
      }
    } else if (phase10_dropSucceed == true) {

      //Phase 11. Reset all of the flags so that we can start the algorithm again
      println("Phase 11. Reset all of the flags so that we can start the algorithm again");
      if (startTime == false) {
        time = millis();
        startTime = true;
      } else {

        if (millis() > time + 1000) {

          aimCubeSpeed(0, startPositionX1, startPositionY1);
          aimCubeSpeed(1, startPositionX2, startPositionY2);

          if (abs(cubes[0].x - startPositionX1) < 15 && abs(cubes[1].x - startPositionX2) < 15 &&
            abs(cubes[0].y - startPositionY1) < 15 &&  abs(cubes[1].y - startPositionY2) < 15) {

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

            story_flag_trackedStuckBall = false;
            story_flag_trackedPushedBall = false;

            story_orangeCount+=1;

            startTime = false; //newly added


            if (applicationMode == "storage" && storage_status == "store") {
              storage_status = "retrieve";
              pushx = storage_shelfX;
              pushy = storage_shelfY;
              storage_loc.x = 0;
              storage_loc.x = 0;
              storage_lerpedLoc.x = 0;
              storage_lerpedLoc.y = 0;
            } else if (applicationMode == "storage" && storage_status == "retrieve") {
              storage_status = "store";
            }
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
