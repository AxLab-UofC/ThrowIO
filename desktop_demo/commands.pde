//Point[] checking() {

//  Point start_point = new Point(1, 2);
//  Point end_point = new Point(3, 7);

//  Point[] points;
//  points = new Point[2];

//  points[0] = start_point;
//  points[1] = end_point;

//  return points;
//}


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
    //global_ball_x = global_scaledX;
    //global_ball_y = global_scaledY;

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
    println("points[0].x:", points[0].x);
    println("points[0].y:", points[0].y);
    println("points[1].x:", points[1].x);
    println("points[1].y:", points[1].y);
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
