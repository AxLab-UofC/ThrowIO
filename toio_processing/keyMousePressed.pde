void keyPressed() {

  switch(key) {
  case 'c':
    //println("calibration mode!");
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

  case 'i':
    //call immersive storytelling application
    println("immersive storytelling application!");
    applicationMode = "story";
  
  case 't':
    travelToStartPosition = true;
    break;
  default:
    break;
  }
}

//void mousePressed() {
//  //chase = false;
//  //spin = false;
//  //mouseDrive=true;

//  // Save color where the mouse is clicked in trackColor variable
//  int loc = mouseX + mouseY*kinect.getVideoImage().width;
//  mouseXLocation = mouseX;
//  mouseYLocation = mouseY;


//  mouseXLocationList[clickCount] = mouseX; //need to uncomment everything
//  mouseYLocationList[clickCount] = mouseY; //need to uncomment everything



//  //trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this

//  clickCount+=1;
//  if(clickCount == 3){
//    trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this
//  }
//}

void mousePressed() {
  //chase = false;
  //spin = false;
  //mouseDrive=true;

  // Save color where the mouse is clicked in trackColor variable

  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) { // for position
    mousePressedforPosCalibration();
  }



  if (calibrationMode == 2 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {// for color
    mousePressedforColorCalibration();
  }

  if (applicationMode == "story" && calibrationMode == 0 && phase2_ballSticks == true && phase3_facePushLocation == false) {

    //when the experimentor needs to wizard of Oz to track where the ball sticks
    mousePressedforTrackStuckBall();
  }

  if (applicationMode == "story" && calibrationMode == 0 && phase6_pushDone == true && phase7_findTangentPoints == false) {

    //when the experimentor needs to wizard of Oz to track where the ball sticks
    mousePressedforTrackPushedBall();
  }
  if (applicationMode == "push_eval" && calibrationMode == 0 && phase2_ballSticks == true && phase3_facePushLocation == false) {

    //when the experimentor needs to wizard of Oz to track where the ball sticks
    mousePressedforTrackStuckBall();
  }
  if (applicationMode == "push_eval" && calibrationMode == 0 && phase10_dropSucceed == true) {

    //when the experimentor needs to wizard of Oz to track where the ball sticks
    
    println("toio X",map(mouseX, mouseXLocationList[0], mouseXLocationList[1], 32, 614+32));
    println("toio Y",map(mouseY, mouseYLocationList[0], mouseYLocationList[1], 32, 433+32));
    checkFinalPostion = true;
  }
}



void mouseDragged() {
  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {
    mouseReleasedforPosCalibration();
  }
}

void mouseReleased() {
  if (calibrationMode == 1 && mouseX < kinect.getVideoImage().width && mouseY < kinect.getVideoImage().height) {
    mouseReleasedforPosCalibration();
  }
}
