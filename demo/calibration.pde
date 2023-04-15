//functions to calibrate the toio mat and object color in the kinect camera view
Table table;

int calibrationMode = 0; //0: no calibration, 1: position calibration, 2: color calibration

//draw the debug window that contains the color camera view, depth camera view, and debug messages
void drawDebugWindow() {

  background(100);
  stroke(0);
  fill(255);
  rect(45, 45, 415, 410);

  image(kinect.getVideoImage(), 0, 0);
  image(kinect.getDepthImage(), 640, 0);

  String calibrationModeText = "PROGRAM RUNNING, NO CALIBRATION";

  if (calibrationMode == 1) {
    calibrationModeText = "POSITION";
  } else if (calibrationMode == 2) {
    calibrationModeText = "COLOR";
  }
  textSize(20);
  fill(255, 255, 0);

  text("CalibrationMode: " + calibrationModeText, 20, 580);

  textSize(13);
  text("Hit 'c' to switch calibration modes, 's' for saving , 'l' for loading", 20, 560);


  int box_w = mouseXLocationList[1] - mouseXLocationList[0];
  int box_h = mouseYLocationList[1] - mouseYLocationList[0];
  noFill();
  stroke(255, 0, 0);
  rect(mouseXLocationList[0], mouseYLocationList[0], box_w, box_h);

  textSize(10);
  fill(255);
  text("TrackingColor", 20, 500);
  fill(global_trackColor);
  stroke(255);
  ellipse(40, 520, 30, 30);

  textSize(20);
  fill(255);
  text("Camera Detection Mode: "+ cameraDetectionMode, 20, 600);
  
  textSize(20);
  fill(255);
  text("Application Mode: "+ applicationMode, 20, 620);
  
  //phase instructions
  textSize(30);
  fill(0);
  text(phaseLabel, 20, 650);


  if (calibrationMode==2) {
    int loc = constrain(mouseX + mouseY*kinect.getVideoImage().width, 0, kinect.getVideoImage().width*kinect.getVideoImage().height);
    color hoverCol = kinect.getVideoImage().pixels[loc]; //need to uncomment this

    fill(hoverCol);
    stroke(255);
    ellipse(mouseX + 20, mouseY+20, 10, 10);
  }
}

//save the calibration so we don't need to calibrate each time
void saveCalibration() {
  table = new Table();

  table.addColumn("r");
  table.addColumn("g");
  table.addColumn("b");
  table.addColumn("x");
  table.addColumn("y");


  TableRow newRow = table.addRow();
  newRow.setInt("r", (int)red(global_trackColor));
  newRow.setInt("g", (int)green(global_trackColor));
  newRow.setInt("b", (int)blue(global_trackColor));

  newRow.setInt("x", mouseXLocationList[0]);
  newRow.setInt("y", mouseYLocationList[0]);

  newRow = table.addRow();

  newRow.setInt("x", mouseXLocationList[1]);
  newRow.setInt("y", mouseYLocationList[1]);

  saveTable(table, "data/calibration.csv");
}

//load the saved calibration
void loadCalibration() {
  table = loadTable("data/calibration.csv", "header");

  println(table.getRowCount() + " total rows in table");


  int r_ = table.getInt(0, "r");
  int g_ = table.getInt(0, "g");
  int b_ = table.getInt(0, "b");
  global_trackColor = color(r_, g_, b_);

  mouseXLocationList[0] = table.getInt(0, "x");
  mouseYLocationList[0] = table.getInt(0, "y");

  mouseXLocationList[1] = table.getInt(1, "x");
  mouseYLocationList[1] = table.getInt(1, "y");

  println(r_, g_, b_, mouseXLocationList[0], mouseYLocationList[0], mouseYLocationList[1], mouseYLocationList[1]);
}

//use mouse to calibrate toio mat in camera when mouse pressed
void mousePressedforPosCalibration() {
  int loc = mouseX + mouseY*kinect.getVideoImage().width;
  mouseXLocation = mouseX;
  mouseYLocation = mouseY;
  mouseXLocationList[0] = mouseX;
  mouseYLocationList[0] = mouseY;

  clickCount+=1;
  if (clickCount == 3) {
    global_trackColor = kinect.getVideoImage().pixels[loc];
  }
}

//use mouse to calibrate toio mat in camera when mouse released
void mouseReleasedforPosCalibration() {
  mouseXLocationList[1] = mouseX;
  mouseYLocationList[1] = mouseY;
}

//use mouse to record the color being detected
void mousePressedforColorCalibration() {
  int loc = constrain(mouseX + mouseY*kinect.getVideoImage().width, 0, kinect.getVideoImage().width*kinect.getVideoImage().height);
  global_trackColor = kinect.getVideoImage().pixels[loc];
}
