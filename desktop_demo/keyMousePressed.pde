//function that handle the case when a key is pressed
void keyPressed() {

  switch(key) {
  case 'c':
    println("calibration mode!");
    calibrationMode++;
    if (calibrationMode > 1) {
      calibrationMode = 0;
    }
    break;
    
  default:
    break;
  }
}
