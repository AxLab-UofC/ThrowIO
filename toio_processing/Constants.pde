//constants and libraries
import oscP5.*;
import netP5.*;
import processing.serial.*;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.tests.*;
import processing.video.*;
import org.openkinect.processing.*;
import org.openkinect.*;
import javax.swing.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

int nCubes =  4;
int frameNum = 5;
int cubesPerHost = 12; // each BLE bridge can have up to 4 cubes
int maxMotorSpeed = 100;
int appFrameRate = 50;

String applicationMode = "ufo"; //can be "ufo", "story", "storage", "practice"

//camera
Capture video;
Kinect kinect;
color trackColor;
float threshold = 40; //150 for red
int clickCount = 0;
int mouseXLocation = -50;
int mouseYLocation = -50;
boolean phase2_ballSticks = false;
int[] mouseXLocationList = new int[4];
int[] mouseYLocationList = new int[4];
int[] story_mouseXForOrange =  new int[1];
int[] story_mouseYForOrange =  new int[1];
//float scaledX = -1000;
//float scaledY = -1000;
int global_closer_toio_id = 0;
//for OSC
OscP5 oscP5;
//where to send the commands to
NetAddress[] server;
//int cubesPerHost = 4; // each BLE bridge can have up to 4 cubes

//we'll keep the cubes here
Cube[] cubes;
//int nCubes =  4;

boolean mouseDrive = false;
boolean chase = false;
boolean spin = false;

//global variables that helper functions would modify
float global_radius = 120;
float global_x = 0.0;
float global_y = 0.0;
float global_x2 = 0.0;
float global_y2 = 0.0;
float global_finalx = 0.0;
float global_finaly = 0.0;
float global_xprime = 0.0;
float global_yprime = 0.0;
float global_c0_dist = 0.0;
float global_c1_dist = 0.0;
float global_ball_x = 0; //sx
float global_ball_y = 0; //sy
float global_toio_center_x = 0; //cx
float global_toio_center_y = 0; //cy
float global_scaledX = 60;
float global_scaledY = 100;
String global_furtherTangentPoint;
float global_backoutx0 = 0;
float global_backouty0 = 0;
float global_backoutx1 = 0;
float global_backouty1 = 0;
float global_bitMoreThanRadius = global_radius+20;
float global_avgX = 0;
float global_avgY = 0;
int global_count = 0;
float global_avgDepth = 0;
float[] global_xHist = {};
float[] global_yHist = {};
float[] global_dHist = {};
int convergeDistance = 45;
int distanceBetweenPushingToioAndBall = 45;
int distanceBetweenPushingToioAndPushLocation = 25;
int time = millis();
boolean startTime = false;
float turnDegree1 = 0;
float turnDegree0 = 0;

boolean phase7_findTangentPoints = false;
boolean phase8_toioTravelToPrepLocation = false;
boolean phase10_dropSucceed = false;
boolean phase1_seeBall = false;
boolean phase9_rotateToDrop = false;
boolean phase4_travelToBallToPush = false;
boolean phase5_rotateBallToPushLocation = false;
boolean phase6_pushDone = false;
boolean phase3_facePushLocation = false;

boolean flag_rotate0 = false;
boolean flag_rotate1 = false;
boolean flag_recordToioAndBallAngle = false;
boolean flag_recordPushingToioAndBallAngle = false;
boolean flag_prepareBackout = false;

float[] xHist = {};
float[] yHist = {};
float[] dHist = {};
int rawDepth = 0;
float depthDiff;
float xDiff;
float throwDegree;
float avgZVelocity = 0.0;
float avgXVelocity = 0.0;
int time2 = millis();
boolean startTime2 = false;
float bulletx = 0;
float bullety = 0;
float monitorAdjustment = 130;

// A reference to our box2d world
Box2DProcessing box2d;

float monitorWidth = displayWidth;
float monitorHeight = displayHeight;
float ySpeed = 1;
float xSpeed = 1;
float ycoord = 300;
float xcoord = 600;
boolean ufo_flag_hitTarget = false;
float hitX = 720;
float pushx = 360; //400
float pushy = 240; //300
boolean flag_findPushedBallLocation = false;
int pushToio = 0;
boolean ballDidNotStick = false;
int scoreCount = 0;
boolean flag_needBackout = false;


SoundFile ufo_file;
SoundFile cannon_file;
boolean ufo_flag_killUFO = false;
boolean ufo_flag_bombSound = false;
boolean ufo_flag_cannonSound = false;
boolean ufo_flag_kill_particle = false;
boolean ufo_flag_killBall = false;
boolean ufo_flag_startCrash = false;
boolean ufo_flag_startSelfCrash = false;
String  ufo_instruction = "Throw ball! Hit UFO!";
boolean ufo_flag_nextBall = false;
boolean ufo_flag_startSprinkle = false;
boolean ufo_flag_addParticle = false;
int ufo_ballCount = 0;

float story_orangex1 = 150;
float story_orangey1 = 200;
float story_orangex2 = 400;
float story_orangey2 = 150;
int story_orangeCount = 0;

boolean story_flag_trackedStuckBall = false;
boolean story_flag_trackedPushedBall = false;

//this is where we want to ball to be stored
float storage_shelfX = 240;
float storage_shelfY = 270;
String storage_status = "store"; //can be "store" or "retrieve"

float storage_dropLocationX = 400;
float storage_dropLocationY = 270;

float storage_recordPushingX = 0;
float storage_recordPushingY = 0;

float startPositionX1 = 100;
float startPositionY1 = 100;
float startPositionX2 = 600;
float startPositionY2 = 250;
float handPositionX = -50;
float handPositionY = -50;

// Raw location
PVector storage_loc = new PVector(0, 0);
// Interpolated location
PVector  storage_lerpedLoc = new PVector(0, 0);

float smallBox_w = (mouseXLocationList[1] - mouseXLocationList[0])/2.5;
float smallBox_h = (mouseYLocationList[1] - mouseYLocationList[0])/2;
float handDetectStartAreaX = mouseXLocationList[0]+(mouseXLocationList[1] - mouseXLocationList[0])/2;
float handDetectStartAreaY = mouseYLocationList[0]+smallBox_h/2;
float handDetectEndAreaX = handDetectStartAreaX+smallBox_w;
float handDetectEndAreaY = handDetectStartAreaY+smallBox_h;
