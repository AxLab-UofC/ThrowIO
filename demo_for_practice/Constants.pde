int nCubes =  4;
int frameNum = 5;
int cubesPerHost = 12; // each BLE bridge can have up to 4 cubes
int maxMotorSpeed = 115;
int appFrameRate = 50;

boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;

float global_radius = 100;


String applicationMode = "practice"; //"practice", "storage", "story"
String cameraDetectionMode = "color"; //color, ir, mouse

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



Point global_ball_toio_coord;

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
int convergeDistance = 35;
int travelErrorTolerance = 15;
int rotateErrorTolerance = 10;
int time = millis();
int global_closer_toio_id;

Point start_position_0;
Point start_position_1;
Point[] start_positions;

int time2 = millis();
boolean startTime2 = false;

String phaseLabel = "";

//camera
Capture video;
Kinect kinect;

int[] mouseXLocationList = new int[4];
int[] mouseYLocationList = new int[4];

int mouseXLocation = -50;
int mouseYLocation = -50;
int clickCount = 0;
int[] story_mouseXForOrange =  new int[1];
int[] story_mouseYForOrange =  new int[1];
float[] global_xHist = {};
float[] global_yHist = {};
float[] global_dHist = {};

//ir tracking
Point ir_tracking_point;
boolean ir = false;
boolean mouse = false;

//color tracking
Point color_tracking_point;
color global_trackColor;

boolean practice_flag_trackedStuckBall = false;

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
