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

//Initialize arrays to store the history of player's position and sprite details
positionX = [];
positionY = [];
recordSprite = [];
recordImageXScale = [];

//Define how many steps of history to record
var record_length = 90;

//Pre-fill the arrays with the player's starting state
for (var i = 0; i < record_length; i++) {
    positionX[i] = x;
    positionY[i] = y;
    recordSprite[i] = sprite_index;
    recordImageXScale[i] = image_xscale;
}