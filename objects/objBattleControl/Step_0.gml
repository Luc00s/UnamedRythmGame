// Atualização automática das caixas de batalha
battleBoxCount = getPartyMemberCount();

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

// Test HP counter functionality with keyboard shortcuts
if(keyboard_check_pressed(ord("Q"))) {
    damagePlayer("violet", 10); // Q to damage Violet by 10
}
if(keyboard_check_pressed(ord("A"))) {
    healPlayer("violet", 10); // A to heal Violet by 10
}
if(keyboard_check_pressed(ord("W"))) {
    damagePlayer("red", 15); // W to damage Red by 15
}
if(keyboard_check_pressed(ord("S"))) {
    healPlayer("red", 15); // S to heal Red by 15
}

// Test Mana counter functionality with keyboard shortcuts
if(keyboard_check_pressed(ord("E"))) {
    useMana("violet", 5); // E to use 5 mana for Violet
}
if(keyboard_check_pressed(ord("D"))) {
    restoreMana("violet", 5); // D to restore 5 mana for Violet
}
if(keyboard_check_pressed(ord("R"))) {
    useMana("red", 8); // R to use 8 mana for Red
}
if(keyboard_check_pressed(ord("F"))) {
    restoreMana("red", 8); // F to restore 8 mana for Red
}

if(keyboard_check_pressed(vk_space)) {
    if(!battleBoxActive) {
        previousRoom = room;
        start_transition(RoomBattle);
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
            var boxX = round(spacing + (i * (boxWidth + spacing)));
            var startY = room_height + 50;
            var targetY = room_height - 58;
            
            var battleBox = {
                x: boxX,
                y: startY,
                startY: startY,
                targetY: targetY,
                textboxY: startY,
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
        
        // Lista ordenada: jogador primeiro, depois seguidores
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
        
        // Atribui personagens às caixas de batalha
        for (var i = 0; i < min(array_length(characterList), array_length(battleBoxes)); i++) {
            var character = characterList[i];
            with (character.inst) {
                jumpState = "waiting";
                jumpOriginalX = x;
                jumpOriginalY = y;
                jumpOriginalSprite = sprite_index;
                jumpStartX = x;
                jumpStartY = y;
                jumpTargetX = round(other.battleBoxes[i].x + 34);
                jumpTargetY = round(other.battleBoxes[i].targetY + 35);
                jumpProgress = 0;
                jumpDelay = i * 8;
                jumpDelayTimer = 0;
                jumpPrepTimer = 0;
                jumpPrepDuration = 30;
                jumpIsExiting = false;
                
                // Use fixed jump parameters to prevent jittering
                jumpDuration = 80;
                jumpMaxHeight = 100;
                
                battleBoxIndex = i;
                
            }
        }
    } else {
        movingUp = !movingUp;
        animationTimer = 0;
        
        // Start room transition immediately when exit animation begins
        if (!movingUp && previousRoom != -1) {
            start_transition(previousRoom);
            previousRoom = -1;
        }
        
        for(var i = 0; i < array_length(battleBoxes); i++) {
            var box = battleBoxes[i];
            box.velocity = 0;
            box.hasStarted = false;
            
            if(movingUp) {
                box.animationDelay = i * 8;
                box.targetY = room_height - 58;
                if (!variable_struct_exists(box, "textboxY")) {
                    box.textboxY = box.y;
                }
                topBarTargetY = 0;
                bottomBarTargetY = room_height + 48;
            } else {
                box.animationDelay = (array_length(battleBoxes) - 1 - i) * 8;
                box.targetY = room_height + 50;
                if (!variable_struct_exists(box, "textboxY")) {
                    box.textboxY = box.y;
                }
                topBarTargetY = -35;
                bottomBarTargetY = room_height + 96;
                box.hasBeenHit = false;
                box.impactOffset = 0;
                box.impactVelocity = 0;
                
            }
            
            battleBoxes[i] = box;
        }
    }
}

if(keyboard_check_pressed(vk_escape) && battleBoxActive) {
    battleBoxActive = false;
    battleBoxes = [];
    movingUp = true;
    
    // Force all characters to reset their states immediately
    if (instance_exists(objPlayer)) {
        with (objPlayer) {
            jumpState = "none";
            battleBoxIndex = -1;
            canMove = true;
        }
    }
    
    with (ObjFollower) {
        jumpState = "none";
        battleBoxIndex = -1;
        canMove = true;
    }
    
    if (previousRoom != -1) {
        start_transition(previousRoom);
        previousRoom = -1;
    }
}

if(battleBoxActive) {
    animationTimer++;
    
    // Update HP and Mana counters for all players
    var playerNames = ["violet", "red", "robot", "gang"];
    for (var p = 0; p < array_length(playerNames); p++) {
        updateHPCounter(playerNames[p]);
        updateManaCounter(playerNames[p]);
    }
    
    // Verifica aterrissagens e efeitos de impacto
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
            
            if (!movingUp && i < array_length(characterList)) {
                // Make the specific character jump when their box starts exiting
                var character = characterList[i];
                with (character.inst) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        jumpState = "jumping"; // Jump when this specific box starts exiting
                        jumpStartX = x;
                        jumpStartY = y;
                        jumpTargetX = jumpOriginalX;
                        jumpTargetY = jumpOriginalY;
                        jumpProgress = 0;
                        jumpIsExiting = true;
                        
                        // Use fixed jump parameters to prevent jittering
                        jumpDuration = 80;
                        jumpMaxHeight = 100;
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
            
            if (!variable_struct_exists(box, "textboxY")) {
                box.textboxY = box.y;
            }
            box.textboxY = lerp(box.textboxY, box.y, 0.25);
            
            // Check for character impacts and apply effects
            if (!box.hasBeenHit) {
                var foundLandedCharacter = false;
                
                // Check if any character has landed in this box
                if (instance_exists(objPlayer)) {
                    with (objPlayer) {
                        if (jumpState == "landed" && battleBoxIndex == i) {
                            foundLandedCharacter = true;
                            
                            // No character knockback to prevent jittering
                        }
                    }
                }
                
                with (ObjFollower) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        foundLandedCharacter = true;
                        
                        // No character knockback to prevent jittering
                    }
                }
                
                // Apply stronger box impact if any character landed (no screen shake)
                if (foundLandedCharacter) {
                    other.battleBoxes[i].impactOffset = 12;
                    other.battleBoxes[i].impactVelocity = 0;
                    other.battleBoxes[i].hasBeenHit = true;
                }
            }
            
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
    
    // Verifica saída do modo batalha
    if (!movingUp) {
        battleExitTimer++;
        
        var allBoxesGone = true;
        for (var i = 0; i < array_length(battleBoxes); i++) {
            if (battleBoxes[i].y < room_height + 100) {
                allBoxesGone = false;
                break;
            }
        }
        
        var allCharactersReturned = true;
        if (instance_exists(objPlayer)) {
            with (objPlayer) {
                if (battleBoxIndex != -1) {
                    allCharactersReturned = false;
                }
            }
        }
        
        with (ObjFollower) {
            if (battleBoxIndex != -1) {
                allCharactersReturned = false;
            }
        }
        
        // Exit battle if boxes are gone, characters returned, or timeout reached
        if (allBoxesGone || allCharactersReturned || battleExitTimer >= battleExitTimeout) {
            battleBoxActive = false;
            battleBoxes = [];
            movingUp = true;
            battleExitTimer = 0;
            
            // Force all characters to reset their states
            if (instance_exists(objPlayer)) {
                with (objPlayer) {
                    jumpState = "none";
                    battleBoxIndex = -1;
                    canMove = true;
                }
            }
            
            with (ObjFollower) {
                jumpState = "none";
                battleBoxIndex = -1;
                canMove = true;
            }
        }
    } else {
        battleExitTimer = 0;
    }
}

barAnimTimer++;

var topLerpAmount = topBarLerpSpeed + sin(barAnimTimer * 0.3) * 0.05;
var bottomLerpAmount = bottomBarLerpSpeed + cos(barAnimTimer * 0.25) * 0.03;

topLerpAmount = clamp(topLerpAmount, 0.15, 0.4);
bottomLerpAmount = clamp(bottomLerpAmount, 0.12, 0.35);

topBarY = lerp(topBarY, topBarTargetY, topLerpAmount);
bottomBarY = lerp(bottomBarY, bottomBarTargetY, bottomLerpAmount);

topBarScrollX += barScrollSpeed;
if(topBarScrollX >= 32) topBarScrollX -= 32;

bottomBarScrollX -= barScrollSpeed;
if(bottomBarScrollX <= -32) bottomBarScrollX += 32;

textureScrollX += textureScrollSpeedX;
textureScrollY -= textureScrollSpeedY;
if(textureScrollX >= 32) textureScrollX -= 32;
if(textureScrollY <= -32) textureScrollY += 32;