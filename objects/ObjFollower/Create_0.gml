//Fixed follower system with consistent spacing
followerChainPosition = 0;
baseFollowDistance = 15;
uniformSpacing = 15;

//Calculate position in chain more efficiently
with (ObjFollower) {
    if (id < other.id) other.followerChainPosition++;
}

//Fixed record calculation for consistent spacing
record = baseFollowDistance + (followerChainPosition * uniformSpacing);

//Simplified movement tracking for consistent following
lastX = x;
lastY = y;

//Animation and visual
defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

//Battle jump system
jumpState = "none"; // "none", "waiting", "jumping", "landed"
jumpStartX = x;
jumpStartY = y;
jumpTargetX = x;
jumpTargetY = y;
jumpCurrentX = x;
jumpCurrentY = y;
jumpProgress = 0;
jumpDuration = 0;
jumpMaxHeight = 0;
jumpDelay = 0;
jumpDelayTimer = 0;
battleBoxIndex = -1;