//Controles
var moveX = keyboard_check(vk_right)-keyboard_check(vk_left);
var moveY = keyboard_check(vk_down)-keyboard_check(vk_up);

//Handle battle jump physics first (overrides normal movement)
if (jumpState == "waiting") {
    jumpDelayTimer++;
    if (jumpDelayTimer >= jumpDelay) {
        if (jumpIsExiting || jumpPrepDuration == 0) {
            // Skip preparation for exit jumps
            jumpState = "jumping";
            jumpProgress = 0;
        } else {
            jumpState = "preparing";
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
            sprite_index = sprPlayerJumpToFight;
            image_index = 0; // Ground preparation sprite;
        }
    }
    //Skip normal movement during wait
} else if (jumpState == "preparing") {
    jumpPrepTimer++;
    sprite_index = sprPlayerJumpToFight;
    image_index = 0; // Stay in ground preparation sprite
    if (jumpPrepTimer >= jumpPrepDuration) {
        jumpState = "jumping";
        jumpProgress = 0;
    }
    //Skip normal movement during preparation
} else if (jumpState == "jumping") {
    jumpProgress += 1 / jumpDuration;
    
    if (jumpProgress >= 1) {
        //Jump complete - land exactly on target
        jumpProgress = 1;
        
        // Check if this is a return jump to original position
        if (point_distance(jumpTargetX, jumpTargetY, jumpOriginalX, jumpOriginalY) < 5) {
            // Returning to original position - free for normal movement
            jumpState = "none";
            x = jumpTargetX;
            drawX = jumpTargetX;
            drawY = jumpTargetY;
            sprite_index = jumpOriginalSprite; // Restore original sprite
            jumpIsExiting = false; // Reset exit flag
            battleBoxIndex = -1;
            
            // Reset all jump variables for clean re-entry
            jumpProgress = 0;
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
        } else {
            // Landing on battle box
            jumpState = "landed";
            x = jumpTargetX;
            jumpCurrentX = jumpTargetX;
            jumpCurrentY = jumpTargetY;
            drawX = jumpTargetX;
            drawY = jumpTargetY;
        }
    } else {
        //Calculate smooth arc trajectory
        jumpCurrentX = lerp(jumpStartX, jumpTargetX, jumpProgress);
        
        //Enhanced parabolic arc with more dramatic peak
        var heightAtProgress = -4 * jumpMaxHeight * jumpProgress * (jumpProgress - 1);
        var enhancedHeight = heightAtProgress * (1 + sin(jumpProgress * pi) * 0.3); // Extra height boost at peak
        jumpCurrentY = lerp(jumpStartY, jumpTargetY, jumpProgress) - enhancedHeight;
        
        //Set jump sprite based on trajectory
        sprite_index = sprPlayerJumpToFight;
        if (jumpProgress < 0.5) {
            //Going up
            image_index = 1;
        } else {
            //Coming down
            image_index = 1;
        }
        
        //Update position
        x = jumpCurrentX;
        drawX = jumpCurrentX;
        drawY = jumpCurrentY;
        
        //Render in front of black bars during jump
        depth = -10000;
    }
    
    //Skip normal movement during jump
} else if (jumpState == "landed") {
    //Follow the battle box position including impact offset
    if (instance_exists(objBattleControl) && battleBoxIndex >= 0) {
        with (objBattleControl) {
            if (other.battleBoxIndex < array_length(battleBoxes)) {
                var box = battleBoxes[other.battleBoxIndex];
                other.x = box.x + 34; // Center of battle box
                other.drawX = box.x + 34;
                other.drawY = box.y + box.impactOffset + 24; // Follow box movement + impact
            }
        }
    }
    
    //Skip normal movement when landed
} else {
    //Normal movement logic
    //Velocidade
    if(moveX != 0 or moveY != 0) {
        dir = point_direction(0, 0, moveX, moveY);
        hsp = approach(hsp, lengthdir_x(spd, dir), .25);
        vsp = approach(vsp, lengthdir_y(spd, dir), .25);
    } else {
        hsp = approach(hsp, 0, .25);
        vsp = approach(vsp, 0, .25);
    }

    //Correndo
    if(keyboard_check(ord("X"))) spd = approach(spd, runSpd, .1);
    else spd = approach(spd, normalSpd, .1);

    //Meus sprites
    if(abs(hsp) > 0.1 or abs(vsp) > 0.1) { //Andando
        //Dando a velocidade a animação dependendo da velocidade de movimento
        image_speed = abs(hsp)+abs(vsp);
        image_speed = clamp(image_speed, 0, spd);
        
        //Virando suavemente para a direção correta
        spriteDir += angle_difference(dir, spriteDir)*.25;
        spriteDir = wrap(spriteDir, 0, 360);
        
        //Animação do personagem correndo
        if(abs(hsp)+abs(vsp) >= runSpd) spriteAction = "Run";
        //Animação do personagem andando
        else spriteAction = "Walk";
        
        //Som de passos
        if(image_index > 1 and image_index <= 2) {
            if(footstepSound = false) audio_play_sound(sndFootstep0, 0, false);
            footstepSound = true;
        }
        else if(image_index > 3 and image_index < 4) {
            if(footstepSound = false) audio_play_sound(sndFootstep1, 0, false);
            footstepSound = true;
        }
        else footstepSound = false;
    }
    else { //Parado
        blinkTimer = approach(blinkTimer, 0, 1);
        if(blinkTimer = 0) blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
        else if(blinkTimer <= 8) image_index = 1;
        else image_index = 0;
        
        spriteAction = "";
    }

    //Aplicando os sprites para todas as direções
    var _sprite = $"spr{character+spriteAction}Down";
    var _tired = "";
    if(tired = true) _tired = "Tired";
    switch(round(spriteDir/(360/8))) {
        case 0: case 8: _sprite = $"spr{character+spriteAction+_tired}Right"; break;
        case 1: _sprite = $"sprPlayer{spriteAction+_tired}UpRight"; break;
        case 2: _sprite = $"spr{character+spriteAction+_tired}Up"; break;
        case 3: _sprite = $"sprPlayer{spriteAction+_tired}UpLeft"; break;
        case 4: _sprite = $"spr{character+spriteAction+_tired}Left"; break;
        case 5: _sprite = $"sprPlayer{spriteAction+_tired}DownLeft"; break;
        case 6: _sprite = $"spr{character+spriteAction+_tired}Down"; break;
        case 7: _sprite = $"sprPlayer{spriteAction+_tired}DownRight"; break;
    }
    sprite_index = asset_get_index(_sprite);

    //Colisão
    collision();
    
    //Normal drawY follows y when not jumping
    drawY = y;
}

//Enhanced movement recording with distance-based and time-based triggers
//Don't record movement during battle jumps
if (jumpState == "none") {
    movementDistance += point_distance(lastRecordedX, lastRecordedY, x, y);
    var timeSinceLastRecord = (historyIndex == 0) ? 999 : 1;
    var shouldRecord = (movementDistance >= minRecordDistance) || (timeSinceLastRecord >= 3);

    if (shouldRecord) {
        //Circular buffer - more efficient than array shifting
        historyIndex = (historyIndex + 1) % historyBufferSize;
        
        //Record current state
        positionX[historyIndex] = x;
        positionY[historyIndex] = y;
        recordSprite[historyIndex] = sprite_index;
        recordImageXScale[historyIndex] = image_xscale;
        recordSpeed[historyIndex] = point_distance(0, 0, hsp, vsp);
        recordDirection[historyIndex] = spriteDir;
        
        //Reset tracking
        movementDistance = 0;
        lastRecordedX = x;
        lastRecordedY = y;
    }
}