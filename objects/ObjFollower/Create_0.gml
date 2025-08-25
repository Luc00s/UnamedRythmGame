//Target to follow (will be set to objPlayer instance)
target = noone;

//Position tracking
followDistance = 48;
positionQueue = ds_list_create();
actionQueue = ds_list_create();
maxQueueSize = 30;

//Movement
hsp = 0;
vsp = 0;
moveSpeed = 1;
catchUpSpeed = 2;

//Drawing
drawX = x;
drawY = y;
spriteCatchupFactor = 0.25;

//Character sprite settings (using player sprites)
character = "Player";
spriteAction = "";
spriteDir = 270;
dir = 270;
image_speed = 0;

//Animation
defaultBlinkTimer = [room_speed/2, room_speed*6];
blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);

//Find the player instance to follow
if (instance_exists(objPlayer)) {
    target = instance_find(objPlayer, 0);
    
    //Initialize queues with current player state
    for (var i = 0; i < maxQueueSize; i++) {
        ds_list_add(positionQueue, [target.x, target.y]);
        ds_list_add(actionQueue, [target.spriteAction, target.spriteDir]);
    }
}

//Depth management
depth = -bbox_bottom;