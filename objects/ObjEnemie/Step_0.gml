var moveX = 0;
var moveY = 0;

switch (enemyState) {
    case "wandering":
        wanderTimer++;
        
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
        spd = normalSpd;
        break;
        
    case "chasing":
        if (instance_exists(chaseTarget)) {
            var desiredDir = point_direction(x, y, chaseTarget.x, chaseTarget.y);
            var finalDir = desiredDir;
            var bestScore = -1;
            var bestAngle = desiredDir;
            
            for (var i = 0; i < avoidanceRays; i++) {
                var testAngle = desiredDir + (i - floor(avoidanceRays/2)) * 30;
                var rayScore = 0;
                var blocked = false;
                
                for (var dist = 8; dist <= avoidanceRange; dist += 4) {
                    var testX = x + lengthdir_x(dist, testAngle);
                    var testY = y + lengthdir_y(dist, testAngle);
                    
                    if (place_meeting(testX, testY, parSolid)) {
                        blocked = true;
                        break;
                    }
                    rayScore += 1;
                }
                
                if (!blocked) {
                    rayScore += 10;
                }
                
                var angleWeight = 1 - (abs(angle_difference(testAngle, desiredDir)) / 180);
                rayScore *= angleWeight;
                
                if (rayScore > bestScore) {
                    bestScore = rayScore;
                    bestAngle = testAngle;
                }
            }
            
            var distanceToTarget = point_distance(x, y, chaseTarget.x, chaseTarget.y);
            
            if (distanceToTarget <= catchRadius && !hasCaughtPlayer) {
                hasCaughtPlayer = true;
                
                var impactDir = point_direction(x, y, chaseTarget.x, chaseTarget.y);
                var impactDirBack = impactDir + 180;
                
                impactX = lengthdir_x(impactForce, impactDirBack);
                impactY = lengthdir_y(impactForce, impactDirBack);
                
                if (instance_exists(objPlayer)) {
                    objPlayer.canMove = false;
                    objPlayer.impactX = lengthdir_x(impactForce, impactDir);
                    objPlayer.impactY = lengthdir_y(impactForce, impactDir);
                }
                
                with (ObjFollower) {
                    canMove = false;
                    impactX = lengthdir_x(other.impactForce, impactDir);
                    impactY = lengthdir_y(other.impactForce, impactDir);
                }
            }
            
            if (hasCaughtPlayer) {
                moveX = 0;
                moveY = 0;
                spd = 0;
            } else {
                finalDir = bestAngle;
                moveX = lengthdir_x(1, finalDir);
                moveY = lengthdir_y(1, finalDir);
                spd = chaseSpeed;
                
                if (distanceToTarget > chaseRange) {
                    lostTargetTimer++;
                    if (lostTargetTimer >= lostTargetDelay) {
                        enemyState = "returning";
                        chaseTarget = noone;
                        lostTargetTimer = 0;
                    }
                } else {
                    lostTargetTimer = 0;
                }
            }
        } else {
            enemyState = "returning";
            chaseTarget = noone;
        }
        break;
        
    case "returning":
        var distanceToOrigin = point_distance(x, y, originalX, originalY);
        if (distanceToOrigin > 5) {
            var desiredDir = point_direction(x, y, originalX, originalY);
            var finalDir = desiredDir;
            var bestScore = -1;
            var bestAngle = desiredDir;
            
            for (var i = 0; i < avoidanceRays; i++) {
                var testAngle = desiredDir + (i - floor(avoidanceRays/2)) * 30;
                var rayScore = 0;
                var blocked = false;
                
                for (var dist = 8; dist <= avoidanceRange; dist += 4) {
                    var testX = x + lengthdir_x(dist, testAngle);
                    var testY = y + lengthdir_y(dist, testAngle);
                    
                    if (place_meeting(testX, testY, parSolid)) {
                        blocked = true;
                        break;
                    }
                    rayScore += 1;
                }
                
                if (!blocked) {
                    rayScore += 10;
                }
                
                var angleWeight = 1 - (abs(angle_difference(testAngle, desiredDir)) / 180);
                rayScore *= angleWeight;
                
                if (rayScore > bestScore) {
                    bestScore = rayScore;
                    bestAngle = testAngle;
                }
            }
            
            finalDir = bestAngle;
            moveX = lengthdir_x(1, finalDir);
            moveY = lengthdir_y(1, finalDir);
            spd = returnSpeed;
        } else {
            enemyState = "wandering";
            isWandering = false;
            wanderTimer = 0;
        }
        break;
        
    case "caught":
        moveX = 0;
        moveY = 0;
        spd = 0;
        break;
}

if (moveX != 0 or moveY != 0) {
    dir = point_direction(0, 0, moveX, moveY);
    hsp = approach(hsp, lengthdir_x(spd, dir), .15);
    vsp = approach(vsp, lengthdir_y(spd, dir), .15);
} else {
    hsp = approach(hsp, 0, .15);
    vsp = approach(vsp, 0, .15);
}

xSpeedLeft += hsp;
ySpeedLeft += vsp;

if (abs(hsp) > 0.1 or abs(vsp) > 0.1) {
    image_speed = (abs(hsp) + abs(vsp)) * (spd / normalSpd);
    image_speed = clamp(image_speed, 0.5, 3.0);
    
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

xSpeedLeft += impactX;
ySpeedLeft += impactY;

collision();

impactX *= impactDecay;
impactY *= impactDecay;

if (abs(impactX) < 0.1) impactX = 0;
if (abs(impactY) < 0.1) impactY = 0;

if (hasCaughtPlayer) {
    battleTransitionTimer++;
    
    var impactFinished = (abs(impactX) < 0.1 && abs(impactY) < 0.1);
    var playerImpactFinished = true;
    var followerImpactFinished = true;
    
    if (instance_exists(objPlayer)) {
        playerImpactFinished = (abs(objPlayer.impactX) < 0.1 && abs(objPlayer.impactY) < 0.1);
    }
    
    with (ObjFollower) {
        if (abs(impactX) >= 0.1 || abs(impactY) >= 0.1) {
            followerImpactFinished = false;
        }
    }
    
    if (impactFinished && playerImpactFinished && followerImpactFinished && battleTransitionTimer >= battleTransitionDelay) {
        if (instance_exists(objBattleControl)) {
            with (objBattleControl) {
                if(!battleBoxActive) {
                    battleBoxActive = true;
                    animationTimer = 0;
                    movingUp = true;
                    
                    topBarTargetY = 0;
                    bottomBarTargetY = room_height + 48;
                    barAnimTimer = 0;
                    
                    var screenWidth = 320;
                    var boxWidth = 68;
                    var totalBoxWidth = boxWidth * battleBoxCount;
                    var remainingSpace = screenWidth - totalBoxWidth;
                    var spacing = remainingSpace / (battleBoxCount + 1);
                    
                    for(var i = 0; i < battleBoxCount; i++) {
                        var boxX = spacing + (i * (boxWidth + spacing));
                        var startY = room_height + 50;
                        var targetY = room_height - 58;
                        
                        var battleBox = {
                            x: boxX,
                            y: startY,
                            startY: startY,
                            targetY: targetY,
                            velocity: 0,
                            animationDelay: i * 8,
                            hasStarted: false,
                            springStrength: 0.1,
                            damping: 0.7,
                            impactOffset: 0,
                            impactVelocity: 0,
                            hasBeenHit: false
                        };
                        
                        array_push(battleBoxes, battleBox);
                    }
                    
                    var characterList = [];
                    var boxIndex = 0;
                    
                    if (instance_exists(objPlayer)) {
                        array_push(characterList, {inst: instance_find(objPlayer, 0), type: "player"});
                    }
                    
                    var followerCount = instance_number(ObjFollower);
                    for (var i = 0; i < followerCount; i++) {
                        var followerInst = instance_find(ObjFollower, i);
                        array_push(characterList, {inst: followerInst, type: "follower"});
                    }
                    
                    for (var i = 0; i < min(array_length(characterList), array_length(battleBoxes)); i++) {
                        var characterData = characterList[i];
                        var characterInst = characterData.inst;
                        var battleBox = battleBoxes[i];
                        
                        with (characterInst) {
                            jumpState = "waiting";
                            jumpOriginalX = x;
                            jumpOriginalY = y;
                            jumpOriginalSprite = sprite_index;
                            jumpStartX = x;
                            jumpStartY = y;
                            jumpTargetX = battleBox.x + 34;
                            jumpTargetY = battleBox.targetY + 24;
                            jumpProgress = 0;
                            jumpDelay = i * 8;
                            jumpDelayTimer = 0;
                            jumpPrepTimer = 0;
                            jumpPrepDuration = 30;
                            jumpIsExiting = false;
                            battleBoxIndex = i;
                            
                            var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                            jumpDuration = max(60, min(100, jumpDistance * 0.35));
                            jumpMaxHeight = max(80, jumpDistance * 0.5);
                        }
                    }
                }
            }
        }
        
        hasCaughtPlayer = false;
        battleTransitionTimer = 0;
        enemyState = "caught";
        chaseTarget = noone;
        lostTargetTimer = 0;
    }
}

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

if (enemyState == "wandering" && (playerDetected || followerDetected)) {
    var closestTarget = noone;
    var closestDistance = chaseRange + 1;
    
    for (var i = 0; i < array_length(detectedTargets); i++) {
        var targetInfo = detectedTargets[i];
        if (targetInfo.distance < closestDistance) {
            closestDistance = targetInfo.distance;
            closestTarget = targetInfo.target;
        }
    }
    
    if (closestTarget != noone) {
        enemyState = "chasing";
        chaseTarget = closestTarget;
        lostTargetTimer = 0;
    }
}