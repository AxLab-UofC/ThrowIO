//functions and commands for main code

//capture video from kinect camera
void captureEvent(Capture video) {
  video.read();
}

//function to jump to phase 1
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

//function to jump to phase 3
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

//function to jump to phase 7
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

//function to jump to phase 10
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

//function to jump to phase 11
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

//save the orange position
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

//helper functions to drive the cubes
boolean rotateCubeMax(int id, float ta) {
  float diff = ta-cubes[id].deg;
  if (diff>180) diff-=360;
  if (diff<-180) diff+=360;
  if (abs(diff)<20) return true;
  int dir = 1;
  int strength = int(abs(diff) / 10);
  strength = 1;
  if (diff<0)dir=-1;
  float left = (12*(1*strength)*dir);
  float right = (-12*(1*strength)*dir);

  int duration = 300;
  motorControl(id, left, right, duration);
  return false;
}

//function to find distance given three coordinates
float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//function to detect hand position
boolean findHand(float handDetectStartAreaX, float handDetectStartAreaY, float handDetectEndAreaX, float handDetectEndAreaY) {
  int threshold = 500;
  float sumX = 0;
  float sumY = 0;
  float count = 0;


  for (int x = int(handDetectStartAreaX); x < handDetectEndAreaX; x++) {
    for (int y = int(handDetectStartAreaY); y < handDetectEndAreaY; y++) {

      int offset =  x + y*kinect.width;
      // Grabbing the raw depth
      int rawDepth = kinect.getRawDepth()[offset];

      // Testing against threshold
      if (rawDepth < threshold) {
        sumX += x;
        sumY += y;
        count++;
      }
    }
  }
  //find hand threshold
  if (count > 100) {
    storage_loc = new PVector(sumX/count, sumY/count);
  }

  // Interpolating the location, doing it arbitrarily for now
  storage_lerpedLoc.x = PApplet.lerp(storage_lerpedLoc.x, storage_loc.x, 0.3f);
  storage_lerpedLoc.y = PApplet.lerp(storage_lerpedLoc.y, storage_loc.y, 0.3f);

  return true;
}

boolean detectBall(boolean recordHistory) {

  global_avgX = 0;
  global_avgY = 0;
  global_avgDepth = 0;
  global_count = 0;
   println(mouseXLocationList[0], mouseXLocationList[1],mouseYLocationList[0],mouseYLocationList[0]);
  //begin loop to walk through every pixel
  for (int x = mouseXLocationList[0]; x < mouseXLocationList[1]; x++ ) {
    for (int y = mouseYLocationList[0]; y < mouseYLocationList[1]; y++ ) {

      int loc = x + y * kinect.getVideoImage().width; //find the location of each pixel

      float pixelDepth = kinect.getRawDepth()[loc];
      color currentColor = kinect.getVideoImage().pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      //compared the pixel color to the ball color
      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        global_avgX += x;
        global_avgY += y;
        global_avgDepth += pixelDepth;
        global_count++;
      }
    }
  }

  // we find the ball if count > 50 (this threshold can be changed)
  if (global_count > 50) {
    global_avgX = global_avgX / global_count;
    global_avgY = global_avgY / global_count;
    global_avgDepth = global_avgDepth / global_count;
   
    //we are appending the historical positions here
    if (recordHistory) {
      global_xHist = append(global_xHist, global_avgX);
      global_yHist = append(global_yHist, global_avgY);
      global_dHist = append(global_dHist, global_avgDepth);
    }

    return true;
  } else {
    return false;
  }
}

//function to detect the ball or thrown object
boolean old_detectBall(boolean recordHistory) {
  
  global_avgX = 0;
  global_avgY = 0;
  global_avgDepth = 0;
  global_count = 0;

  //begin loop to walk through every pixel
  for (int x = 0; x < kinect.getVideoImage().width; x++ ) {
    for (int y = 0; y < kinect.getVideoImage().height; y++ ) {

      int loc = x + y * kinect.getVideoImage().width; //find the location of each pixel

      float pixelDepth = kinect.getRawDepth()[loc];
      color currentColor = kinect.getVideoImage().pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      //compared the pixel color to the ball color
      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        global_avgX += x;
        global_avgY += y;
        global_avgDepth += pixelDepth;
        global_count++;
      }
    }
  }

  // we find the ball if count > 50 (this threshold can be changed)
  if (global_count > 50) {
    global_avgX = global_avgX / global_count;
    global_avgY = global_avgY / global_count;
    global_avgDepth = global_avgDepth / global_count;
    
    println("detectball global_avgX:",global_avgX);
    println("detectball global_avgY:",global_avgY);
    println("detectball global_avgDepth:",global_avgDepth);

    exit();
    //we are appending the historical positions here
    if (recordHistory) {
      global_xHist = append(global_xHist, global_avgX);
      global_yHist = append(global_yHist, global_avgY);
      global_dHist = append(global_dHist, global_avgDepth);
    }

    return true;
  } else {
    return false;
  }
}

class Point {
  float x;
  float y;
  
  Point (float x_, float y_) {  
    x = x_; 
    y = y_; 
  } 
}

String find_quadrant (Point object, Point center) {

  if ((object.x - center.x) > 0 && (object.y - center.y) < 0) {
    return "Q1";
  } else if ((object.x - center.x) < 0 && (object.y - center.y) < 0) {
    return "Q2";
  } else if ((object.x - center.x) < 0 && (object.y - center.y) > 0) {
    return "Q3";
  } else if ((object.x - center.x) > 0 && (object.y - center.y) > 0) {
    return "Q4";
  } else if ((object.x - center.x) == 0 && (object.y - center.y) > 0) {
    return "Q34";
  } else if ((object.x - center.x) > 0 && (object.y - center.y) == 0) {
    return "Q14";
  } else if ((object.x - center.x) == 0 && (object.y - center.y) < 0) {
    return "Q12";
  } else if ((object.x - center.x) < 0 && (object.y - center.y) == 0) {
    return "Q23";
  } else {
    println("In find_quadrant, something is wrong because the object and center are the same point");
    exit();
    return "Error";
  }
}

boolean find_opposite_point(float theta_4, float diameter) {

  Point start_point = new Point(global_finalx, global_finaly);
  Point ball_point = new Point(global_ball_x, global_ball_y);
  String quadrant = find_quadrant (ball_point, start_point);

  float opposite_x = 0.0;
  float opposite_y = 0.0;

  if (quadrant.equals("Q1")) {

    opposite_x = start_point.x + diameter * cos(theta_4);
    opposite_y = start_point.y - diameter * sin(theta_4);
  } else if (quadrant.equals("Q2")) {

    opposite_x = start_point.x - diameter * cos(theta_4);
    opposite_y = start_point.y - diameter * sin(theta_4);
  } else if (quadrant.equals("Q3")) {
    opposite_x = start_point.x - diameter * cos(theta_4);
    opposite_y = start_point.y + diameter * sin(theta_4);
  } else if (quadrant.equals("Q4")) {
    opposite_x = start_point.x + diameter * cos(theta_4);
    opposite_y = start_point.y + diameter * sin(theta_4);
  } else {

    //When tangent point and opposite point are on the same axis, theta_4 will be NAN.
    //To address this issue, we let theta_4 = 0
    theta_4 = 0;

    if (quadrant.equals("Q34")) {
      opposite_x = start_point.x + diameter * sin(theta_4);
      opposite_y = start_point.y + diameter * cos(theta_4);
    } else if (quadrant.equals("Q14")) {
      opposite_x = start_point.x + diameter*cos(theta_4);
      opposite_y = start_point.y - diameter*sin(theta_4);
    } else if (quadrant.equals("Q12")) {

      opposite_x = start_point.x + diameter*sin(theta_4);
      opposite_y = start_point.y - diameter*cos(theta_4);
    } else if (quadrant.equals("Q23")) {
      opposite_x = start_point.x - diameter*cos(theta_4);
      opposite_y = start_point.y - diameter*sin(theta_4);
    } else {
      println("In find_opposite_point, something is because the object and center are the same point!");
      exit();
    }
  }

  global_xprime = opposite_x;
  global_yprime = opposite_y;

  return true;
}

//set the tangent points in the processing of calculating prep position
boolean setTangentPoint(float theta_1, float theta_2, float dist_ct, String mode) {

  float theta_3 = 0.0; //angle_between_cube_to_tangent_point_and_horizontal_axis

  if (mode == "higher_tangent_point") {
    theta_3 = theta_2 + theta_1;
  } else{
    //lower_tangent_point
    theta_3 = theta_2 - theta_1;
  }

  float tangent_x = 0.0;
  float tangent_y = 0.0;

  Point start_point = new Point(global_toio_center_x, global_toio_center_y);
  Point ball_point = new Point(global_ball_x, global_ball_y);
  String quadrant = find_quadrant (ball_point, start_point);

  if (quadrant.equals("Q1")) {

    tangent_x = start_point.x + dist_ct * cos(theta_3);
    tangent_y = start_point.y - dist_ct * sin(theta_3);
  } else if (quadrant.equals("Q2")) {

    tangent_x = start_point.x - dist_ct * cos(theta_3);
    tangent_y = start_point.y - dist_ct * sin(theta_3);
  } else if (quadrant.equals("Q3")) {
    tangent_x = start_point.x - dist_ct * cos(theta_3);
    tangent_y = start_point.y + dist_ct * sin(theta_3);
  } else if (quadrant.equals("Q4")) {
    tangent_x = start_point.x + dist_ct * cos(theta_3);
    tangent_y = start_point.y + dist_ct * sin(theta_3);
  } else {

    //When ball and cube are on the same axis, theta_3 will be NAN.
    //To address this issue,
    //if lower_tangent_point, then we let theta_3 = -theta_1
    //if higher_tangent_point, then we let theta_3 = theta_1

    if (mode == "higher_tangent_point") {
      theta_3 = theta_1;
    } else{
      //lower_tangent_point
      theta_3 = -theta_1;
    }

    if (quadrant.equals("Q34")) {
      tangent_x = start_point.x + dist_ct * sin(theta_3);
      tangent_y = start_point.y + dist_ct * cos(theta_3);
    } else if (quadrant.equals("Q14")) {
      tangent_x = start_point.x + dist_ct*cos(theta_3);
      tangent_y = start_point.y - dist_ct*sin(theta_3);
    } else if (quadrant.equals("Q12")) {

      tangent_x = start_point.x + dist_ct*sin(theta_3);
      tangent_y = start_point.y - dist_ct*cos(theta_3);
    } else if (quadrant.equals("Q23")) {
      tangent_x = start_point.x - dist_ct*cos(theta_3);
      tangent_y = start_point.y - dist_ct*sin(theta_3);
    } else {
      println("In setTangentPoint, something is because the object and center are the same point!");
      exit();
    }
  }

  if (mode == "higher_tangent_point") {
    global_x = tangent_x;
    global_y = tangent_y;
  } else{
    //lower_tangent_point
    global_x2 = tangent_x;
    global_y2 = tangent_y;
  }
  return true;
}

//set the prep locations
boolean find_location() {

  float dist_cb = 0.0; //distance_cube_to_ball
  float dist_ct = 0.0; //distance_cube_to_tangent_point
  PVector vector_c0; //vector_cube_to_ball_projection_on_horizontal_axis
  PVector vector_cb; //vector_cube_to_ball
  PVector vector_tb; //vector_tangent_point_to_ball
  PVector vector_t0; //vector_tangent_point_to_ball_projection_on_horizontal_axis
  float theta_1 = 0.0; //angle_between_cube_to_ball_and_cube_to_tangent_point
  float theta_2 = 0.0; //angle_between_cube_to_ball_and_horizontal_axis
  float theta_4 = 0.0; //angle_between_tangent_point_to_ball_and_horizontal_axis

  //1. Use closer toio to find two tangent points
  float distance_cube0_ball = cubes[0].distance(global_scaledX, global_scaledY);
  float distance_cube1_ball = cubes[1].distance(global_scaledX, global_scaledY);

  //set toio center x and y using closer toio x and y
  if (distance_cube0_ball < distance_cube1_ball) {
    global_closer_toio_id = 0; //closer toio
    global_toio_center_x = cubes[0].x;
    global_toio_center_y = cubes[0].y;
  } else {
    global_closer_toio_id = 1; //further toio
    global_toio_center_x = cubes[1].x;
    global_toio_center_y = cubes[1].y;

  }

  //check if the dropper is outside the radius of the circle
  //if it is inside, we will need to move it out to the two corners
  if (sqrt ( pow ( global_scaledX - global_toio_center_x, 2 ) + pow ( global_scaledY - global_toio_center_y, 2 )) > global_radius) {

    //set the ball's location by scaledX and scaledY
    global_ball_x = global_scaledX;
    global_ball_y = global_scaledY;

    //find distance from ball to closer toio
    dist_cb = sqrt(pow(global_ball_x - global_toio_center_x, 2) + pow (global_ball_y - global_toio_center_y, 2));

    //find distance from closer toio to lower tangent point
    dist_ct = sqrt(pow(dist_cb, 2) - pow (global_radius, 2));

    //find vectors for angle calculation
    vector_c0 = new PVector(global_ball_x - global_toio_center_x, 0); //closer toio horizontal extension
    vector_cb = new PVector(global_ball_x - global_toio_center_x, global_ball_y - global_toio_center_y); //closer toio to ball

    //determine angles
    theta_1  = acos(dist_ct/dist_cb);
    theta_2 = acos(vector_c0.dot(vector_cb)/ (vector_c0.mag()*vector_cb.mag()));

    setTangentPoint(theta_1, theta_2, dist_ct, "higher_tangent_point");
    setTangentPoint(theta_1, theta_2, dist_ct, "lower_tangent_point");

    //2. use the further toio to find the tangent point that has longer distance
    if (global_closer_toio_id == 0) {
      //toio id 1 is the further toio

      if (cubes[1].distance(global_x, global_y) > cubes[1].distance(global_x2, global_y2)) {
        //x and y point is further
        global_furtherTangentPoint = "xy";
      } else {
        //x2 and y2 is further
        global_furtherTangentPoint = "x2y2";
      }
    } else {
      //toio id 0 is the further toio

      if (cubes[0].distance(global_x, global_y) > cubes[0].distance(global_x2, global_y2)) {
        //x and y point is further
        global_furtherTangentPoint = "xy";
      } else {
        //x2 and y2 is further
        global_furtherTangentPoint = "x2y2";
      }
    }

    //3. use the furtherTangentPoint to find the opposite point
    if (global_furtherTangentPoint.equals("xy")) {
      global_finalx = global_x;
      global_finaly = global_y;
    } else {
      global_finalx = global_x2;
      global_finaly = global_y2;
    }

    vector_tb = new PVector(global_ball_x-global_finalx, global_ball_y-global_finaly); //final x and final y to ball
    vector_t0 = new PVector(global_ball_x-global_finalx, global_finaly-global_finaly); //final x and final y horizontal extension

    theta_4 = acos(vector_tb.dot(vector_t0)/(vector_tb.mag()*vector_t0.mag()));

    find_opposite_point(theta_4, 2*global_radius);
  } else {
    //case when the ball is in the radius of the circle
    println("robot is within radius, it should backout ");
    
    return false;
  }

  return true;
}

//find the backout location for the robot
boolean findbackoutLocation(int toio_number) {
  float x = 0.0;
  float y = 0.0;
  PVector v5, v6;
  float theta5 = 0.0;

  float tempx = 0.0;
  float tempy = 0.0;

  if (toio_number == 0) {

    tempx = cubes[0].x;
    tempy = cubes[0].y;
  } else {
    tempx = cubes[1].x;
    tempy = cubes[1].y;
  }

  float tempDist = sqrt ( pow ( global_scaledX - tempx, 2 ) + pow (global_scaledY - tempy, 2 ));
  float ratio = global_bitMoreThanRadius/tempDist;

  v5 = new PVector(global_scaledX-tempx, global_scaledY-tempy); //final x and final y to ball
  v6 = new PVector(global_scaledX-tempx, tempy-tempy); //final x and final y horizontal extension

  theta5 = acos(v5.dot(v6)/(v5.mag()*v6.mag()));


  if ((global_scaledX - tempx)> 0 & (global_scaledY - tempy) < 0) {

    //println("ball in quadrant 1");
    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) < 0) {

    //println("ball in quadrant 2");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) > 0) {

    //println("ball in quadrant 3");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) > 0) {

    //println("ball in quadrant 4");
    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else {

    theta5 = 0;

    if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) > 0) {

      //println("ball in between 3 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY-ratio*tempDist*cos(theta5);
    } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) == 0) {

      //println("ball in between 1 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*cos(theta5);
      y = global_scaledY+ratio*tempDist*sin(theta5);
    } else if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) < 0) {

      //println("ball in between 1 and 2 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY+ratio*tempDist*cos(theta5);
    } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) == 0) {

      //println("ball in between 2 and 3 quadrants");
      x = global_scaledX+ratio*tempDist*cos(theta5);
      y = global_scaledY+ratio*tempDist*sin(theta5);
    } else {

      println("Something is wrong here!!");
    }
  }

  if (toio_number == 0) {
    global_backoutx0 = x;
    global_backouty0 = y;
  } else {
    global_backoutx1 = x;
    global_backouty1 = y;
  }
  return true;
}

//find the pushx and pushy for the pushing toio such that the ball will land in an orange for example
boolean findPushedLocation(int toio_number, float ballLandingX, float ballLandingY) {
  float x = 0.0;
  float y = 0.0;
  PVector v5, v6;
  float theta5 = 0.0;

  float tempx = 0.0;
  float tempy = 0.0;

  if (toio_number == 0) {
    //change this to cube[0].x for example
    tempx = cubes[0].x;
    tempy = cubes[0].y;
  } else {
    tempx = cubes[1].x;
    tempy = cubes[1].y;
  }


  float tempDist = sqrt ( pow ( ballLandingX - tempx, 2 ) + pow (ballLandingY - tempy, 2 ));
  //the distance between the ball and toio robot shell is 30
  float ratio = 30/tempDist;


  v5 = new PVector(ballLandingX-tempx, ballLandingY-tempy); //final x and final y to ball
  v6 = new PVector(ballLandingX-tempx, tempy-tempy); //final x and final y horizontal extension

  theta5 = acos(v5.dot(v6)/(v5.mag()*v6.mag()));


  if ((ballLandingX - tempx)> 0 & (ballLandingY - tempy) < 0) {

    //println("ball in quadrant 1");
    x = ballLandingX-ratio*tempDist*cos(theta5);
    y = ballLandingY+ratio*tempDist*sin(theta5);
  } else if ((ballLandingX - tempx) < 0 & (ballLandingY - tempy) < 0) {

    //println("ball in quadrant 2");
    x = ballLandingX+ratio*tempDist*cos(theta5);
    y = ballLandingY+ratio*tempDist*sin(theta5);
  } else if ((ballLandingX - tempx) < 0 & (ballLandingY - tempy) > 0) {

    //println("ball in quadrant 3");
    x = ballLandingX+ratio*tempDist*cos(theta5);
    y = ballLandingY-ratio*tempDist*sin(theta5);
  } else if ((ballLandingX - tempx) > 0 & (ballLandingY - tempy) > 0) {

    //println("ball in quadrant 4");

    x = ballLandingX-ratio*tempDist*cos(theta5);
    y = ballLandingY-ratio*tempDist*sin(theta5);
  } else {

    theta5 = 0;

    if ((ballLandingX - tempx) == 0 & (ballLandingY - tempy) > 0) {

      //println("ball in between 3 and 4 quadrants");
      x = ballLandingX-ratio*tempDist*sin(theta5);
      y = ballLandingY-ratio*tempDist*cos(theta5);
    } else if ((ballLandingX - tempx) > 0 & (ballLandingY - tempy) == 0) {

      //println("ball in between 1 and 4 quadrants");
      x = ballLandingX-ratio*tempDist*cos(theta5);
      y = ballLandingY+ratio*tempDist*sin(theta5);
    } else if ((ballLandingX - tempx) == 0 & (ballLandingY - tempy) < 0) {

      //println("ball in between 1 and 2 quadrants");
      x = ballLandingX-ratio*tempDist*sin(theta5);
      y = ballLandingY+ratio*tempDist*cos(theta5);
    } else if ((ballLandingX - tempx) < 0 & (ballLandingY - tempy) == 0) {

      //println("ball in between 2 and 3 quadrants");
      x = ballLandingX+ratio*tempDist*cos(theta5);
      y = ballLandingY+ratio*tempDist*sin(theta5);
    } else {

      println("Something is wrong here!!");
    }
  }

  //we directly assign where the new pushx and pushy location should be
  pushx = x+33;
  pushy = y+33; //small adjustment
  return true;
}

//load the orange position for "Orange" task
void loadOrangePosition(int rowCount_) {
  table = loadTable("../data/random_positions.csv", "header");

  println(table.getRowCount() + " total rows in table");

  float OrangeX_ = table.getFloat(rowCount_, "OrangeX");
  float OrangeY_ = table.getFloat(rowCount_, "OrangeY");
  float StartX_ = table.getFloat(rowCount_, "StartX");
  float StartY_ = table.getFloat(rowCount_, "StartY");

  OrangeX = OrangeX_;
  OrangeY = OrangeY_;
  StartX = StartX_;
  StartY = StartY_;
  startPositionX1 = StartX_;
  startPositionY1 = StartY_;
}
