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