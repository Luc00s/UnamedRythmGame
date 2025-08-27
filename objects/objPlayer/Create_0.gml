//Velocidade
normalSpd = 1;
runSpd = 1.75;
spd = normalSpd;

// Configurações visuais do player
defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

drawX = x;
drawY = y;
spriteCatchupFactor = 0.25;

character = "Player";
spriteAction = "";

tired = false;

// Variáveis de colisão
againstWall = {hori: 0, vert: 0};

hsp = 0;
vsp = 0;

xSpeedLeft = 0;
ySpeedLeft = 0;

cornerSlip = 8;
cornerSlipSpeedFactor = 0.5;

// Direção
spriteDir = 270;
dir = 270;

// Áudio
footstepSound = false;

depth = -bbox_bottom;

// Sistema de histórico de posições para seguidores
historyBufferSize = 150;
historyIndex = 0;
positionX = array_create(historyBufferSize, x);
positionY = array_create(historyBufferSize, y);
recordSprite = array_create(historyBufferSize, sprite_index);
recordImageXScale = array_create(historyBufferSize, image_xscale);
recordSpeed = array_create(historyBufferSize, 0);
recordDirection = array_create(historyBufferSize, 270);

// Rastreamento de movimento
movementDistance = 0;
lastRecordedX = x;
lastRecordedY = y;
minRecordDistance = 2;

// Sistema de salto para batalha
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

// Som de footstep no FMOD
//fmod_system_create_sound()