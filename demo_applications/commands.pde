//function to detect hand position
boolean findHand(float handDetectStartAreaX, float handDetectStartAreaY, float handDetectEndAreaX, float handDetectEndAreaY, PVector loc, PVector  lerpedLoc) {
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
    loc = new PVector(sumX/count, sumY/count);
  }

  // Interpolating the location, doing it arbitrarily for now
  lerpedLoc.x = PApplet.lerp(lerpedLoc.x, loc.x, 0.3f);
  lerpedLoc.y = PApplet.lerp(lerpedLoc.y, loc.y, 0.3f);

  return true;
}

Point detectBallWithColorOrIR(String mode, color global_trackColor) {

  if (mode == "color") {
    println("In color detect mode");

    Point color_tracking_point = colorBlobDetectBall(global_trackColor);
    if (color_tracking_point != null) {
      println("color_tracking_point x :", color_tracking_point.x);
      println("color_tracking_point y:", color_tracking_point.y);

      ellipse(color_tracking_point.x, color_tracking_point.y, 20, 20);

      return color_tracking_point;
    } else {
      println("no values");
      return null;
    }
  } else if (mode == "ir") {

    println("In IR detect mode");
    Point ir_tracking_point = irDetectBall();
    if (ir_tracking_point != null) {
      println("ir_tracking_point x :", ir_tracking_point.x);
      println("ir_tracking_point y:", ir_tracking_point.y);

      ellipse(ir_tracking_point.x, ir_tracking_point.y, 20, 20);
      
      return ir_tracking_point;
    } else {
      println("no values");
      return null;
    }
  } else {
    //mouse tracking but current not supported
    println("In mouse detect mode is not supported in this helper function");
    exit();

    return null;
  }
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//if the ball has led light, we can use this function to track the object in the depth camera window.
//float[] irDetectBall() {

//  float avgX = 0;
//  float avgY = 0;
//  float avgDepth = 0;
//  float count = 0;
//  float threshold = 40; //150 for red

//  //println(50, 100, 50, 100);
//  //begin loop to walk through every pixel in the calibrated rectangle

//  for (int x = mouseXLocationList[0]; x < mouseXLocationList[1]; x++ ) {
//    for (int y = mouseYLocationList[0]; y < mouseYLocationList[1]; y++ ) {

//      int loc = x + y * kinect.getDepthImage().width; //find the location of each pixel

//      float pixelDepth = kinect.getRawDepth()[loc];
//      color currentColor = kinect.getDepthImage().pixels[loc];
//      float r1 = red(currentColor);
//      float g1 = green(currentColor);
//      float b1 = blue(currentColor);

//      //we want to find all black color
//      float r2 = 0;
//      float g2 = 0;
//      float b2 = 0;

//      float d = distSq(r1, g1, b1, r2, g2, b2);

//      //compared the pixel color to the ball color
//      if (d < threshold*threshold) {
//        //stroke(255);
//        //strokeWeight(1);
//        //point(x, y);
//        avgX += x;
//        avgY += y;
//        avgDepth += pixelDepth;
//        count++;
//      }
//    }
//  }

//  // we find the ball if count > 50 (this threshold can be changed)
//  if (count > 50) {
//    avgX = avgX / count;
//    avgY = avgY / count;
//    avgDepth = avgDepth / count;

//    float[] values = new float[3];

//    values[0] = avgX;
//    values[1] = avgY;
//    values[2] = avgDepth;
//    return values;

//  } else {
//    return null;
//  }
//}

Point colorDetectBall(boolean recordHistory) { //old code rely on aggregated color detection

  float avgX = 0;
  float avgY = 0;
  float avgDepth = 0;
  float count = 0;
  float threshold = 40; //150 for red

  Point color_pos;

  println(mouseXLocationList[0], mouseXLocationList[1], mouseYLocationList[0], mouseYLocationList[0]);
  //begin loop to walk through every pixel in the calibrated rectangle

  for (int x = mouseXLocationList[0]; x < mouseXLocationList[1]; x++ ) {
    for (int y = mouseYLocationList[0]; y < mouseYLocationList[1]; y++ ) {

      int loc = x + y * kinect.getVideoImage().width; //find the location of each pixel

      float pixelDepth = kinect.getRawDepth()[loc];
      color currentColor = kinect.getVideoImage().pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(global_trackColor);
      float g2 = green(global_trackColor);
      float b2 = blue(global_trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      //compared the pixel color to the ball color
      if (d < threshold*threshold) {
        stroke(255);
        strokeWeight(1);
        point(x, y);
        avgX += x;
        avgY += y;
        avgDepth += pixelDepth;
        count++;
      }
    }
  }

  // we find the ball if count > 50 (this threshold can be changed)
  if (count > 50) {
    avgX = avgX / count;
    avgY = avgY / count;
    avgDepth = avgDepth / count;

    //we are appending the historical positions here
    if (recordHistory) {
      global_xHist = append(global_xHist, avgX);
      global_yHist = append(global_yHist, avgY);
      global_dHist = append(global_dHist, avgDepth);
    }

    color_pos = new Point (avgX, avgY);
    return color_pos;
  } else {
    return null;
  }
}

Point colorBlobDetectBall(color global_trackColor) {

  float color_distThreshold = 3; // how close should we determine whether a pixel belongs to this blob
  float color_threshold = 1000; //how close we want the pixel color to be, compared to our track color
  float color_blobSize = 50; //we only care about blobsize that is bigger than this number of pixels
  Blob color_biggestBlob = new Blob(-1, -1, color_distThreshold); // just for initialization purposes
  Point color_biggestBlobPos;

  ArrayList<Blob> color_blobs = new ArrayList<Blob>();
  color_blobs.clear();

  // Begin loop to walk through every pixel
  for (int x = mouseXLocationList[0]; x < mouseXLocationList[1]; x++ ) {
    for (int y = mouseYLocationList[0]; y < mouseYLocationList[1]; y++ ) {
      int loc = x + y * kinect.getVideoImage().width; //change back to depth image
      // What is current color
      color currentColor = kinect.getVideoImage().pixels[loc]; //change back to depth image
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(global_trackColor);
      float g2 = green(global_trackColor);
      float b2 = blue(global_trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      if (d < color_threshold) {

        boolean found = false;
        for (Blob b : color_blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y, color_distThreshold);
          color_blobs.add(b);
        }
      }
    }
  }

  //theoritically the biggiest blob is what we want
  float maxSize = 0;
  if (color_blobs.isEmpty() == false) {
    for (Blob b : color_blobs) {
      //if (b.size() > ir_blobSize) {
      //  b.show();
      //}
      if (b.size() > color_blobSize) {
        if (b.size() > maxSize) {
          maxSize = b.size();
          //record biggest blob
          color_biggestBlob = b;
        }
      }
    }

    if (maxSize != 0) {
      println("Found the biggest blob!");
      //color_biggestBlob.show();

      color_biggestBlobPos = new Point ((color_biggestBlob.minx+color_biggestBlob.maxx)/2, (color_biggestBlob.miny+color_biggestBlob.maxy)/2);

      fill(255);
      ellipse(color_biggestBlobPos.x, color_biggestBlobPos.y, 20, 20);
      println("blob center x is: ", color_biggestBlobPos.x);
      println("blob center y is: ", color_biggestBlobPos.y);

      return color_biggestBlobPos;
    }
  }
  println("before null");
  return null;
}

Point irDetectBall() {

  ///TODO: need to disregard hand in the camera,
  //because hand too close to the camera might cause the alogirhtm to detect as the IR ball
  float ir_distThreshold = 3;
  float ir_threshold = 2;
  float ir_blobSize = 15;
  Blob ir_biggestBlob = new Blob(-1, -1, ir_distThreshold); // just for initialization purposes
  Point ir_biggestBlobPos;
  color ir_trackColor = color(255, 255, 255); //track white
  ArrayList<Blob> ir_blobs = new ArrayList<Blob>();
  ir_blobs.clear();

  // Begin loop to walk through every pixel
  for (int x = mouseXLocationList[0]; x < mouseXLocationList[1]; x++ ) {
    for (int y = mouseYLocationList[0]; y < mouseYLocationList[1]; y++ ) {
      int loc = x + y * kinect.getVideoImage().width; //change back to depth image
      // What is current color
      color currentColor = kinect.getVideoImage().pixels[loc]; //change back to depth image
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(ir_trackColor);
      float g2 = green(ir_trackColor);
      float b2 = blue(ir_trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);

      if (d < ir_threshold) {

        boolean found = false;
        for (Blob b : ir_blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y, ir_distThreshold);
          ir_blobs.add(b);
        }
      }
    }
  }

  //theoritically the biggiest blob is what we want
  float maxSize = 0;
  if (ir_blobs.isEmpty() == false) {
    for (Blob b : ir_blobs) {
      //if (b.size() > ir_blobSize) {
      //  b.show();
      //}
      if (b.size() > ir_blobSize) {
        if (b.size() > maxSize) {
          maxSize = b.size();
          //record biggest blob
          ir_biggestBlob = b;
        }
      }
    }

    if (maxSize != 0) {
      println("Found the biggest blob!");
      ir_biggestBlob.show();
      ir_biggestBlobPos = new Point ((ir_biggestBlob.minx+ir_biggestBlob.maxx)/2, (ir_biggestBlob.miny+ir_biggestBlob.maxy)/2);

      println("blob center x is: ", ir_biggestBlobPos.x);
      println("blob center y is: ", ir_biggestBlobPos.y);

      return ir_biggestBlobPos;
    }
  }

  return null;
}

// Custom distance functions w/ no square root for optimization
float distSq2(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

boolean checkTolerance(Cube cube_0, Cube cube_1, Point point_0, Point point_1, float tolerance) {

  if (abs(cube_0.x - point_0.x) < tolerance && abs(cube_0.y - point_0.y) < tolerance
    && abs(cube_1.x - point_1.x) < tolerance && abs(cube_1.y -  point_1.y) < tolerance) {

    return true;
  }

  return false;
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

//set the tangent points in the processing of calculating prep position
Point set_tangent_point(float theta_1, float theta_2, float dist_ct, String mode,
  float global_toio_center_x, float global_toio_center_y, float global_scaledX, float global_scaledY) {

  float theta_3 = 0.0; //angle_between_cube_to_tangent_point_and_horizontal_axis

  if (mode == "higher_tangent_point") {
    theta_3 = theta_2 + theta_1;
  } else {
    //lower_tangent_point
    theta_3 = theta_2 - theta_1;
  }

  float tangent_x = 0.0;
  float tangent_y = 0.0;

  Point start_point = new Point(global_toio_center_x, global_toio_center_y);
  Point ball_point = new Point(global_scaledX, global_scaledY);
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
    } else {
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

  //if (mode == "higher_tangent_point") {
  //  global_x = tangent_x;
  //  global_y = tangent_y;

  //} else{
  //  //lower_tangent_point
  //  global_x2 = tangent_x;
  //  global_y2 = tangent_y;
  //}

  //return true;

  Point tangent = new Point(tangent_x, tangent_y);

  return tangent;
}

Point find_opposite_point(float theta_4, float diameter,
  float global_finalx, float global_finaly, float global_scaledX, float global_scaledY) {

  Point start_point = new Point(global_finalx, global_finaly);
  Point ball_point = new Point(global_scaledX, global_scaledY);
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

  //  global_xprime = opposite_x;
  //  global_yprime = opposite_y;
  //return true;

  Point opposite_point = new Point(opposite_x, opposite_y);
  return opposite_point;
}

//set the prep locations
Point[] find_location(float global_scaledX, float global_scaledY) {

  int global_closer_toio_id;
  String global_furtherTangentPoint;

  float global_toio_center_x;
  float global_toio_center_y;
  Point final_point = new Point(-1000, -1000); //random initialization
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
    //global_ball_toio_coord_x = global_scaledX;
    //global_ball_toio_coord_y = global_scaledY;

    //find distance from ball to closer toio
    dist_cb = sqrt(pow(global_scaledX - global_toio_center_x, 2) + pow (global_scaledY - global_toio_center_y, 2));

    //find distance from closer toio to lower tangent point
    dist_ct = sqrt(pow(dist_cb, 2) - pow (global_radius, 2));

    //find vectors for angle calculation
    vector_c0 = new PVector(global_scaledX - global_toio_center_x, 0); //closer toio horizontal extension
    vector_cb = new PVector(global_scaledX - global_toio_center_x, global_scaledY - global_toio_center_y); //closer toio to ball

    //determine angles
    theta_1  = acos(dist_ct/dist_cb);
    theta_2 = acos(vector_c0.dot(vector_cb)/ (vector_c0.mag()*vector_cb.mag()));

    Point higher_tangent_point; //origanally global_x and global_y
    higher_tangent_point = set_tangent_point(theta_1, theta_2, dist_ct, "higher_tangent_point",
      global_toio_center_x, global_toio_center_y, global_scaledX, global_scaledY);

    Point lower_tangent_point; //origanally global_x2 and global_y2
    lower_tangent_point = set_tangent_point(theta_1, theta_2, dist_ct, "lower_tangent_point",
      global_toio_center_x, global_toio_center_y, global_scaledX, global_scaledY);

    //2. use the further toio to find the tangent point that has longer distance
    if (global_closer_toio_id == 0) {
      //toio id 1 is the further toio

      if (cubes[1].distance(higher_tangent_point.x, higher_tangent_point.y) >
        cubes[1].distance(lower_tangent_point.x, lower_tangent_point.y)) {
        //x and y point is further
        global_furtherTangentPoint = "xy";
      } else {
        //x2 and y2 is further
        global_furtherTangentPoint = "x2y2";
      }
    } else {
      //toio id 0 is the further toio

      if (cubes[0].distance(higher_tangent_point.x, higher_tangent_point.y) >
        cubes[0].distance(lower_tangent_point.x, lower_tangent_point.y)) {
        //x and y point is further
        global_furtherTangentPoint = "xy";
      } else {
        //x2 and y2 is further
        global_furtherTangentPoint = "x2y2";
      }
    }

    //3. use the furtherTangentPoint to find the opposite point
    if (global_furtherTangentPoint.equals("xy")) {

      final_point.x = higher_tangent_point.x; //orignally global_finalx
      final_point.y = higher_tangent_point.y; //orignally global_finaly
    } else {

      final_point.x = lower_tangent_point.x; //orignally global_finalx
      final_point.y = lower_tangent_point.y; //orignally global_finaly
    }

    vector_tb = new PVector(global_scaledX-final_point.x, global_scaledY-final_point.y); //final x and final y to ball
    vector_t0 = new PVector(global_scaledX-final_point.x, final_point.y-final_point.y); //final x and final y horizontal extension

    theta_4 = acos(vector_tb.dot(vector_t0)/(vector_tb.mag()*vector_t0.mag()));

    Point opposite_point; //orignally global_xprime, global_yprime
    opposite_point = find_opposite_point(theta_4, 2*global_radius, final_point.x, final_point.y, global_scaledX, global_scaledY);

    Point[] points;
    points = new Point[2];

    points[0] = final_point;
    points[1] = opposite_point;
    println("what? ");
    println("points[0].x:", points[0].x); //orignally global_finalx
    println("points[0].y:", points[0].y); //orignally global_finaly
    println("points[1].x:", points[1].x); //orignally global_xprime
    println("points[1].y:", points[1].y);  //orignally global_yprime
    return points;
  } else {
    //case when the ball is in the radius of the circle
    println("robot is within radius, it should backout ");

    return null;
  }

  //return true;
}

//find the backout location for the robot
Point findbackoutLocation(int toio_number, float global_scaledX, float global_scaledY) {

  float global_bitMoreThanRadius = global_radius+20;

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


  Point ball_point = new Point(global_scaledX, global_scaledY);
  Point start_point = new Point(tempx, tempy);

  String quadrant = find_quadrant (ball_point, start_point);

  if (quadrant.equals("Q1")) {

    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if (quadrant.equals("Q2")) {

    //println("ball in quadrant 2");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if (quadrant.equals("Q3")) {

    //println("ball in quadrant 3");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else if (quadrant.equals("Q4")) {

    //println("ball in quadrant 4");
    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else {

    theta5 = 0;

    if (quadrant.equals("Q34")) {

      //println("ball in between 3 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY-ratio*tempDist*cos(theta5);
    } else if (quadrant.equals("Q14")) {

      //println("ball in between 1 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*cos(theta5);
      y = global_scaledY+ratio*tempDist*sin(theta5);
    } else if (quadrant.equals("Q12")) {

      //println("ball in between 1 and 2 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY+ratio*tempDist*cos(theta5);
    } else if (quadrant.equals("Q23")) {

      //println("ball in between 2 and 3 quadrants");
      x = global_scaledX+ratio*tempDist*cos(theta5);
      y = global_scaledY+ratio*tempDist*sin(theta5);
    } else {

      println("Something is wrong here!!");
    }
  }

  Point backout_point = new Point(x, y);

  return backout_point;


  //if (toio_number == 0) {
  //  global_backoutx0 = x;
  //  global_backouty0 = y;
  //} else {
  //  global_backoutx1 = x;
  //  global_backouty1 = y;
  //}
  //return true;
}
