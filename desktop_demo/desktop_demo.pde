void settings() {
  size(1280, 720, P3D);
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

  //do not send TOO MANY PACKETS
  //we'll be updating the cubes every frame, so don't try to go too high
  frameRate(30);

  //set starting position for the robots
  start_position_0 = new Point(100, 100);
  start_position_1 = new Point(275, 185);
  //startPositionX1 = 80;
  //startPositionY1 = 80;
  //startPositionX2 = 295;
  //startPositionY2 = 205;
}

void draw() {
  //START DO NOT EDIT

  //the motion function sends a constant request for motion data from a toio ID
  //motionRequest(0);
  background(255);
  stroke(0);
  long now = System.currentTimeMillis();

  //draw the "mat"
  fill(255);
  rect(34, 35, 339, 250);

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

  textSize(30);
  fill(0);
  text(phaseLabel, 20, 400);

  //END DO NOT EDIT

  //phase starts here
  if (phase1_seeBall == false) {

    //Phase 1. Check if the camera sees a ball
    phaseLabel = "Phase 1/11. Check if the camera sees a ball";
    println(phaseLabel);

    phase1_seeBall = true;  // we don't need the camera for desktop demo, so we make it true
  } else if (phase1_seeBall == true && phase2_ballSticks == false) {

    //Phase 2. Check if ball sticks
    phaseLabel = "Phase 2/11. Check if ball sticks";
    println(phaseLabel);

    if (cubes[2].isLost == false) {
      //record the ball location
      global_ball = new Point(cubes[2].x, cubes[2].y);
      jumpToPhase7(); // here we check if the toio ball sticks to the ceiling
    }
  } else if (phase2_ballSticks == true && phase3_facePushLocation == false) {

    //Phase 3. Let toio prong side face the ball
    //This is an important step because we want the prong side to face the ball or else toio might use the wedge side to approach the object
    phaseLabel = "Phase 3/11. Let toio prong side face the ball";
    println(phaseLabel);
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

    //After finding the ball's new position (which should be close to the push location), we find the prep location for both toios to travel
    if (flag_needBackout == false) {
      //If toios don't need to backout, we call findLocation() to find the prep location

      travel_points = new Point[2];
      travel_points = find_location(global_ball.x, global_ball.y);

      if (travel_points != null) {
        //If we find the prep location, we move on to the next phase

        //we also find which toio is closer to the ball here!
        distance_cube0_ball = cubes[0].distance(global_ball.x, global_ball.y);
        distance_cube1_ball = cubes[1].distance(global_ball.x, global_ball.y);

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

        if (cubes[2].isLost==false) {

          backout_0 = findbackoutLocation(0, global_ball.x, global_ball.y);
          backout_1 = findbackoutLocation(1, global_ball.x, global_ball.y);

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
  } else if (phase7_findTangentPoints == true && phase8_toioTravelToPrepLocation == false) {

    //Phase 8. Both toios travel to prep locations
    phaseLabel = "Phase 8/11. Both toios travel to prep locations";
    println(phaseLabel);


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
  } else if (phase8_toioTravelToPrepLocation == true && phase9_rotateToDrop == false) {
    //Phase 9. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation
    phaseLabel = "Phase 9/11. One toio rotates to use the prong side to and the other rotates to use the wedge side for drop operation";
    println(phaseLabel);

    if (flag_recordToioAndBallAngle == false) {
      turnDegree0 = degrees(atan2(global_ball.y-cubes[0].y, global_ball.x-cubes[0].x));

      if (turnDegree0 < 0) {
        turnDegree0+=360;
      }

      turnDegree1 = degrees(atan2(global_ball.y-cubes[1].y, global_ball.x-cubes[1].x));

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

        //extra line of to record angle to spin the toio ball toward toio 0, so that it is easier to be dropped
        turnDegree2 = degrees(atan2(cubes[0].y-cubes[2].y, cubes[0].y-cubes[2].x));

        if (turnDegree2 < 0) {
          turnDegree2+=360;
        }

        phase9_rotateToDrop = true;
      }
    }
  } else if (phase9_rotateToDrop == true && phase10_dropSucceed == false) {



    //Phase 10. Toio converge to drop the object
    phaseLabel = "Phase 10/11. Toio converge to drop the object";
    println(phaseLabel);

    if (startTime == false) {
      time = millis();
      startTime = true;
    } else {

      //Rotate the toio ball here while waiting to be dropped
      rotateCubeMax(2, turnDegree2-180);

      if (millis() > time + 500) {

        //both toios travel to the ball's location
        aimCubeSpeed(0, global_ball.x, global_ball.y);
        aimCubeSpeed(1, global_ball.x, global_ball.y);
      }
    }

    //we are finally done with all the phases after the toios drop the ball
    if (checkTolerance(cubes[0], cubes[1], global_ball, global_ball, convergeDistance)) {
      phase10_dropSucceed = true;
      startTime = false;
    }

  } else if (phase10_dropSucceed == true) {

    //Phase 11. Reset all of the flags so that we can start the algorithm again
    phaseLabel = "Phase 11/11. Reset all of the flags so that we can start the algorithm again";
    println(phaseLabel);
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
