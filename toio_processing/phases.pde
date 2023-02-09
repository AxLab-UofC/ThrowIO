//ask David how to better represent the Figma images for math angles

////set the tangent points in the processing of calculating prep position
//boolean setTangentPoint(float theta1, float theta2, float theta3, float d2, String mode) {

//  //for the case of finding xprime and yprime, theta1 and theta2 will not be used, theta3 is theta4, d2 is diameter

//  float x = 0.0;
//  float y = 0.0;

//  float tempx = 0.0;
//  float tempy = 0.0;

//  if (mode == "firstTangentPoint") {
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


//  if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) < 0) {

//    //println("ball in quadrant 1");
//    x = tempx+d2 * cos(theta3);
//    y = tempy-d2 * sin(theta3);
//  } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) < 0) {

//    //println("ball in quadrant 2");
//    x = tempx-d2*cos(theta3);
//    y = tempy-d2*sin (theta3);
//  } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) > 0) {

//    //println("ball in quadrant 3");
//    x = tempx-d2*cos(theta3);
//    y = tempy+d2*sin (theta3);
//  } else if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) > 0) {

//    //println("ball in quadrant 4");

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

//    if ((global_ball_x - tempx) == 0 && (global_ball_y - tempy) > 0) {

//      //println("ball in between 3 and 4 quadrants");
//      x = tempx+d2*sin(theta3);
//      y = tempy+d2*cos(theta3);
//    } else if ((global_ball_x - tempx) > 0 && (global_ball_y - tempy) == 0) {

//      //println("ball in between 1 and 4 quadrants");
//      x = tempx+d2*cos(theta3);
//      y = tempy-d2*sin(theta3);
//    } else if ((global_ball_x - tempx) == 0 && (global_ball_y - tempy) < 0) {

//      //println("ball in between 1 and 2 quadrants");
//      x = tempx+d2*sin(theta3);
//      y = tempy-d2*cos(theta3);
//    } else if ((global_ball_x - tempx) < 0 && (global_ball_y - tempy) == 0) {

//      //println("ball in between 2 and 3 quadrants");
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

////set the prep locations
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
//  c0_dist = cubes[0].distance(global_scaledX, global_scaledY);
//  c1_dist = cubes[1].distance(global_scaledX, global_scaledY);

//  //set toio center x and y using closer toio x and y
//  if (c0_dist < c1_dist) {
//    global_closer_toio_id = 0; //closer toio
//    global_toio_center_x = cubes[0].x;
//    global_toio_center_y = cubes[0].y;
//  } else {
//    global_closer_toio_id = 1; //further toio
//    global_toio_center_x = cubes[1].x;
//    global_toio_center_y = cubes[1].y;
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

//    setTangentPoint(theta1, theta2, theta3, d2, "firstTangentPoint");
//    setTangentPoint(theta1, theta2, theta3, d2, "secondTangentPoint");

//    //2. use the further toio to find the tangent point that has longer distance
//    if (global_closer_toio_id == 0) {
//      //toio id 1 is the further toio

//      if (cubes[1].distance(global_x, global_y) > cubes[1].distance(global_x2, global_y2)) {
//        //x and y point is further
//        global_furtherTangentPoint = "xy";
//      } else {
//        //x2 and y2 is further
//        global_furtherTangentPoint = "x2y2";
//      }
//    } else {
//      //toio id 0 is the further toio

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
//  } else {
//    //case when the ball is in the radius of the circle
//    println("robot is within radius, it should backout ");
//    return false;
//  }

//  return true;
//}
