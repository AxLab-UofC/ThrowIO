int nCubes =  4;
int frameNum = 5;
int cubesPerHost = 12; // each BLE bridge can have up to 4 cubes
int maxMotorSpeed = 115;
int appFrameRate = 50;

boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;

float global_radius = 100;

//boolean checking_flag = false;
//Point[] checking_points;



String applicationMode = "desktop";
boolean phase1_seeBall = false;
boolean phase2_ballSticks = false;
boolean phase3_facePushLocation = false;
boolean phase4_travelToBallToPush = false;
boolean phase5_rotateBallToPushLocation = false;
boolean phase6_pushDone = false;
boolean phase7_findTangentPoints = false;
boolean phase8_toioTravelToPrepLocation = false;
boolean phase9_rotateToDrop = false;
boolean phase10_dropSucceed = false;
boolean flag_findPushedBallLocation = false;
boolean flag_needBackout = false;

Point global_ball;

Point[] travel_points;
Point[] tangent_points;

Point backout_0;
Point backout_1;

boolean flag_prepareBackout = false;
boolean flag_recordToioAndBallAngle = false;
float turnDegree2 = 0;
float turnDegree1 = 0;
float turnDegree0 = 0;
float distance_cube0_ball;
float distance_cube1_ball;
boolean flag_rotate0 = false;
boolean flag_rotate1 = false;
boolean startTime = false;
int convergeDistance = 45;
int time = millis();
int global_closer_toio_id;

float startPositionX1;
float startPositionY1;
float startPositionX2;
float startPositionY2;

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
