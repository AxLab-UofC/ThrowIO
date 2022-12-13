//showing images on the project to check robot pushing accuracy
import deadpixel.keystone.*;
PImage img;
PImage orange1;
float orangeXLocation = 500;
float orangeYLocation = 200;
Keystone ks;
CornerPinSurface surface;
Table table;
PGraphics offscreen;
float OrangeX = 0;
float OrangeY = 0;
int orangeCount = 0;
int rowCount = 0;

void loadOrangePosition() {
  table = loadTable("../data/random_positions.csv", "header");

  println(table.getRowCount() + " total rows in table");

  float OrangeX_ = table.getFloat(rowCount, "OrangeX");
  float OrangeY_ = table.getFloat(rowCount, "OrangeY");

  OrangeX = OrangeX_;
  OrangeY = OrangeY_;
}


void setup() {
  img = loadImage("whiteFrame.png");
  orange1 = loadImage("orange.png");

  // Keystone will only work with P3D or OPENGL renderers,
  // since it relies on texture mapping to deform
  size(1600, 900, P3D); //the size of the external monitor

  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(614, 433, 20); //614, 433, 20

  offscreen = createGraphics(614, 433, P3D);

  loadOrangePosition();
}


void draw() {

  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the
  // surface from your screen.
  PVector surfaceMouse = surface.getTransformedMouse();

  //// Draw the scene, offscreen
  offscreen.beginDraw();

  offscreen.imageMode(CORNER);
  offscreen.image(img, 0, 0, 614, 433); //tree image

  offscreen.imageMode(CENTER);

  offscreen.image(orange1, OrangeX-32, OrangeY-32, 40, 40);

  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;

  case 'n':
    //next orange
    rowCount+=1;
    loadOrangePosition();
    break;
  }
}
