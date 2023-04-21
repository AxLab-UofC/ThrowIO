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
String storage_status = "store"; //can be "store" or "retrieve"

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

int handDepthThreshold = 700; //the board depth is around 800 away from the camera

int handDepth = 850;

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
int convergeDistance = 45; //45
int travelErrorTolerance = 15;
int rotateErrorTolerance = 10;
int time = millis();
int global_closer_toio_id;

Point start_position_0;
Point start_position_1;
Point[] start_positions;
Point push_position; //originally pushx and pushy


Point storage_postiion = new Point(260, 240); //this is where we want to ball to be stored, originally storage_shelfX and storage_shelfY
Point storage_drop_position = new Point(400, 240); //this is where we want to ball to be dropped
Point storage_recordPushing;

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
   
   
boolean flag_trackedStuckBall = false;

boolean flag_recordPushingToioAndBallAngle = false;
int distanceBetweenPushingToioAndBall = 45;
int distanceBetweenPushingToioAndPushLocation = 25;

float smallBox_w = (mouseXLocationList[1] - mouseXLocationList[0])/2.5;
float smallBox_h = (mouseYLocationList[1] - mouseYLocationList[0])/2;
//float handDetectStartAreaX = mouseXLocationList[0]+(mouseXLocationList[1] - mouseXLocationList[0])/2;
//float handDetectStartAreaY = mouseYLocationList[0]+smallBox_h/2;
//float handDetectEndAreaX = handDetectStartAreaX+smallBox_w;
//float handDetectEndAreaY = handDetectStartAreaY+smallBox_h;

Point handDetectStartArea = new Point (mouseXLocationList[0]+(mouseXLocationList[1] - mouseXLocationList[0])/2, mouseYLocationList[0]+smallBox_h/2);
Point handDetectEndArea = new Point (handDetectStartArea.x + smallBox_w, handDetectStartArea.y+smallBox_h);
Point handPosition = new Point (-50,-50); //orignally handPositionX and handPositionY

// Raw location
PVector storage_loc = new PVector(0, 0);
// Interpolated location
PVector  storage_lerpedLoc = new PVector(0, 0);

int story_orangeCount = 0;
Point story_orange1 = new Point(200, 250);
Point story_orange2 = new Point(350, 200);
boolean flag_trackedPushedBall = false;

int global_pushToio = 0;

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
