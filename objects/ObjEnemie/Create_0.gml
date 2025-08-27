normalSpd = 0.5;
spd = normalSpd;

defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

drawX = x;
drawY = y;
spriteCatchupFactor = 0.25;

character = "Player";
spriteAction = "";

againstWall = {hori: 0, vert: 0};

hsp = 0;
vsp = 0;

xSpeedLeft = 0;
ySpeedLeft = 0;

cornerSlip = 8;
cornerSlipSpeedFactor = 0.5;

spriteDir = 270;
dir = 270;

footstepSound = false;

depth = -bbox_bottom;

originalX = x;
originalY = y;
maxWanderDistance = 64;

wanderTimer = 0;
wanderDelay = irandom_range(60, 180);
wanderDuration = irandom_range(30, 120);
isWandering = false;

targetDir = 270;

currentDir = 270;
dirSmoothness = 0.15;
wanderRadius = 24;
collisionAvoidDistance = 20;
lastDirectionChange = 0;
directionChangeInterval = irandom_range(60, 150);
stuckTimer = 0;
lastPosition = [x, y];
positionCheckInterval = 30;
wanderMomentum = 0;
maxWanderMomentum = 1.2;
momentumDecay = 0.98;
pauseTimer = 0;
pauseChance = 0.08;
pauseDuration = irandom_range(20, 80);

visionRange = 80;
visionAngle = 60;
debugVision = true;
playerDetected = false;
followerDetected = false;
detectedTargets = [];
rayCount = 8;
raycastResults = [];
maxRayDistance = 120;

enemyState = "wandering";
chaseTarget = noone;
chaseSpeed = 0.8;
returnSpeed = 0.7;
chaseRange = maxRayDistance;
lostTargetTimer = 0;
lostTargetDelay = 120;

avoidanceRays = 5;
avoidanceRange = 24;

catchRadius = 12;
hasCaughtPlayer = false;

impactForce = 3;
impactDecay = 0.85;
impactX = 0;
impactY = 0;

battleTransitionTimer = 0;
battleTransitionDelay = 30;