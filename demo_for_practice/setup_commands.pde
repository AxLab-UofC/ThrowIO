

Point[] setInitialRobotLocation(String mode) {
  //set starting position for the robots
  Point start_pos_0;
  Point start_pos_1;
  Point[] start_pos = new Point[2];
  if (mode == "story") {

    start_pos_0 = new Point(100, 100);
    start_pos_1 = new Point(600, 250);
  } else if (mode == "storage") {
    start_pos_0 = new Point(100, 245);
    start_pos_1 = new Point(600, 250);
  } else {
    //practice
    start_pos_0 = new Point(100, 350);
    start_pos_1 = new Point(550, 270);
  }

  start_pos[0] = start_pos_0;
  start_pos[1] = start_pos_1;

  return start_pos;
}
