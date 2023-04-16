//void settings() {
//  //size(1280, 720, P3D);
//}


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

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);

  //set starting position for the robots
  start_positions = setInitialRobotLocation(applicationMode);
  start_position_0 = start_positions[0];
  start_position_1 = start_positions[1];

  println("start_position_0.x: ", start_position_0.x);
  println("start_position_1.x: ", start_position_1.x);

  //camera
  size(1280, 720);
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();


  loadCalibration();

  if (cameraDetectionMode == "ir") {
    ir = true;
  }
}


void draw() {
  //START DO NOT EDIT

  //the motion function sends a constant request for motion data from a toio ID
  //motionRequest(0);
  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  drawDebugWindow();
  //fill(255);
  //rect(34, 35, 644, 466);

  //draw the cubes
  for (int i = 0; i < cubes.length; ++i) {
    if (cubes[i].isLost==false) {
      pushMatrix();
      translate(cubes[i].x, cubes[i].y);
      rotate(cubes[i].deg * PI/180);
      rect(-10, -10, 20, 20);
      rect(0, -5, 20, 10);
      popMatrix();
    }
  }

  //END DO NOT EDIT


  if (calibrationMode > 0) {

    println("mouseXLocationList[0]: ", mouseXLocationList[0]);
    println("mouseXLocationList[1]: ", mouseXLocationList[1]);
    println("mouseYLocationList[0]: ", mouseYLocationList[0]);
    println("mouseYLocationList[1]: ", mouseYLocationList[1]);


    //move toio to standby positions while calibrating
    aimCubeSpeed(0, start_position_0.x, start_position_0.y);
    aimCubeSpeed(1, start_position_1.x, start_position_1.y);

    if (cameraDetectionMode == "color") {
      println("In color detect mode");
      //colorDetecBall(false);
      Point color_tracking_point = colorBlobDetectBall(global_trackColor);
      if (color_tracking_point != null) {
        println("color_tracking_point x :", color_tracking_point.x);
        println("color_tracking_point y:", color_tracking_point.y);

        ellipse(color_tracking_point.x, color_tracking_point.y, 20, 20);
      } else {

        println("no values");
      }
    } else if (cameraDetectionMode == "ir") {

      println("In IR detect mode");
      Point ir_tracking_point = irDetectBall();
      if (ir_tracking_point != null) {
        println("ir_tracking_point x :", ir_tracking_point.x);
        println("ir_tracking_point y:", ir_tracking_point.y);

        ellipse(ir_tracking_point.x, ir_tracking_point.y, 20, 20);
      } else {

        println("no values");
      }
    } else {
      //mouse tracking
      println("In mouse detect mode");
    }
  } else {

    //phase starts here
    if (phase1_seeBall == false) {

      //Phase 1. Check if the camera sees a ball
      phaseLabel = "Phase 1/11. Check if the camera sees a ball";
      println(phaseLabel);


      if (applicationMode == "practice") {
        Point ball_point;
        if (cameraDetectionMode == "color") {
          ball_point = detectBallWithColorOrIR("color", global_trackColor);

          if (ball_point != null) {
            phase1_seeBall = true;
          } else {
            phase1_seeBall = false;
          }
        } else if (cameraDetectionMode == "ir") {

          ball_point = detectBallWithColorOrIR("ir", global_trackColor);


          if (ball_point != null) {
            println("mouseXLocationList[0]: ", mouseXLocationList[0]);
            println("mouseXLocationList[1]: ", mouseXLocationList[1]);
            println("mouseYLocationList[0]: ", mouseYLocationList[0]);
            println("mouseYLocationList[1]: ", mouseYLocationList[1]);
            phase1_seeBall = true;

            exit();
          } else {
            phase1_seeBall = false;
          }
        } else {
          //mouse mode
          //If the experimentor sees that the ball thrown by the user is stuck,
          //they will use the mouse to click on the ball's location in the camera window
          println("Practice: waiting the experimentor click on stuck ball in the camera...");

          if (practice_flag_trackedStuckBall == true) {
            jumpToPhase7();
          }
        }
      }
    } else if (phase1_seeBall == true && phase2_ballSticks == false) {

      //Phase 2. Check if ball sticks
      phaseLabel = "Phase 2/11. Check if ball sticks";
      println(phaseLabel);

      //if (cubes[2].isLost == false) {
      //  //record the ball location
      //  global_ball_toio_coord = new Point(cubes[2].x, cubes[2].y);
      //  jumpToPhase7(); // here we check if the toio ball sticks to the ceiling
      //}

      if (applicationMode == "practice") {

        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {

          //if (startTime2 == false) {
          //  time2 = millis();
          //  startTime2 = true;
          //} else {

          //  if (millis() > time2 + 50) { //every 50 millisecond record a point
          //    startTime2 = false;

          //    //detect ball with true flag will also record the ball's travel history
          //    detectBall(true);
          //  }
          //}

          if (millis() > time + 2000) { //time waited for the ball to stick properly
            startTime = false;


            //detect the location of the ball
            Point ball_point;
            if (cameraDetectionMode == "color") {
              ball_point = detectBallWithColorOrIR("color", global_trackColor);
            } else {
              //cameraDetectionMode == "ir"
              ball_point = detectBallWithColorOrIR("ir", global_trackColor);
            }

            if (ball_point != null) {

              //draw a circle at the tracked pixel
              fill(255);
              strokeWeight(4.0);
              stroke(0);
              ellipse(ball_point.x, ball_point.y, 20, 20);


              global_ball_toio_coord = new Point(
                map(ball_point.x, mouseXLocationList[0], mouseXLocationList[1], 34, 644),
                map(ball_point.y, mouseYLocationList[0], mouseYLocationList[1], 35, 466)); //this is updated now
              //global_ball_toio_coord.x = map(ball_point.x, mouseXLocationList[0], mouseXLocationList[1], 34, 644); //this is updated now
              //global_ball_toio_coord.y = map(ball_point.y, mouseYLocationList[0], mouseYLocationList[1], 35, 466); //this is updated now


              //if we need to find ball velocity and angle, use the following
              //depthDiff  = global_dHist[global_dHist.length-1]-global_dHist[int(global_dHist.length/2)]; // this value should be positive
              //xDiff  = global_xHist[global_xHist.length-1]-global_xHist[int(global_xHist.length/2)];

              //throwDegree = degrees(atan2(depthDiff, xDiff));
              //throwDegree = degrees(atan2(3, 4));

              //caculate velocity, we can just find the velocty of the five points after mid point
              //avgZVelocity = ((global_dHist[int(global_dHist.length/2)] - global_dHist[0]))/3;
              //avgXVelocity = ((global_xHist[int(global_xHist.length/2)] - global_xHist[0]))/3;

              //phase2_ballSticks = true;

              jumpToPhase7();

              //upper left corber coordinate is (32, 32) and lower right corver is (646, 465)

              if (global_ball_toio_coord.x > 596 || global_ball_toio_coord.y > 415 || global_ball_toio_coord.y < 82 || global_ball_toio_coord.x < 82) {
                //this is the case when ball sticks on the edge of theceiling so that robot can't travel to drop it
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
      phaseLabel = "Phase 3/11. Let toio prong side face the ball";
      println(phaseLabel);

      println("x: ", global_ball_toio_coord.x, " y: ", global_ball_toio_coord.y);
      exit();
    } else if (phase3_facePushLocation == true && phase4_travelToBallToPush == false) {

      //Phase 4. Let pushing toio travel to ball (preparing to push)
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 4/11. Let pushing toio travel to ball (preparing to push)";
      println(phaseLabel);
    } else if (phase4_travelToBallToPush == true && phase5_rotateBallToPushLocation == false) {

      //Phase 5. Pushing toio rotates the ball such that they face the push location
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 5/11. Pushing toio rotates the ball such that they face the push location";
      println(phaseLabel);
    } else if (phase5_rotateBallToPushLocation == true && phase6_pushDone == false) {

      //Phase 6. Pushing toio pushes the ball to the push location
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 6/11. Pushing toio pushes the ball to the push location";
      println(phaseLabel);
    } else if (phase6_pushDone == true && phase7_findTangentPoints == false) {

      //Phase 7. Calculate prep location for both toios to travel
      phaseLabel = "Phase 7/11. Calculate prep location for both toios to travel";
      println(phaseLabel);

      if (applicationMode == "practice") {

        //After finding the ball's new position (which should be close to the push location), we find the prep location for both toios to travel
        if (flag_needBackout == false) {
          //If toios don't need to backout, we call findLocation() to find the prep location

          travel_points = new Point[2];
          travel_points = find_location(global_ball_toio_coord.x, global_ball_toio_coord.y);

          if (travel_points != null) {
            //If we find the prep location, we move on to the next phase

            //we also find which toio is closer to the ball here!
            distance_cube0_ball = cubes[0].distance(global_ball_toio_coord.x, global_ball_toio_coord.y);
            distance_cube1_ball = cubes[1].distance(global_ball_toio_coord.x, global_ball_toio_coord.y);

            if (distance_cube0_ball < distance_cube1_ball) {
              global_closer_toio_id = 0;
            } else {
              global_closer_toio_id = 1;
            }

            phase7_findTangentPoints = true;
          } else {
            //If we can't find the prep locations, that means that at least one toio is too close the ball, so we need to move them out
            flag_needBackout = true;
            println("flag_needBackout:", flag_needBackout);
          }
        } else {

          //By calling findbackoutLocation(), we can move toio back (on the line formed by toio and the ball)
          println("Back out toio because they are within radius");

          if (flag_prepareBackout == false) {

            //detect the location of the ball
            Point ball_point;
            if (cameraDetectionMode == "color") {
              ball_point = detectBallWithColorOrIR("color", global_trackColor);
            } else {
              //cameraDetectionMode == "ir"
              ball_point = detectBallWithColorOrIR("ir", global_trackColor);
            }


            if (ball_point != null) {

              backout_0 = findbackoutLocation(0, global_ball_toio_coord.x, global_ball_toio_coord.y);
              backout_1 = findbackoutLocation(1, global_ball_toio_coord.x, global_ball_toio_coord.y);

              flag_prepareBackout = true;
              println("flag_prepareBackout:", flag_prepareBackout);
            }
          } else {

            aimCubeSpeed(0, backout_0.x, backout_0.y);
            aimCubeSpeed(1, backout_1.x, backout_1.y);

            if (checkTolerance(cubes[0], cubes[1], backout_0, backout_1, travelErrorTolerance)) {
              //when toios finally backout, we set flag_needBackout to false so that we can once again call findLocation() to find the prep locaiton
              flag_needBackout = false;
              println("done backing out!");
            }
          }
        }
      }
    } else if (phase7_findTangentPoints == true && phase8_toioTravelToPrepLocation == false) {

      //Phase 8. Both toios travel to prep locations
      phaseLabel = "Phase 8/11. Both toios travel to prep locations";
      println(phaseLabel);

      if (applicationMode == "practice") {

        if (global_closer_toio_id == 0) {
          //If closer toio is cube0, we let it travel to global_finalx, global_finaly and let cube1 travel to global_xprime, global_yprime.
          aimCubeSpeed(0, travel_points[0].x, travel_points[0].y);
          aimCubeSpeed(1, travel_points[1].x, travel_points[1].y);

          if (checkTolerance(cubes[0], cubes[1], travel_points[0], travel_points[1], travelErrorTolerance)) {
            phase8_toioTravelToPrepLocation = true;
          }
        } else {

          //If closer toio is cube1, we let it travel to global_finalx, global_finaly and let cube0 travel to global_xprime, global_yprime.
          aimCubeSpeed(1, travel_points[0].x, travel_points[0].y);
          aimCubeSpeed(0, travel_points[1].x, travel_points[1].y);

          if (checkTolerance(cubes[1], cubes[0], travel_points[0], travel_points[1], travelErrorTolerance)) {
            phase8_toioTravelToPrepLocation = true;
          }
        }
      }
    } else if (phase8_toioTravelToPrepLocation == true && phase9_rotateToDrop == false) {
      //Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation
      phaseLabel = "Phase 9/11. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation";
      println(phaseLabel);

      if (applicationMode == "practice") {

        if (flag_recordToioAndBallAngle == false) {
          turnDegree0 = degrees(atan2(global_ball_toio_coord.y-cubes[0].y, global_ball_toio_coord.x-cubes[0].x));

          if (turnDegree0 < 0) {
            turnDegree0+=360;
          }

          turnDegree1 = degrees(atan2(global_ball_toio_coord.y-cubes[1].y, global_ball_toio_coord.x-cubes[1].x));

          if (turnDegree1 < 0) {
            turnDegree1+=360;
          }

          flag_recordToioAndBallAngle = true;
        } else {

          //rotate cube0 first
          if (abs(cubes[0].deg - turnDegree0) < rotateErrorTolerance) {
            flag_rotate0 = true;
          } else {
            rotateCube(0, turnDegree0);
          }

          //based on cube0 degree, we rotate cube1
          if (abs(cubes[1].deg - (turnDegree1-180)) < rotateErrorTolerance || abs(cubes[1].deg - (turnDegree1-180+360)) < rotateErrorTolerance) {

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
      phaseLabel = "Phase 10/11. Toio converge to drop the object";
      println(phaseLabel);

      if (applicationMode == "practice") {
        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {

          if (millis() > time + 500) {

            //both toios travel to the ball's location
            aimCubeSpeed(0, global_ball_toio_coord.x, global_ball_toio_coord.y);
            aimCubeSpeed(1, global_ball_toio_coord.x, global_ball_toio_coord.y);
          }
        }

        //we are finally done with all the phases after the toios drop the ball
        if (checkTolerance(cubes[0], cubes[1], global_ball_toio_coord, global_ball_toio_coord, convergeDistance)) {
          phase10_dropSucceed = true;
          startTime = false;
        }
      }
    } else if (phase10_dropSucceed == true) {

      //Phase 11. Reset all of the flags so that we can start the algorithm again
      phaseLabel = "Phase 11/11. Reset all of the flags so that we can start the algorithm again";
      println(phaseLabel);

      if (applicationMode == "practice") {

        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {
          if (millis() > time + 1000) {

            aimCubeSpeed(0, start_position_0.x, start_position_0.y);
            aimCubeSpeed(1, start_position_1.x, start_position_1.y);

            if (checkTolerance(cubes[0], cubes[1], start_position_0, start_position_1, travelErrorTolerance)) {
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
              flag_prepareBackout = false;
              flag_findPushedBallLocation = false;
              turnDegree1 = 0;
              turnDegree0 = 0;
              startTime = false;
              practice_flag_trackedStuckBall = false;
            }
          }
        }
      }
    }
  }




  if (chase) {
    cubes[0].targetx = cubes[0].x;
    cubes[0].targety = cubes[0].y;
    cubes[1].targetx = cubes[0].x;
    cubes[1].targety = cubes[0].y;
  }
  //makes a circle with n cubes
  if (mouseDrive) {
    float mx = (mouseX);
    float my = (mouseY);
    float cx = 45+410/2;
    float cy = 45+410/2;

    float mulr = 180.0;

    float aMouse = atan2( my-cy, mx-cx);
    float r = sqrt ( (mx - cx)*(mx-cx) + (my-cy)*(my-cy));
    r = min(mulr, r);
    for (int i = 0; i< nCubes; ++i) {
      if (cubes[i].isLost==false) {
        float angle = TWO_PI*i/nCubes;
        float na = aMouse+angle;
        float tax = cx + r*cos(na);
        float tay = cy + r*sin(na);
        fill(255, 0, 0);
        ellipse(tax, tay, 10, 10);
        cubes[i].targetx = tax;
        cubes[i].targety = tay;
      }
    }
  }

  if (spin) {
    motorControl(0, -100, 100, 30);
  }

  if (chase || mouseDrive) {
    //do the actual aim
    for (int i = 0; i< nCubes; ++i) {
      if (cubes[i].isLost==false) {
        fill(0, 255, 0);
        ellipse(cubes[i].targetx, cubes[i].targety, 10, 10);
        aimCubeSpeed(i, cubes[i].targetx, cubes[i].targety);
      }
    }
  }


  //START DO NOT EDIT
  //did we lost some cubes?
  for (int i=0; i<nCubes; ++i) {
    // 500ms since last update
    cubes[i].p_isLost = cubes[i].isLost;
    if (cubes[i].lastUpdate < now - 1500 && cubes[i].isLost==false) {
      cubes[i].isLost= true;
    }
  }
  //END DO NOT EDIT
}
