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
                // Ensure clean state for battle entry
                jumpState = "waiting";
                jumpOriginalX = x; // Store current position
                jumpOriginalY = y;
                jumpOriginalSprite = sprite_index; // Store current sprite
                jumpStartX = x;
                jumpStartY = y;
                jumpTargetX = other.battleBoxes[i].x + 34; // Center of battle box
                jumpTargetY = other.battleBoxes[i].targetY + 24; // Lower behind battle box
                jumpProgress = 0;
                jumpDelay = i * 8; // Same delay as battle boxes
                jumpDelayTimer = 0;
                jumpPrepTimer = 0; // Timer for ground preparation phase
                jumpPrepDuration = 30; // 0.5 seconds at 60 fps
                jumpIsExiting = false; // This is an entry jump
                
                //Calculate jump duration and height - slower and lower
                var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                jumpDuration = max(60, min(100, jumpDistance * 0.35)); // Much slower timing
                jumpMaxHeight = max(80, jumpDistance * 0.5); // Lower height
                
                battleBoxIndex = i;
                
            }
        }
    } else {
        movingUp = !movingUp;
        animationTimer = 0;
        
        // Don't reset characters immediately - let them complete their exit jumps
        // The normal exit detection will handle cleanup when jumps are complete
        
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
                // Reset box impact state for next battle
                box.hasBeenHit = false;
                box.impactOffset = 0;
                box.impactVelocity = 0;
                
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
            
            // Make character jump when their box starts exiting
            if (!movingUp && i < array_length(characterList)) {
                var character = characterList[i];
                with (character.inst) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        jumpState = "jumping"; // Jump instantly when box starts exiting
                        jumpStartX = x;
                        jumpStartY = y;
                        jumpTargetX = jumpOriginalX;
                        jumpTargetY = jumpOriginalY;
                        jumpProgress = 0;
                        jumpIsExiting = true; // Mark this as an exit jump
                        
                        var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                        jumpDuration = max(60, min(100, jumpDistance * 0.35));
                        jumpMaxHeight = max(80, jumpDistance * 0.5);
                    }
                }
            }
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
                box.impactVelocity *= 0.8;
                box.impactOffset += box.impactVelocity;
                
                if(abs(box.impactOffset) < 0.1 && abs(box.impactVelocity) < 0.1) {
                    box.impactOffset = 0;
                    box.impactVelocity = 0;
                }
            }
        }
        
        battleBoxes[i] = box;
    }
    
    // Check if exiting battle mode and all boxes are off screen
    if (!movingUp) {
        var allBoxesGone = true;
        for (var i = 0; i < array_length(battleBoxes); i++) {
            if (battleBoxes[i].y < room_height + 100) {
                allBoxesGone = false;
                break;
            }
        }
        
        // More lenient character check - only require they're not jumping or landed on boxes
        var allCharactersReturned = true;
        if (instance_exists(objPlayer)) {
            with (objPlayer) {
                if (jumpState == "landed" || jumpState == "jumping") {
                    allCharactersReturned = false;
                }
            }
        }
        
        with (ObjFollower) {
            if (jumpState == "landed" || jumpState == "jumping") {
                allCharactersReturned = false;
            }
        }
        
        // Disable battle mode when everything is back to normal
        if (allBoxesGone || allCharactersReturned) {
            battleBoxActive = false;
            battleBoxes = [];
            movingUp = true; // Reset for next entry
            
            // Force reset any characters that might be stuck
            if (instance_exists(objPlayer)) {
                with (objPlayer) {
                    if (jumpState != "none" && jumpState != "jumping") {
                        jumpState = "none";
                        battleBoxIndex = -1;
                    }
                }
            }
            
            with (ObjFollower) {
                if (jumpState != "none" && jumpState != "jumping") {
                    jumpState = "none";
                    battleBoxIndex = -1;
                }
            }
        }
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
if(textureScrollX >= 32) textureScrollX -= 32;
if(textureScrollY <= -32) textureScrollY += 32;