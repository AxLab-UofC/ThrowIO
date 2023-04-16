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

  push_position = setInitialPushLocation(applicationMode);


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

      if (applicationMode == "practice" || (applicationMode == "storage" && storage_status == "store")) {
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
            phase1_seeBall = true;
            
          } else {
            phase1_seeBall = false;
          }
        } else {
          //mouse mode
          //If the experimentor sees that the ball thrown by the user is stuck,
          //they will use the mouse to click on the ball's location in the camera window
          println("Practice: waiting the experimentor click on stuck ball in the camera...");

          if (flag_trackedStuckBall == true) {

            if (applicationMode == "practice") {
              jumpToPhase7();
            } else {
              //applicationMode == "storage" && storage_status == "store"
              jumpToPhase3();
            }
          }
        }
      } else if ((applicationMode == "storage" && storage_status == "retrieve")) {

        if (cameraDetectionMode == "mouse") {
          //we skip this Phase to track hand when using mouse to track

          //If the experimentor sees that the ball thrown by the user is stuck,
          //they will use the mouse to click on the ball's location in the camera window
          println("Practice: waiting the experimentor click on stuck ball in the camera...");

          if (flag_trackedStuckBall == true) {
            jumpToPhase3();
          }
        } else {
          //draw the area where users should put their hand
          smallBox_w = (mouseXLocationList[1] - mouseXLocationList[0])/2.5;
          smallBox_h = (mouseYLocationList[1] - mouseYLocationList[0])/2;
          handDetectStartArea = new Point (mouseXLocationList[0]+(mouseXLocationList[1] - mouseXLocationList[0])/2, mouseYLocationList[0]+smallBox_h/2);
          handDetectEndArea = new Point (handDetectStartArea.x + smallBox_w, handDetectStartArea.y+smallBox_h);
          noFill();
          stroke(255, 0, 0);
          rect(handDetectStartArea.x, handDetectStartArea.y, smallBox_w, smallBox_h);

          findHand(handDetectStartArea.x, handDetectStartArea.y, handDetectEndArea.x, handDetectEndArea.y, storage_loc, storage_lerpedLoc);

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

          if (v2.x > handDetectStartArea.x &&  v2.x < handDetectEndArea.x && v2.y > handDetectStartArea.y && v2.y < handDetectEndArea.y) {
            //record hand position
            handPosition.x = v2.x;
            handPosition.y = v2.y;

            //translate it to toio location as push location
            push_position.x = map(handPosition.x, mouseXLocationList[0], mouseXLocationList[1], 34, 644);
            push_position.y = map(handPosition.y, mouseYLocationList[0], mouseYLocationList[1], 35, 466);

            //phase1 complete (it is technically see hand instead of see ball)
            phase1_seeBall = true;
          }
        }
      }
    } else if (phase1_seeBall == true && phase2_ballSticks == false) {

      //Phase 2. Check if ball sticks
      phaseLabel = "Phase 2/11. Check if ball sticks";
      println(phaseLabel);

      if (applicationMode == "practice" || (applicationMode == "storage")) {

        if (startTime == false) {
          time = millis();
          startTime = true;
        } else {


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

              if (applicationMode == "practice") {

                jumpToPhase7();
              } else {
                //applicationMode == "storage" && storage_status == "store"
                phase2_ballSticks = true;
              }

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

      if (applicationMode == "storage") {

        //detect the location of the ball in case that it is not stick (only considering color and ir tracking here)
        Point ball_point;
        if (cameraDetectionMode == "color") {
          ball_point = detectBallWithColorOrIR("color", global_trackColor);
        } else if (cameraDetectionMode == "ir") {
          ball_point = detectBallWithColorOrIR("ir", global_trackColor);
        } else {
          //cameraDetectionMode == "mouse"
          //we already record the position of global_ball_toio_coord in Phase 1
          ball_point = global_ball_toio_coord;
        }


        if (ball_point != null) {

          if (storage_status == "store") {
            //set the position for storing
            push_position.x = storage_postiion.x;
            push_position.y = storage_postiion.y;
          } else {
            //set the pushed position for dropping
            push_position.x = storage_drop_position.x;
            push_position.y  = storage_drop_position.y;
          }

          //we need to record the angle between the pushing toio and the ball location
          if (flag_recordPushingToioAndBallAngle == false) {

            //the ball sticks in between the spaces between the toio robots

            if (global_ball_toio_coord.x < push_position.x) {
              //record that cube 0 will push
              global_pushToio = 0;

              //turnDegree0 is to what degrees that toio0 needs to spin to so that it will face its front (wedge) side to ball location
              turnDegree0 = degrees(atan2(global_ball_toio_coord.y-cubes[0].y, global_ball_toio_coord.x-cubes[0].x));
              if (turnDegree0 < 0) {
                turnDegree0+=360;
              }
            } else {
              //record that cube 1 will push
              global_pushToio = 1;

              //turnDegree1 is to what degrees that toio1 needs to spin to so that it will face its front (wedge) side to ball location
              turnDegree1 = degrees(atan2(global_ball_toio_coord.y-cubes[1].y, global_ball_toio_coord.x-cubes[1].x));

              if (turnDegree1 < 0) {
                turnDegree1+=360;
              }
            }

            flag_recordPushingToioAndBallAngle = true;
          } else {


            if (global_pushToio == 0) {
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
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 4/11. Let pushing toio travel to ball (preparing to push)";
      println(phaseLabel);

      if (global_pushToio == 0) {
        //cube 0 is pushing so it travels to the ball location

        aimCubeSpeed(0, global_ball_toio_coord.x, global_ball_toio_coord.y); //may need to control distance

        if (abs(cubes[0].x - global_ball_toio_coord.x) < distanceBetweenPushingToioAndBall &&
          abs(cubes[0].y - global_ball_toio_coord.y) < distanceBetweenPushingToioAndBall) {

          phase4_travelToBallToPush = true;
        }
      } else {
        //cube 1 is pushing so it travels to the ball location

        aimCubeSpeed(1, global_ball_toio_coord.x, global_ball_toio_coord.y);

        if (abs(cubes[1].x - global_ball_toio_coord.x) < distanceBetweenPushingToioAndBall &&
          abs(cubes[1].y - global_ball_toio_coord.y) < distanceBetweenPushingToioAndBall) {

          phase4_travelToBallToPush = true;
        }
      }
    } else if (phase4_travelToBallToPush == true && phase5_rotateBallToPushLocation == false) {

      //Phase 5. Pushing toio rotates the ball such that they face the push location
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 5/11. Pushing toio rotates the ball such that they face the push location";
      println(phaseLabel);

      if (applicationMode == "storage") {
        if (global_pushToio == 0) {
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
      }
    } else if (phase5_rotateBallToPushLocation == true && phase6_pushDone == false) {

      //Phase 6. Pushing toio pushes the ball to the push location
      //applicationMode == "ufo" "story" "storage" "push_eval" use this phase
      phaseLabel = "Phase 6/11. Pushing toio pushes the ball to the push location";
      println(phaseLabel);

      if (applicationMode == "storage") {

        if (global_pushToio == 0) {
          //cube0 is the pushing toio and pushes the ball to push location
          aimCubeSpeed(0, push_position.x, push_position.y);
          if (abs(cubes[0].x - push_position.x) < distanceBetweenPushingToioAndPushLocation && abs(cubes[0].y - push_position.y) < distanceBetweenPushingToioAndPushLocation) {
            phase6_pushDone = true;
          }
        } else {
          //cube1 is the pushing toio and pushes the ball to push location
          aimCubeSpeed(1, push_position.x, push_position.y);
          if (abs(cubes[1].x - push_position.x) < distanceBetweenPushingToioAndPushLocation && abs(cubes[1].y - push_position.y) < distanceBetweenPushingToioAndPushLocation) {
            phase6_pushDone = true;
          }
        }
      }
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
      } else if (applicationMode == "storage") {
        if (storage_status == "store") {
          //storing
          //it is fine if pushing toio did not backout precisely
          jumpToPhase11();
        } else {
          //retrieving
          //Note: in our application, the ball is pushed from left to right, once it is done pushing, the other toio should still be at the right of the ball

          //set prep location for pushing toio (which will be 0)
          Point final_point = new Point(cubes[0].x, cubes[0].y); //orignally global_finalx, global_finaly

          //set prep location for the other toio (which will be 1)
          Point opposite_point = new Point(cubes[1].x, cubes[0].y); //orignally global_xprime, global_yprime

          travel_points = new Point[2];
          travel_points[0] = final_point;
          travel_points[1] = opposite_point;

          ////set prep location for pushing toio (which will be 0)
          //global_finalx = cubes[0].x;
          //global_finaly = cubes[0].y;

          ////set prep location for the other toio (which will be 1)
          //global_xprime = cubes[1].x;
          //global_yprime = cubes[0].y;

          phase7_findTangentPoints = true;
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
      } else if (applicationMode == "storage" ) {
        //pushing toio is 0, and other toio is 1
        aimCubeSpeed(0, travel_points[0].x, travel_points[0].y);
        aimCubeSpeed(1, travel_points[1].x, travel_points[1].y);

        println("why are you here?");
        if (checkTolerance(cubes[0], cubes[1], travel_points[0], travel_points[1], travelErrorTolerance)) {
          phase8_toioTravelToPrepLocation = true;
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
      } else if (applicationMode == "storage") {

        if (startTime == false) {

          time = millis();
          startTime = true;
          storage_recordPushing = new Point(cubes[0].x, cubes[0].y);
          //storage_recordPushingX = cubes[0].x;
          //storage_recordPushingY = cubes[0].y;
        } else {

          if (millis() > time + 500) { //wait for the ball with key to drop

            //only other toio (cube1) travel toward the pushing toio
            aimCubeSpeed(1, storage_recordPushing.x+convergeDistance, storage_recordPushing.y);

            //the pushing toio apply forces to remain at the same location (we secret increase the speed)
            aimCubeSpeed(0, storage_recordPushing.x+5, storage_recordPushing.y);
          }
        }
        //we are finally done with all the phases after the toios drop the ball
        if (abs(storage_recordPushing.x+convergeDistance - cubes[1].x) < 15 &&
          abs(storage_recordPushing.y - cubes[1].y) < 15) {

          phase10_dropSucceed = true;
          startTime = false;
        }
      }
    } else if (phase10_dropSucceed == true) {

      //Phase 11. Reset all of the flags so that we can start the algorithm again
      phaseLabel = "Phase 11/11. Reset all of the flags so that we can start the algorithm again";
      println(phaseLabel);

      if (applicationMode == "practice" || applicationMode == "storage") {

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
              flag_recordPushingToioAndBallAngle = false;
              flag_prepareBackout = false;
              flag_findPushedBallLocation = false;
              turnDegree1 = 0;
              turnDegree0 = 0;
              startTime = false;
              flag_trackedStuckBall = false;

              if (applicationMode == "storage" && storage_status == "store") {
                storage_status = "retrieve";
                push_position.x = storage_postiion.x;
                push_position.y = storage_postiion.y;
                storage_loc.x = 0;
                storage_loc.y = 0;
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
