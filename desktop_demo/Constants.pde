int nCubes =  4;
int frameNum = 5;
int cubesPerHost = 12; // each BLE bridge can have up to 4 cubes
int maxMotorSpeed = 115;
int appFrameRate = 50;

boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;

float global_radius = 120;

boolean checking_flag = false;
Point[] checking_points;
float distance_cube0_ball;
float distance_cube1_ball;


//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;

//we'll keep the cubes here
Cube[] cubes;

class Point {
  float x;
  float y;
  
  Point (float x_, float y_) {  
    x = x_; 
    y = y_; 
  } 
}
