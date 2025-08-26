battleBoxes = [];
battleBoxActive = false;
battleBoxCount = 1;
battleExitTimer = 0;
battleExitTimeout = 300; // 5 seconds timeout

//Function to count active party members (player + followers)
function getPartyMemberCount() {
    var count = 0;
    
    //Count player
    if (instance_exists(objPlayer)) {
        count++;
    }
    
    //Count followers
    count += instance_number(ObjFollower);
    
    return max(1, count); //At least 1 box
}
animationTimer = 0;
movingUp = true;

topBarY = -35;
bottomBarY = room_height + 96;
topBarTargetY = -35;
bottomBarTargetY = room_height + 96;
barAnimSpeed = 6;
barAnimTimer = 0;
topBarLerpSpeed = 0.25;
bottomBarLerpSpeed = 0.22;
topBarScrollX = 0.0;
bottomBarScrollX = 0.0;
barScrollSpeed = 0.2;
textureScrollX = 0.0;
textureScrollY = 0.0;
textureScrollSpeedX = 0.15;
textureScrollSpeedY = 0.12;