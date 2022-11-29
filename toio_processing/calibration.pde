Table table;

int calibrationMode = 0; //0: no calibration, 1: position calibration, 2: color calibration

void drawDebugWindow() {

  background(100);
  stroke(0);
  fill(255);
  rect(45, 45, 415, 410);

  image(kinect.getVideoImage(), 0, 0);
  image(kinect.getDepthImage(), 640, 0);


  if (calibrationMode>0) {// if (clickCount < 4) { //draw circle during the calibration
    String calibrationModeText = "none";
    if (calibrationMode == 1) {
      calibrationModeText = "POSITION";
    } else if (calibrationMode == 2) {
      calibrationModeText = "COLOR";
    }
    textSize(20);
    fill(255, 255, 0);

    text("CalibrationMode: " + calibrationModeText, 20, 45);

    textSize(13);
    text("Hit 'c' to switch calibration modes, 's' for saving , 'l' for loading", 20, 20);
  }



  int box_w = mouseXLocationList[1] - mouseXLocationList[0];
  int box_h = mouseYLocationList[1] - mouseYLocationList[0];
  noFill();
  stroke(255, 0, 0);
  rect(mouseXLocationList[0], mouseYLocationList[0], box_w, box_h);



  textSize(10);
  fill(255);
  text("TrackingColor", 20, 70);
  fill(trackColor);
  stroke(255);
  ellipse(40, 100, 30, 30);

  if (calibrationMode==2) {
    int loc = constrain(mouseX + mouseY*kinect.getVideoImage().width, 0, kinect.getVideoImage().width*kinect.getVideoImage().height);
    color hoverCol = kinect.getVideoImage().pixels[loc]; //need to uncomment this

    fill(hoverCol);
    stroke(255);
    ellipse(mouseX + 20, mouseY+20, 10, 10);
  }
}


void saveCalibration() {
  table = new Table();

  table.addColumn("r");
  table.addColumn("g");
  table.addColumn("b");
  table.addColumn("x");
  table.addColumn("y");


  TableRow newRow = table.addRow();
  newRow.setInt("r", (int)red(trackColor));
  newRow.setInt("g", (int)green(trackColor));
  newRow.setInt("b", (int)blue(trackColor));

  newRow.setInt("x", mouseXLocationList[0]);
  newRow.setInt("y", mouseYLocationList[0]);

  newRow = table.addRow();

  newRow.setInt("x", mouseXLocationList[1]);
  newRow.setInt("y", mouseYLocationList[1]);

  saveTable(table, "data/calibration.csv");
}

void loadCalibration() {
  table = loadTable("data/calibration.csv", "header");

  println(table.getRowCount() + " total rows in table");


  int r_ = table.getInt(0, "r");
  int g_ = table.getInt(0, "g");
  int b_ = table.getInt(0, "b");
  trackColor = color(r_, g_, b_);

  mouseXLocationList[0] = table.getInt(0, "x");
  mouseYLocationList[0] = table.getInt(0, "y");

  mouseXLocationList[1] = table.getInt(1, "x");
  mouseYLocationList[1] = table.getInt(1, "y");

  println(r_, g_, b_, mouseXLocationList[0], mouseYLocationList[0], mouseYLocationList[1], mouseYLocationList[1]);
}



void mousePressedforPosCalibration() {
  int loc = mouseX + mouseY*kinect.getVideoImage().width;
  mouseXLocation = mouseX;
  mouseYLocation = mouseY;
  mouseXLocationList[0] = mouseX;
  mouseYLocationList[0] = mouseY;

  clickCount+=1;
  if (clickCount == 3) {
    trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this
  }
}

void mouseReleasedforPosCalibration() {
  mouseXLocationList[1] = mouseX;
  mouseYLocationList[1] = mouseY;
}


void mousePressedforColorCalibration() {
  int loc = constrain(mouseX + mouseY*kinect.getVideoImage().width, 0, kinect.getVideoImage().width*kinect.getVideoImage().height);
  trackColor = kinect.getVideoImage().pixels[loc]; //need to uncomment this
}
