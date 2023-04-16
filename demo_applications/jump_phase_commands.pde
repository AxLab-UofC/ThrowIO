//function to jump to phase 1
void jumpToPhase1() {
  phase1_seeBall = false; //phase 1
  phase2_ballSticks = false; //phase 2
  phase3_facePushLocation = false; //phase 3
  phase4_travelToBallToPush = false; //phase 4
  phase5_rotateBallToPushLocation = false; //phase 5
  phase6_pushDone = false; //phase 6
  phase7_findTangentPoints = false; //phase 7
  phase8_toioTravelToPrepLocation = false; //phase 8
  phase9_rotateToDrop = false; //phase 9
  phase10_dropSucceed = false; //phase 10
}

//function to jump to phase 3
void jumpToPhase3() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = false; //phase 3
  phase4_travelToBallToPush = false; //phase 4
  phase5_rotateBallToPushLocation = false; //phase 5
  phase6_pushDone = false; //phase 6
  phase7_findTangentPoints = false; //phase 7
  phase8_toioTravelToPrepLocation = false; //phase 8
  phase9_rotateToDrop = false; //phase 9
  phase10_dropSucceed = false; //phase 10
}

//function to jump to phase 7
void jumpToPhase7() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
  phase7_findTangentPoints = false; //phase 7
  phase8_toioTravelToPrepLocation = false; //phase 8
  phase9_rotateToDrop = false; //phase 9
  phase10_dropSucceed = false; //phase 10
}

//function to jump to phase 10
void jumpToPhase10() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
  phase7_findTangentPoints = true; //phase 7
  phase8_toioTravelToPrepLocation = true; //phase 8
  phase9_rotateToDrop = true; //phase 9
  phase10_dropSucceed = false; //phase 10
}

//function to jump to phase 11
void jumpToPhase11() {
  phase1_seeBall = true; //phase 1
  phase2_ballSticks = true; //phase 2
  phase3_facePushLocation = true; //phase 3
  phase4_travelToBallToPush = true; //phase 4
  phase5_rotateBallToPushLocation = true; //phase 5
  phase6_pushDone = true; //phase 6
  phase7_findTangentPoints = true; //phase 7
  phase8_toioTravelToPrepLocation = true; //phase 8
  phase9_rotateToDrop = true; //phase 9
  phase10_dropSucceed = true; //phase 10
}
