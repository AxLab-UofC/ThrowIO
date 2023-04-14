//function that handle the case when a key is pressed
void keyPressed() {

  switch(key) {
  case 'c':
    println("calibration mode!");
    calibrationMode++;

    if (calibrationMode > 2) {
      calibrationMode = 0;
    }
    break;

  case 's':

    saveCalibration();
    println("saved calibration!");

    break;

  case 'l':
    println("load calibration!");

    loadCalibration();
    break;

  case 't':
    //travelToStartPosition = true;
    break;
  default:
    break;
  }
}

//function that handle the case when the mouse is pressed
void mousePressed() {

  // Save color where the mouse is clicked in trackColor variable
  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) { // for position
    mousePressedforPosCalibration();
  }


  if (calibrationMode == 2 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {// for color
    mousePressedforColorCalibration();
  }

  //if (applicationMode == "story" && calibrationMode == 0 && phase2_ballSticks == true && phase3_facePushLocation == false) {

  //  //when the experimentor needs to wizard of Oz to track where the ball sticks
  //  mousePressedforTrackStuckBall();
  //}

  //if (applicationMode == "story" && calibrationMode == 0 && phase6_pushDone == true && phase7_findTangentPoints == false) {

  //  //when the experimentor needs to wizard of Oz to track where the ball sticks
  //  mousePressedforTrackPushedBall();
  //}
  //if (applicationMode == "push_eval" && calibrationMode == 0 && phase2_ballSticks == true && phase3_facePushLocation == false) {

  //  //when the experimentor needs to track where the ball sticks
  //  mousePressedforTrackStuckBall();
  //}
  //if (applicationMode == "push_eval" && calibrationMode == 0 && phase10_dropSucceed == true) {

  //  //when the experimentor needs to track where the ball sticks
  //  checkFinalPostion = true;
  //}
}

//handle the case when mouse is dragged
void mouseDragged() {
  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {
    mouseReleasedforPosCalibration();
  }
}

//handle the case when mouse is released after dragging
void mouseReleased() {
  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {
    mouseReleasedforPosCalibration();
  }
}
