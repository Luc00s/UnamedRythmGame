//Velocidade
normalSpd = 1;
runSpd = 1.75;
spd = normalSpd;

//Coisas do sprite do player
defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

drawX = x;
drawY = y;
spriteCatchupFactor = 0.25;

character = "Player";
spriteAction = "";

tired = false;

//Váriaveis para a colisão
againstWall = {hori: 0, vert: 0};

hsp = 0;
vsp = 0;

xSpeedLeft = 0;
ySpeedLeft = 0;

cornerSlip = 8;
cornerSlipSpeedFactor = 0.5;

//Direção
spriteDir = 270;
dir = 270;

//Sons
footstepSound = false;

//Consertando o depth
depth = -bbox_bottom;

//Enhanced position history system using circular buffer
historyBufferSize = 150;
historyIndex = 0;
positionX = array_create(historyBufferSize, x);
positionY = array_create(historyBufferSize, y);
recordSprite = array_create(historyBufferSize, sprite_index);
recordImageXScale = array_create(historyBufferSize, image_xscale);
recordSpeed = array_create(historyBufferSize, 0);
recordDirection = array_create(historyBufferSize, 270);

//Movement tracking for better follower logic
movementDistance = 0;
lastRecordedX = x;
lastRecordedY = y;
minRecordDistance = 2;

//Battle jump system
jumpState = "none"; // "none", "waiting", "preparing", "jumping", "landed"
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