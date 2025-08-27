wanderTimer++;

var moveX = 0;
var moveY = 0;

if (!isWandering) {
    if (wanderTimer >= wanderDelay) {
        isWandering = true;
        wanderTimer = 0;
        wanderDelay = irandom_range(60, 180);
        wanderDuration = irandom_range(30, 120);
        
        targetDir = choose(0, 45, 90, 135, 180, 225, 270, 315);
    }
} else {
    if (wanderTimer >= wanderDuration) {
        isWandering = false;
        wanderTimer = 0;
    } else {
        var distanceFromOriginal = point_distance(x, y, originalX, originalY);
        
        if (distanceFromOriginal < maxWanderDistance) {
            moveX = lengthdir_x(1, targetDir);
            moveY = lengthdir_y(1, targetDir);
        } else {
            targetDir = point_direction(x, y, originalX, originalY);
            moveX = lengthdir_x(1, targetDir);
            moveY = lengthdir_y(1, targetDir);
        }
    }
}

if (moveX != 0 or moveY != 0) {
    dir = point_direction(0, 0, moveX, moveY);
    hsp = approach(hsp, lengthdir_x(spd, dir), .15);
    vsp = approach(vsp, lengthdir_y(spd, dir), .15);
} else {
    hsp = approach(hsp, 0, .15);
    vsp = approach(vsp, 0, .15);
}

if (abs(hsp) > 0.1 or abs(vsp) > 0.1) {
    image_speed = abs(hsp) + abs(vsp);
    image_speed = clamp(image_speed, 0, spd);
    
    spriteDir += angle_difference(dir, spriteDir) * .25;
    spriteDir = wrap(spriteDir, 0, 360);
    
    spriteAction = "Walk";
    
    if (image_index > 1 and image_index <= 2) {
        if (footstepSound = false) audio_play_sound(sndFootstep0, 0, false);
        footstepSound = true;
    } else if (image_index > 3 and image_index < 4) {
        if (footstepSound = false) audio_play_sound(sndFootstep1, 0, false);
        footstepSound = true;
    } else footstepSound = false;
} else {
    blinkTimer = approach(blinkTimer, 0, 1);
    if (blinkTimer = 0) blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
    else if (blinkTimer <= 8) image_index = 1;
    else image_index = 0;
    
    spriteAction = "";
}

var _sprite = $"spr{character+spriteAction}Down";
switch (round(spriteDir/(360/8))) {
    case 0: case 8: _sprite = $"spr{character+spriteAction}Right"; break;
    case 1: _sprite = $"sprPlayer{spriteAction}UpRight"; break;
    case 2: _sprite = $"spr{character+spriteAction}Up"; break;
    case 3: _sprite = $"sprPlayer{spriteAction}UpLeft"; break;
    case 4: _sprite = $"spr{character+spriteAction}Left"; break;
    case 5: _sprite = $"sprPlayer{spriteAction}DownLeft"; break;
    case 6: _sprite = $"spr{character+spriteAction}Down"; break;
    case 7: _sprite = $"sprPlayer{spriteAction}DownRight"; break;
}
sprite_index = asset_get_index(_sprite);

collision();

x += hsp;
y += vsp;

drawX = x;
drawY = y;

depth = -bbox_bottom;

playerDetected = false;
followerDetected = false;
detectedTargets = [];
raycastResults = [];

for (var r = 0; r < rayCount; r++) {
    var rayAngle = spriteDir - visionAngle / 2 + (visionAngle / (rayCount - 1)) * r;
    
    var rayEndX = x + lengthdir_x(maxRayDistance, rayAngle);
    var rayEndY = y + lengthdir_y(maxRayDistance, rayAngle);
    
    var stepSize = 2;
    var rayDistance = point_distance(x, y, rayEndX, rayEndY);
    var steps = ceil(rayDistance / stepSize);
    var stepX = lengthdir_x(stepSize, rayAngle);
    var stepY = lengthdir_y(stepSize, rayAngle);
    
    var rayX = x;
    var rayY = y;
    var hitWall = false;
    var hitDistance = maxRayDistance;
    var hitTarget = noone;
    
    for (var s = 0; s < steps; s++) {
        rayX += stepX;
        rayY += stepY;
        
        if (place_meeting(rayX, rayY, parSolid)) {
            hitWall = true;
            hitDistance = point_distance(x, y, rayX, rayY);
            break;
        }
        
        if (instance_exists(objPlayer)) {
            var playerCheckRadius = 8;
            if (point_distance(rayX, rayY, objPlayer.x, objPlayer.y) <= playerCheckRadius) {
                playerDetected = true;
                hitTarget = objPlayer;
                hitDistance = point_distance(x, y, rayX, rayY);
                array_push(detectedTargets, {target: objPlayer, distance: hitDistance, angle: rayAngle});
                break;
            }
        }
        
        with (ObjFollower) {
            var followerCheckRadius = 8;
            if (point_distance(rayX, rayY, x, y) <= followerCheckRadius) {
                other.followerDetected = true;
                hitTarget = id;
                hitDistance = point_distance(other.x, other.y, rayX, rayY);
                array_push(other.detectedTargets, {target: id, distance: hitDistance, angle: rayAngle});
                break;
            }
        }
        
        if (hitTarget != noone) break;
    }
    
    array_push(raycastResults, {
        angle: rayAngle,
        endX: x + lengthdir_x(hitDistance, rayAngle),
        endY: y + lengthdir_y(hitDistance, rayAngle),
        hitWall: hitWall,
        hitTarget: hitTarget,
        distance: hitDistance
    });
}