//Timmy

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

boolean detectBall(boolean recordHistory) {

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
    println("depth within detect ball: ", global_avgDepth);
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

boolean setTangentPoint(float theta1, float theta2, float theta3, float d2, String mode) {

  //for the case of finding xprime and yprime, theta1 and theta2 will not be used, theta3 is theta4, d2 is diameter

  float x = 0.0;
  float y = 0.0;

  float tempx = 0.0;
  float tempy = 0.0;

  if (mode == "firstTangentPoint") { //angleaugmentation
    theta3 = theta2+theta1;
  } else if (mode == "secondTangentPoint") {
    theta3 = theta2-theta1;
  }

  if (mode == "findOppositePoint") {
    tempx = global_finalx;
    tempy = global_finaly;
  } else {
    tempx = global_toio_center_x;
    tempy = global_toio_center_y;
  }


  if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) < 0) { //we already convert quadrant coordinates to toio mat coordinates

    println("ball in quadrant 1");
    x = tempx+d2 * cos(theta3);
    y = tempy-d2 * sin(theta3);
  } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) < 0) {

    println("ball in quadrant 2");
    x = tempx-d2*cos(theta3);
    y = tempy-d2*sin (theta3);
  } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) > 0) {

    println("ball in quadrant 3");
    x = tempx-d2*cos(theta3);
    y = tempy+d2*sin (theta3);
  } else if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) > 0) {

    println("ball in quadrant 4");

    x = tempx+d2*cos(theta3);
    y = tempy+d2*sin (theta3);
  } else {

    //theta3 == NAN
    //if theta2-theta1, then we say theta3 = -theta1
    //if theta2+theta1, then we say theta3 = theta1

    if (mode == "firstTangentPoint") {
      theta3 = theta1;
    } else if (mode == "secondTangentPoint") {
      theta3 = -theta1;
    } else {
      //case for theta4 == NAN, we make it to 0
      theta3 = 0;
    }

    if ((global_ball_x - tempx) == 0 && (global_ball_y - tempy) > 0) {

      println("ball in between 3 and 4 quadrants");
      x = tempx+d2*sin(theta3);
      y = tempy+d2*cos(theta3);
    } else if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) == 0) {

      println("ball in between 1 and 4 quadrants");
      x = tempx+d2*cos(theta3);
      y = tempy-d2*sin(theta3);
    } else if ((global_ball_x - tempx) == 0 && (global_ball_y - tempy) < 0) {

      println("ball in between 1 and 2 quadrants");
      x = tempx+d2*sin(theta3);
      y = tempy-d2*cos(theta3);
    } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) == 0) {

      println("ball in between 2 and 3 quadrants");
      x = tempx-d2*cos(theta3);
      y = tempy-d2*sin(theta3);
    } else {
      println("Something is wrong here!!");
    }
  }

  if (mode == "firstTangentPoint") {
    global_x = x;
    global_y = y;
  } else if (mode == "secondTangentPoint") {
    global_x2 = x;
    global_y2 = y;
  } else {
    global_xprime = x;
    global_yprime = y;
  }
  return true;
}

boolean findLocation() {

  float c0_dist = 0.0;
  float c1_dist = 0.0;

  float d1 = 0.0;
  float d2 = 0.0;
  PVector v1, v2, v3, v4;
  float theta1 = 0.0;
  float theta2 = 0.0;
  float theta3 = 0.0;
  float theta4 = 0.0;

  //1. Use closer toio to find two tangent points
  //c0_dist = sqrt ( pow ( global_scaledX - c0x, 2 ) + pow (global_scaledY - c0y, 2 ));
  //c1_dist = sqrt ( pow ( global_scaledX - c1x, 2 ) + pow (global_scaledY - c1y, 2 ));
  c0_dist = cubes[0].distance(global_scaledX, global_scaledY);
  c1_dist = cubes[1].distance(global_scaledX, global_scaledY);

  println("c0_dist: ", c0_dist);
  println("c1_dist: ", c1_dist);

  //set toio center x and y using closer toio x and y
  if (c0_dist < c1_dist) {
    println("0 is closer toio");
    global_closer_toio_id = 0; //closer toio
    global_toio_center_x = cubes[0].x;
    global_toio_center_y = cubes[0].y;
    //global_toio_center_x = c0x; //comment this out later
    //global_toio_center_y = c0y; //comment this out later
  } else {

    println("1 is closer toio");
    global_closer_toio_id = 1; //further toio
    global_toio_center_x = cubes[1].x;
    global_toio_center_y = cubes[1].y;
    //global_toio_center_x = c1x; //comment this out later
    //global_toio_center_y = c1y; //comment this out later
  }

  //check if the dropper is outside the radius of the circle
  //if it is inside, we will need to move it out to the two corners
  if (sqrt ( pow ( global_scaledX - global_toio_center_x, 2 ) + pow ( global_scaledY - global_toio_center_y, 2 )) > global_radius) {

    //set the ball's location by scaledX and scaledY
    global_ball_x = global_scaledX;
    global_ball_y = global_scaledY;

    //find distance from ball to closer toio
    d1 = sqrt ( pow ( global_ball_x - global_toio_center_x, 2 ) + pow ( global_ball_y - global_toio_center_y, 2 ));

    //find distance from closer toio to lower tangent point
    d2 = sqrt ( pow ( d1, 2 ) - pow ( global_radius, 2 ));

    //find vectors for angle calculation
    v1 = new PVector(global_ball_x - global_toio_center_x, global_toio_center_y - global_toio_center_y); //closer toio horizontal extension
    v2 = new PVector(global_ball_x - global_toio_center_x, global_ball_y - global_toio_center_y); //closer toio to ball

    //determine angles
    theta1 = acos(d2/d1);
    theta2 = acos(v1.dot(v2)/(v1.mag()*v2.mag()));

    //println("theta1: ", theta1);
    //println("theta2: ", theta2);
    //println("theta3: ", theta3);
    setTangentPoint(theta1, theta2, theta3, d2, "firstTangentPoint");
    setTangentPoint(theta1, theta2, theta3, d2, "secondTangentPoint");

    //2. use the further toio to find the tangent point that has longer distance
    if (global_closer_toio_id == 0) {
      //toio id 1 is the further toio

      //if (sqrt ( pow ( global_x - c1x, 2 ) + pow (global_y - c1y, 2 )) > sqrt ( pow ( global_x2 - c1x, 2 ) + pow (global_y2 - c1y, 2 ))) {
      if (cubes[1].distance(global_x, global_y) > cubes[1].distance(global_x2, global_y2)) {
        //x and y point is further
        global_furtherTangentPoint = "xy";
      } else {
        //x2 and y2 is further
        global_furtherTangentPoint = "x2y2";
      }
    } else {
      //toio id 0 is the further toio

      //if (sqrt ( pow ( global_x - c0x, 2 ) + pow (global_y - c0y, 2 )) > sqrt ( pow ( global_x2 - c0x, 2 ) + pow (global_y2 - c0y, 2 ))) {
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

    v3 = new PVector(global_ball_x-global_finalx, global_ball_y-global_finaly); //final x and final y to ball
    v4 = new PVector(global_ball_x-global_finalx, global_finaly-global_finaly); //final x and final y horizontal extension

    theta4 = acos(v3.dot(v4)/(v3.mag()*v4.mag()));

    setTangentPoint(0, 0, theta4, 2*global_radius, "findOppositePoint");

    println("global_ball_x: ", global_ball_x);
    println("global_ball_y: ", global_ball_y);
    println("global_x: ", global_x);
    println("global_y: ", global_y);
    println("global_x2: ", global_x2);
    println("global_y2: ", global_y2);
    println("global_furtherTangentPoint: ", global_furtherTangentPoint);
    println("global_finalx: ", global_finalx);
    println("global_finaly: ", global_finaly);
    println("global_xprime: ", global_xprime);
    println("global_yprime: ", global_yprime);

    
  } else {
    //case when the ball is in the radius of the circle
    println("toio is within radius, which is bad");
    return false;
  }

  return true;
}


boolean findbackoutLocation(int toio_number) {
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

  float tempDist = sqrt ( pow ( global_scaledX - tempx, 2 ) + pow (global_scaledY - tempy, 2 ));
  float ratio = global_bitMoreThanRadius/tempDist;

  v5 = new PVector(global_scaledX-tempx, global_scaledY-tempy); //final x and final y to ball
  v6 = new PVector(global_scaledX-tempx, tempy-tempy); //final x and final y horizontal extension

  theta5 = acos(v5.dot(v6)/(v5.mag()*v6.mag()));


  if ((global_scaledX - tempx)> 0 & (global_scaledY - tempy) < 0) { //we already convert quadrant coordinates to toio mat coordinates

    println("ball in quadrant 1");
    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) < 0) {

    println("ball in quadrant 2");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY+ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) > 0) {

    println("ball in quadrant 3");
    x = global_scaledX+ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) > 0) {

    println("ball in quadrant 4");

    x = global_scaledX-ratio*tempDist*cos(theta5);
    y = global_scaledY-ratio*tempDist*sin(theta5);
  } else {

    theta5 = 0;

    if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) > 0) {

      println("ball in between 3 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY-ratio*tempDist*cos(theta5);
    } else if ((global_scaledX - tempx) > 0 & (global_scaledY - tempy) == 0) {

      println("ball in between 1 and 4 quadrants");
      x = global_scaledX-ratio*tempDist*cos(theta5);
      y = global_scaledY+ratio*tempDist*sin(theta5);
    } else if ((global_scaledX - tempx) == 0 & (global_scaledY - tempy) < 0) {

      println("ball in between 1 and 2 quadrants");
      x = global_scaledX-ratio*tempDist*sin(theta5);
      y = global_scaledY+ratio*tempDist*cos(theta5);
    } else if ((global_scaledX - tempx) < 0 & (global_scaledY - tempy) == 0) {

      println("ball in between 2 and 3 quadrants");
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
  println("x: ", x);
  println("y: ", y);
  println("global_scaledX: ", global_scaledX);
  println("global_scaledY: ", global_scaledY);
  println("global_backoutx0: ", global_backoutx0);
  println("global_backouty0: ", global_backouty0);
  println("global_backoutx1: ", global_backoutx1);
  println("global_backouty1: ", global_backouty1);
  return true;
}
