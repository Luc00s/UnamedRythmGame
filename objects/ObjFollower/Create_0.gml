followerChainPosition = 0;
baseFollowDistance = 15;
uniformSpacing = 15;

with (ObjFollower) {
    if (id < other.id) other.followerChainPosition++;
}

record = baseFollowDistance + (followerChainPosition * uniformSpacing);

lastX = x;
lastY = y;

defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

jumpState = "none";
jumpStartX = x;
jumpStartY = y;
jumpTargetX = x;
jumpTargetY = y;
jumpOriginalX = x;
jumpOriginalY = y;
jumpCurrentX = x;
jumpCurrentY = y;
jumpProgress = 0;
jumpDuration = 0;
jumpMaxHeight = 0;
jumpDelay = 0;
jumpDelayTimer = 0;
jumpPrepTimer = 0;
jumpPrepDuration = 30;
jumpOriginalSprite = sprite_index;
jumpIsExiting = false;
battleBoxIndex = -1;

canMove = true;

impactX = 0;
impactY = 0;
impactDecay = 0.85;