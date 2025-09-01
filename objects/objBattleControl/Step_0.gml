// Check for pending enemies to spawn after room transition
if (shouldSpawnEnemies && room == RoomBattle && is_array(pendingEnemyTypes) && array_length(pendingEnemyTypes) > 0) {
    // Clear existing enemies and spawn new ones for battle
    clearAllEnemies();
    spawnBattleEnemies(pendingEnemyTypes);
    
    // Clear the pending enemies so they don't spawn again
    shouldSpawnEnemies = false;
    pendingEnemyTypes = [];
}

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

// Test buttons for enemy spawning (additive)
if(keyboard_check_pressed(ord("G"))) {
    // Add 1 gnome (additive)
    var enemyTypes = ["gnome"];
    spawnBattleEnemies(enemyTypes);
}
if(keyboard_check_pressed(ord("H"))) {
    // Clear all enemies
    clearAllEnemies();
}

if(keyboard_check_pressed(vk_space)) {
    if(!battleBoxActive) {
        previousRoom = room;
        
        // Counter animations are now handled by the ObjEnemie that caught the player
        
        start_transition(RoomBattle);
        battleBoxActive = true;
        animationTimer = 0;
        movingUp = true;
        
        // Start button intro animation and reset battle GUI state
        for (var b = 0; b < array_length(carouselButtons); b++) {
            carouselButtons[b].introActive = true;
            carouselButtons[b].introTimer = 0;
            carouselButtons[b].currentOffsetY = -50;
            carouselButtons[b].outroActive = false;
        }
        
        // Reset battle GUI state
        battleGUIState = "buttons";
        showButtonGUI = true;
        allowButtonInput = true;
        enemySelectionArrowVisible = false;
        selectedEnemyIndex = 0;
        
        // Enemy spawning is now handled by the ObjEnemie that caught the player
        
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
            
            // Start button outro animation
            for (var b = 0; b < array_length(carouselButtons); b++) {
                carouselButtons[b].outroActive = true;
                carouselButtons[b].introActive = false;
            }
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
    
    // Start button outro animation
    for (var b = 0; b < array_length(carouselButtons); b++) {
        carouselButtons[b].outroActive = true;
        carouselButtons[b].introActive = false;
    }
    
    // Clear battle enemies when escaping
    clearAllEnemies();
    
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
            
            // Counter animations now start immediately when intro begins, not when boxes settle
            
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
            
            // Start button outro animation
            for (var b = 0; b < array_length(carouselButtons); b++) {
                carouselButtons[b].outroActive = true;
                carouselButtons[b].introActive = false;
            }
            
            // Clear battle enemies when exiting
            clearAllEnemies();
            
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

// Battle GUI Input System (only when battle is active)
if (battleBoxActive) {
    // Update animation state
    buttonsAnimating = areButtonsAnimating();
    
    // Handle fight option selection (Z key on first button - index 0)
    if (battleGUIState == "buttons" && allowButtonInput && showButtonGUI && !buttonsAnimating) {
        if (keyboard_check_pressed(ord("Z")) && round(carouselSelectedIndex) == 0 && 
            (current_time - lastModeSwitch) > modeSwitchDelay) {
            // Fight option selected - start button outro animation
            allowButtonInput = false;
            // Keep showButtonGUI = true so buttons stay visible during outro animation
            
            // Start button outro animation
            for (var b = 0; b < array_length(carouselButtons); b++) {
                carouselButtons[b].outroActive = true;
                carouselButtons[b].introActive = false;
            }
            
            lastModeSwitch = current_time;
        }
    }
    
    // Check if outro animation is complete to switch to enemy selection
    if (battleGUIState == "buttons" && !allowButtonInput && !buttonsAnimating) {
        battleGUIState = "enemy_selection";
        
        // Restore last selected enemy (or use first if invalid)
        var sortedEnemies = getEnemiesSortedByX();
        var enemyCount = array_length(sortedEnemies);
        
        if (enemyCount > 0) {
            // Use last selected enemy if valid, otherwise use first
            selectedEnemyIndex = (lastSelectedEnemyIndex < enemyCount) ? lastSelectedEnemyIndex : 0;
            
            var selectedEnemyData = sortedEnemies[selectedEnemyIndex];
            arrowTargetX = selectedEnemyData.x;
            arrowTargetY = selectedEnemyData.y - 30;
            
            // Start arrow intro animation (start above enemy position with low alpha)
            arrowCurrentX = selectedEnemyData.x;
            arrowCurrentY = selectedEnemyData.y - 60; // Start above enemy
            arrowCurrentAlpha = 0.25; // Start semi-transparent
            arrowTargetAlpha = 1; // Fade to full opacity
        }
        
        // Show arrow and hide buttons only after outro animation completes
        enemySelectionArrowVisible = true;
        showButtonGUI = false;
    }
    
    // Handle return to button selection (X key)
    if (battleGUIState == "enemy_selection" && !showButtonGUI) {
        if (keyboard_check_pressed(ord("X")) && (current_time - lastModeSwitch) > modeSwitchDelay) {
            // Return to button selection mode - start button intro animation
            battleGUIState = "buttons";
            enemySelectionArrowVisible = false;
            
            // Start button intro animation
            for (var b = 0; b < array_length(carouselButtons); b++) {
                carouselButtons[b].introActive = true;
                carouselButtons[b].introTimer = 0;
                carouselButtons[b].currentOffsetY = -50;
                carouselButtons[b].outroActive = false;
            }
            
            // Show buttons but don't allow input until animation completes
            showButtonGUI = true;
            allowButtonInput = false; // Will be enabled when animation completes
            lastModeSwitch = current_time;
        }
    }
    
    // Check if intro animation is complete to allow button input
    if (battleGUIState == "buttons" && !allowButtonInput && showButtonGUI && !buttonsAnimating) {
        allowButtonInput = true;
    }
}

// Carousel Button System Update (only when battle is active and in button mode)
if (battleBoxActive && battleGUIState == "buttons" && allowButtonInput) {
    // Handle input with improved hold-to-repeat functionality
    var leftPressed = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var rightPressed = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var upPressed = keyboard_check(vk_up) || keyboard_check(ord("W"));
    var downPressed = keyboard_check(vk_down) || keyboard_check(ord("S"));
    
    var anyInputPressed = leftPressed || rightPressed || upPressed || downPressed;
    var inputChanged = false;
    
    // Check for new input presses (allow continuous input for better responsiveness)
    if (true) {
        if (leftPressed && !carouselLeftPressed) {
            carouselTargetIndex = (carouselTargetIndex + 1) % 4; // Fixed: left goes clockwise
            carouselInputTimer = 0;
            inputChanged = true;
        }
        else if (rightPressed && !carouselRightPressed) {
            carouselTargetIndex = (carouselTargetIndex - 1 + 4) % 4; // Fixed: right goes counter-clockwise
            carouselInputTimer = 0;
            inputChanged = true;
        }
        else if (upPressed && !carouselUpPressed) {
            carouselTargetIndex = (carouselTargetIndex - 1 + 4) % 4;
            carouselInputTimer = 0;
            inputChanged = true;
        }
        else if (downPressed && !carouselDownPressed) {
            carouselTargetIndex = (carouselTargetIndex + 1) % 4;
            carouselInputTimer = 0;
            inputChanged = true;
        }
    }
    
    // Handle held input (repeat functionality) - continuous for better responsiveness
    if (anyInputPressed && !inputChanged) {
        carouselInputTimer++;
        
        if (carouselInputTimer > carouselInputDelay && 
           (carouselInputTimer - carouselInputDelay) % carouselInputRepeatRate == 0) {
            
            // Only one direction at a time to prevent conflicts
            if (leftPressed) {
                carouselTargetIndex = (carouselTargetIndex + 1) % 4; // Fixed: left goes clockwise
            }
            else if (rightPressed) {
                carouselTargetIndex = (carouselTargetIndex - 1 + 4) % 4; // Fixed: right goes counter-clockwise
            }
            else if (upPressed) {
                carouselTargetIndex = (carouselTargetIndex - 1 + 4) % 4;
            }
            else if (downPressed) {
                carouselTargetIndex = (carouselTargetIndex + 1) % 4;
            }
        }
    }
    
    // Reset input timer when no input is pressed
    if (!anyInputPressed) {
        carouselInputTimer = 0;
    }
    
    // Update previous input states
    carouselLeftPressed = leftPressed;
    carouselRightPressed = rightPressed;
    carouselUpPressed = upPressed;
    carouselDownPressed = downPressed;
    
    // Update selected index with smooth interpolation
    if (abs(carouselSelectedIndex - carouselTargetIndex) > 0.01) {
        var diff = carouselTargetIndex - carouselSelectedIndex;
        
        // Handle wrapping for shortest path
        if (diff > 2) diff -= 4;
        if (diff < -2) diff += 4;
        
        // Use lerp for smoother movement
        carouselSelectedIndex += diff * carouselRotationSpeed;
        
        // Snap to target when very close to prevent oscillation
        if (abs(diff) < 0.05) {
            carouselSelectedIndex = carouselTargetIndex;
        }
        
        // Keep selected index in valid range
        while (carouselSelectedIndex < 0) carouselSelectedIndex += 4;
        while (carouselSelectedIndex >= 4) carouselSelectedIndex -= 4;
    }
    
    // Update button positions based on selection
    var angleOffset = -carouselSelectedIndex * (2 * pi / 4) + (pi / 2); // Rotate to keep selected button at bottom
    
    for (var i = 0; i < array_length(carouselButtons); i++) {
        var button = carouselButtons[i];
        button.targetAngle = (i / 4) * 2 * pi + angleOffset;
        
        // Smooth angle interpolation with easing
        var angleDiff = button.targetAngle - button.currentAngle;
        
        // Handle angle wrapping for shortest path
        while (angleDiff > pi) angleDiff -= 2 * pi;
        while (angleDiff < -pi) angleDiff += 2 * pi;
        
        // Apply smooth easing animation
        button.currentAngle += angleDiff * carouselAnimationEase;
        
        // Calculate elliptical position
        button.x = carouselCenterX + cos(button.currentAngle) * carouselRadiusX;
        button.targetY = carouselCenterY + sin(button.currentAngle) * carouselRadiusY;
        
        // Handle intro animation
        if (button.introActive) {
            button.introTimer++;
            if (button.introTimer >= button.introDelay) {
                // Fast spring animation from above screen
                var yDiff = button.targetY - (button.targetY + button.currentOffsetY);
                button.currentOffsetY += yDiff * 0.4;
                
                // Stop intro when close enough
                if (abs(button.currentOffsetY) < 0.5) {
                    button.currentOffsetY = 0;
                    button.introActive = false;
                }
            }
        }
        
        // Handle outro animation
        if (button.outroActive) {
            // Fast spring animation to above screen
            var targetOffsetY = -60; // Target position above screen
            var yDiff = targetOffsetY - button.currentOffsetY;
            button.currentOffsetY += yDiff * 0.5;
        }
        
        // Apply Y offset to final position
        button.y = button.targetY + button.currentOffsetY;
        
        carouselButtons[i] = button;
    }
}

// Enemy Selection System Update (only when in enemy selection mode)
if (battleBoxActive && battleGUIState == "enemy_selection") {
    var sortedEnemies = getEnemiesSortedByX();
    var enemyCount = array_length(sortedEnemies);
    
    if (enemyCount > 0) {
        // Clamp selected enemy index to valid range (in case enemies were removed)
        selectedEnemyIndex = clamp(selectedEnemyIndex, 0, enemyCount - 1);
        
        // Handle input with hold-to-repeat functionality
        var leftPressed = keyboard_check(vk_left) || keyboard_check(ord("A"));
        var rightPressed = keyboard_check(vk_right) || keyboard_check(ord("D"));
        var upPressed = keyboard_check(vk_up) || keyboard_check(ord("W"));
        var downPressed = keyboard_check(vk_down) || keyboard_check(ord("S"));
        
        var anyInputPressed = leftPressed || rightPressed || upPressed || downPressed;
        var inputChanged = false;
        
        // Check for new input presses
        if (leftPressed && !enemyLeftPressed) {
            selectedEnemyIndex = (selectedEnemyIndex - 1 + enemyCount) % enemyCount;
            lastSelectedEnemyIndex = selectedEnemyIndex;
            enemyInputTimer = 0;
            inputChanged = true;
        }
        else if (rightPressed && !enemyRightPressed) {
            selectedEnemyIndex = (selectedEnemyIndex + 1) % enemyCount;
            lastSelectedEnemyIndex = selectedEnemyIndex;
            enemyInputTimer = 0;
            inputChanged = true;
        }
        else if (upPressed && !enemyUpPressed) {
            selectedEnemyIndex = (selectedEnemyIndex - 1 + enemyCount) % enemyCount;
            lastSelectedEnemyIndex = selectedEnemyIndex;
            enemyInputTimer = 0;
            inputChanged = true;
        }
        else if (downPressed && !enemyDownPressed) {
            selectedEnemyIndex = (selectedEnemyIndex + 1) % enemyCount;
            lastSelectedEnemyIndex = selectedEnemyIndex;
            enemyInputTimer = 0;
            inputChanged = true;
        }
        
        // Handle held input (repeat functionality)
        if (anyInputPressed && !inputChanged) {
            enemyInputTimer++;
            
            if (enemyInputTimer > enemyInputDelay && 
               (enemyInputTimer - enemyInputDelay) % enemyInputRepeatRate == 0) {
                
                // Only one direction at a time to prevent conflicts
                if (leftPressed) {
                    selectedEnemyIndex = (selectedEnemyIndex - 1 + enemyCount) % enemyCount;
                    lastSelectedEnemyIndex = selectedEnemyIndex;
                }
                else if (rightPressed) {
                    selectedEnemyIndex = (selectedEnemyIndex + 1) % enemyCount;
                    lastSelectedEnemyIndex = selectedEnemyIndex;
                }
                else if (upPressed) {
                    selectedEnemyIndex = (selectedEnemyIndex - 1 + enemyCount) % enemyCount;
                    lastSelectedEnemyIndex = selectedEnemyIndex;
                }
                else if (downPressed) {
                    selectedEnemyIndex = (selectedEnemyIndex + 1) % enemyCount;
                    lastSelectedEnemyIndex = selectedEnemyIndex;
                }
            }
        }
        
        // Reset input timer when no input is pressed
        if (!anyInputPressed) {
            enemyInputTimer = 0;
        }
        
        // Update previous input states
        enemyLeftPressed = leftPressed;
        enemyRightPressed = rightPressed;
        enemyUpPressed = upPressed;
        enemyDownPressed = downPressed;
        
        // Update arrow target position based on selected enemy
        if (selectedEnemyIndex < enemyCount) {
            var selectedEnemyData = sortedEnemies[selectedEnemyIndex];
            arrowTargetX = selectedEnemyData.x;
            arrowTargetY = selectedEnemyData.y - 30;
        }
        
        // Simple linear interpolation for arrow movement and alpha
        arrowCurrentX = lerp(arrowCurrentX, arrowTargetX, arrowLerpSpeed);
        arrowCurrentY = lerp(arrowCurrentY, arrowTargetY, arrowLerpSpeed);
        arrowCurrentAlpha = lerp(arrowCurrentAlpha, arrowTargetAlpha, arrowAlphaLerpSpeed);
    } else {
        // No enemies available, hide arrow
        enemySelectionArrowVisible = false;
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