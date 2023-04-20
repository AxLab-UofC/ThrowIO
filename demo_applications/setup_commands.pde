

Point[] setInitialRobotLocation(String mode) {
  //set starting position for the robots
  Point start_pos_0;
  Point start_pos_1;
  Point[] start_pos = new Point[2];
  if (mode == "story") {

    start_pos_0 = new Point(100, 100);
    start_pos_1 = new Point(550, 250);
  } else if (mode == "storage") {
    start_pos_0 = new Point(100, 245);
    start_pos_1 = new Point(550, 250);
  } else {
    //practice
    start_pos_0 = new Point(100, 350);
    start_pos_1 = new Point(550, 270);
  }

  start_pos[0] = start_pos_0;
  start_pos[1] = start_pos_1;

  return start_pos;
}

Point setInitialPushLocation(String mode) {
  Point push_pos;

  if (mode == "storage") {

    push_pos = new Point(storage_postiion.x, storage_postiion.y);
  } else if (mode == "story") {
    //save orange positions
    story_saveOrangePosition(story_orange1.x, story_orange1.y, story_orange2.x, story_orange2.y, 0, 0, story_orangeCount);

    //this is where the robot will go to push the ball
    //findPushedLocation will set pushx and pushy directly (a way to find where the robot should move so that the pushed ball in on top of the orange)
    push_pos = findPushedLocation(1, story_orange1.x, story_orange1.y);
    
  } else {
    return null;
  }

  return push_pos;
}
