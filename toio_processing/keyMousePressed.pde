void keyPressed() {
  
  switch(key) {
    case 'c':
      println("calibration mode!");
      //myflag = true;

    
  
  //case 'f':
  //  try {
  //    midi(0, 64, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 63, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 64, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 63, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 64, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 63, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 59, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 62, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 60, 255, 10);
  //    java.util.concurrent.TimeUnit.MILLISECONDS.sleep(500);
  //    midi(0, 57, 255, 10);
      
  //  } catch(InterruptedException e) {
  //    System.out.println("got interrupted!");
  //  } 
  //  break;
  //case 'm':
  //  //motorTarget(0, 0, 700, 286, 90);
  //  magnetic(0);
  //  break;
  
  //case 'a':
  //  motorAcceleration(0, 50, 5, 15, 0, 0, 0, 100);
  //  break;
  //case 'b':
  //   //for (int i = 0; i < cubes.length; i++) {
  //   //  println("Battery level of cube " + i + ": " + cubes[i].battery);
  //   //}
  //   basicMotor(0, true, 20, true, 20);
  //   break;
  //case 's':
  //  basicMotor(0, true, 0, true, 0);
  //  break;
    
  //case 'p':
  //  posture(0, true);
  //  break;
   
  // case 'o':
  //   posture(0, false);
  //   break;
  
  //case '`':
  //  midi(0, 57, 255, 10);
  //  break;
    
  //case '1':
  //  midi(0, 58, 255, 10);
  //  break;
    
  //case '2':
  //  midi(0, 59, 255, 10);
  //  break;
    
  //case '3':
  //  midi(0, 60, 255, 10);
  //  break;
    
  //case '4':
  //  midi(0, 61, 255, 10);
  //  break;
    
  //case '5':
  //  midi(0, 62, 255, 10);
  //  break;
    
  //case '6':
  //  midi(0, 63, 255, 10);
  //  break;
    
  //case '7':
  //  midi(0, 64, 255, 10);
  //  break;
    
  //case '8':
  //  midi(0, 65, 255, 10);
  //  break;
    
  //case '9':
  //  midi(0, 66, 255, 10);
  //  break;
    
  //case '0':
  //  midi(0, 67, 255, 10);
  //  break;
    
  //case '-':
  //  midi(0, 68, 255, 10);
  //  break;
    
  //case 'd':
  //  chase = false;
  //  spin = false;
  //  mouseDrive = false;
  //  break;
    
  //case 'a':
  //  for (int i=0; i < nCubes; ++i) {
  //    aimMotorControl(i, 380, 260);
  //  }
  //  break;
    
  //case 'k':
  //  light(0, 100, 255, 0, 0);
  //  break;
    
  //case 'm':
  //  motion(0);
  //  break;
    
  default:
    break;
    
  }
}

void mousePressed() {
  //chase = false;
  //spin = false;
  //mouseDrive=true;

  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*kinect.getVideoImage().width;
  mouseXLocation = mouseX;
  mouseYLocation = mouseY;
  mouseXLocationList[clickCount] = mouseX;
  mouseYLocationList[clickCount] = mouseY;
  //trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this

  clickCount+=1;
  if(clickCount == 3){
    trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this
  }
}

void mouseReleased() {
  mouseDrive=false;
}
