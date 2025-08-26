//Auto-update battle box count based on party members
battleBoxCount = getPartyMemberCount();

//Manual override keys for testing (optional)
if(keyboard_check_pressed(ord("1"))) {
    battleBoxCount = 1;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("2"))) {
    battleBoxCount = 2;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("3"))) {
    battleBoxCount = 3;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("4"))) {
    battleBoxCount = 4;
    battleBoxes = [];
    battleBoxActive = false;
}

if(keyboard_check_pressed(vk_space)) {
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
        
        //Create ordered character list: player first, then followers by creation order
        var characterList = [];
        var boxIndex = 0;
        
        //Add player first
        if (instance_exists(objPlayer)) {
            array_push(characterList, {inst: instance_find(objPlayer, 0), type: "player"});
        }
        
        //Add followers in creation order (instance_find already returns in creation order)
        var followerCount = instance_number(ObjFollower);
        for (var i = 0; i < followerCount; i++) {
            var followerInst = instance_find(ObjFollower, i);
            array_push(characterList, {inst: followerInst, type: "follower"});
        }
        
        //Assign each character to their battle box in order with delayed starts
        for (var i = 0; i < min(array_length(characterList), array_length(battleBoxes)); i++) {
            var character = characterList[i];
            with (character.inst) {
                jumpState = "waiting";
                jumpStartX = x;
                jumpStartY = y;
                jumpTargetX = other.battleBoxes[i].x + 34; // Center of battle box
                jumpTargetY = other.battleBoxes[i].targetY + 24; // Lower behind battle box
                jumpProgress = 0;
                jumpDelay = i * 8; // Same delay as battle boxes
                jumpDelayTimer = 0;
                
                //Calculate jump duration and height - even more vertical and consistent timing
                var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                jumpDuration = max(45, min(80, jumpDistance * 0.25)); // Slower, more dramatic timing
                jumpMaxHeight = max(120, jumpDistance * 0.8); // Even more vertical
                
                battleBoxIndex = i;
            }
        }
    } else {
        movingUp = !movingUp;
        animationTimer = 0;
        
        for(var i = 0; i < array_length(battleBoxes); i++) {
            var box = battleBoxes[i];
            box.velocity = 0;
            box.hasStarted = false;
            
            if(movingUp) {
                // Entering battle - boxes animate in order (0, 1, 2, 3...)
                box.animationDelay = i * 8;
                box.targetY = room_height - 58;
                topBarTargetY = 0;
                bottomBarTargetY = room_height + 48;
            } else {
                // Exiting battle - boxes animate in reverse order (3, 2, 1, 0...)
                box.animationDelay = (array_length(battleBoxes) - 1 - i) * 8;
                box.targetY = room_height + 50;
                topBarTargetY = -35;
                bottomBarTargetY = room_height + 96;
            }
            
            battleBoxes[i] = box;
        }
    }
}

if(battleBoxActive) {
    animationTimer++;
    
    // Check for character landings and trigger impact effects
    var characterList = [];
    if (instance_exists(objPlayer)) {
        array_push(characterList, {inst: instance_find(objPlayer, 0), type: "player"});
    }
    var followerCount = instance_number(ObjFollower);
    for (var i = 0; i < followerCount; i++) {
        var followerInst = instance_find(ObjFollower, i);
        array_push(characterList, {inst: followerInst, type: "follower"});
    }
    
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        
        if(animationTimer >= box.animationDelay) {
            box.hasStarted = true;
        }
        
        if(box.hasStarted) {
            var distance = box.targetY - box.y;
            var force = distance * box.springStrength;
            box.velocity += force;
            box.velocity *= box.damping;
            box.y += box.velocity;
            
            // Check for character landing impact
            if(i < array_length(characterList) && !box.hasBeenHit) {
                var character = characterList[i];
                with (character.inst) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        other.battleBoxes[i].impactOffset = 15;
                        other.battleBoxes[i].impactVelocity = 0;
                        other.battleBoxes[i].hasBeenHit = true;
                    }
                }
            }
            
            // Handle impact spring effect
            if(abs(box.impactOffset) > 0.1 || abs(box.impactVelocity) > 0.1) {
                box.impactVelocity += -box.impactOffset * 0.08;
                box.impactVelocity *= 0.95;
                box.impactOffset += box.impactVelocity;
                
                if(abs(box.impactOffset) < 0.1 && abs(box.impactVelocity) < 0.1) {
                    box.impactOffset = 0;
                    box.impactVelocity = 0;
                }
            }
        }
        
        battleBoxes[i] = box;
    }
    
}

barAnimTimer++;

var topLerpAmount = topBarLerpSpeed + sin(barAnimTimer * 0.3) * 0.05;
var bottomLerpAmount = bottomBarLerpSpeed + cos(barAnimTimer * 0.25) * 0.03;

topLerpAmount = clamp(topLerpAmount, 0.15, 0.4);
bottomLerpAmount = clamp(bottomLerpAmount, 0.12, 0.35);

topBarY = lerp(topBarY, topBarTargetY, topLerpAmount);
bottomBarY = lerp(bottomBarY, bottomBarTargetY, bottomLerpAmount);

//Top bar scrolls right (+)
topBarScrollX += barScrollSpeed;
if(topBarScrollX >= 32) topBarScrollX -= 32;

//Bottom bar scrolls left (-)
bottomBarScrollX -= barScrollSpeed;
if(bottomBarScrollX <= -32) bottomBarScrollX += 32;

textureScrollX += textureScrollSpeedX;
textureScrollY -= textureScrollSpeedY;
if(textureScrollX >= 16) textureScrollX -= 16;
if(textureScrollY <= -16) textureScrollY += 16;