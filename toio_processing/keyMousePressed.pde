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
