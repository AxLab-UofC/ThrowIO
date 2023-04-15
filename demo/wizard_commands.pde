////Wizard of Oz to track where the ball is
//void mousePressedforTrackStuckBall() {
//  story_mouseXForOrange[0] = mouseX;
//  story_mouseYForOrange[0] = mouseY;

//  global_scaledX = map(story_mouseXForOrange[0], mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//  global_scaledY = map(story_mouseYForOrange[0], mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

//  story_flag_trackedStuckBall = true;
//}

//void mousePressedforTrackPushedBall() {
//  story_mouseXForOrange[0] = mouseX;
//  story_mouseYForOrange[0] = mouseY;

//  global_scaledX = map(story_mouseXForOrange[0], mouseXLocationList[0], mouseXLocationList[1], 32, 614+32);  //615
//  global_scaledY = map(story_mouseYForOrange[0], mouseYLocationList[0], mouseYLocationList[1], 32, 433+32);  //382

//  story_flag_trackedPushedBall = true;
//}

void mousePressedforTrackStuckBall(String mode) {
  
  
  println("come on!!");

  if (mode == "practice") {
    global_ball_toio_coord = new Point(
      map(mouseX, mouseXLocationList[0], mouseXLocationList[1], 34, 644),
      map(mouseY, mouseYLocationList[0], mouseYLocationList[1], 35, 466));

    practice_flag_trackedStuckBall = true;
  }
}
