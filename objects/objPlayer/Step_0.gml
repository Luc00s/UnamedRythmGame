var moveX = 0;
var moveY = 0;

if (canMove && jumpState == "none") {
    moveX = keyboard_check(vk_right)-keyboard_check(vk_left);
    moveY = keyboard_check(vk_down)-keyboard_check(vk_up);
}

// Lógica de salto para batalha
if (jumpState == "waiting") {
    jumpDelayTimer++;
    if (jumpDelayTimer >= jumpDelay) {
        if (jumpIsExiting || jumpPrepDuration == 0) {
            jumpState = "jumping";
            jumpProgress = 0;
        } else {
            jumpState = "preparing";
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
            sprite_index = sprPlayerJumpToFight;
            image_index = 0;
        }
    }
    return;
} else if (jumpState == "preparing") {
    jumpPrepTimer++;
    sprite_index = sprPlayerJumpToFight;
    image_index = 0;
    if (jumpPrepTimer >= jumpPrepDuration) {
        jumpState = "jumping";
        jumpProgress = 0;
    }
    return;
} else if (jumpState == "jumping") {
    jumpProgress += 1 / jumpDuration;
    
    if (jumpProgress >= 1) {
        jumpProgress = 1;
        
        if (point_distance(jumpTargetX, jumpTargetY, jumpOriginalX, jumpOriginalY) < 5) {
            jumpState = "none";
            x = jumpTargetX;
            drawX = jumpTargetX;
            drawY = jumpTargetY;
            sprite_index = jumpOriginalSprite;
            jumpIsExiting = false;
            battleBoxIndex = -1;
            canMove = true;
            spriteAction = "";
            image_speed = 0;
            image_index = 0;
            
            jumpProgress = 0;
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
        } else {
            jumpState = "landed";
            x = jumpTargetX;
            jumpCurrentX = jumpTargetX;
            jumpCurrentY = jumpTargetY;
            drawX = jumpTargetX;
            drawY = jumpTargetY;
        }
    } else {
        jumpCurrentX = lerp(jumpStartX, jumpTargetX, jumpProgress);
        
        var heightAtProgress = -4 * jumpMaxHeight * jumpProgress * (jumpProgress - 1);
        var enhancedHeight = heightAtProgress * (1 + sin(jumpProgress * pi) * 0.3);
        jumpCurrentY = lerp(jumpStartY, jumpTargetY, jumpProgress) - enhancedHeight;
        
        sprite_index = sprPlayerJumpToFight;
        if (jumpProgress < 0.5) {
            image_index = 1;
        } else {
            image_index = 1;
        }
        
        x = jumpCurrentX;
        y = jumpCurrentY;
        drawX = jumpCurrentX;
        drawY = jumpCurrentY;
        
        depth = -10000;
        return;
    }
    
} else if (jumpState == "landed") {
    if (instance_exists(objBattleControl) && battleBoxIndex >= 0) {
        with (objBattleControl) {
            if (other.battleBoxIndex < array_length(battleBoxes)) {
                var box = battleBoxes[other.battleBoxIndex];
                other.x = box.x + 34;
                other.drawX = box.x + 34;
                other.drawY = box.y + box.impactOffset + 24;
            }
        }
    }
    return;
    
} else {
    // Movimento normal
    if(moveX != 0 or moveY != 0) {
        dir = point_direction(0, 0, moveX, moveY);
        hsp = approach(hsp, lengthdir_x(spd, dir), .25);
        vsp = approach(vsp, lengthdir_y(spd, dir), .25);
    } else {
        hsp = approach(hsp, 0, .25);
        vsp = approach(vsp, 0, .25);
    }

    if(keyboard_check(ord("X"))) spd = approach(spd, runSpd, .1);
    else spd = approach(spd, normalSpd, .1);

    // Animação do sprite
    if((abs(hsp) > 0.1 or abs(vsp) > 0.1) && canMove) {
        image_speed = abs(hsp)+abs(vsp);
        image_speed = clamp(image_speed, 0, spd);
        
        spriteDir += angle_difference(dir, spriteDir)*.25;
        spriteDir = wrap(spriteDir, 0, 360);
        
        if(abs(hsp)+abs(vsp) >= runSpd) spriteAction = "Run";
        else spriteAction = "Walk";
        
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
    else {
        blinkTimer = approach(blinkTimer, 0, 1);
        if(blinkTimer = 0) blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
        else if(blinkTimer <= 8) image_index = 1;
        else image_index = 0;
        
        spriteAction = "";
        
        if (!canMove) {
            image_speed = 0;
            image_index = 0;
        }
    }

    // Definição de sprites direcionais
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

    xSpeedLeft += impactX;
    ySpeedLeft += impactY;
    
    collision();
    
    impactX *= impactDecay;
    impactY *= impactDecay;
    
    if (abs(impactX) < 0.1) impactX = 0;
    if (abs(impactY) < 0.1) impactY = 0;
    
    drawY = y;
}

// Sistema de gravação de movimento para seguidores
if (jumpState == "none") {
    movementDistance += point_distance(lastRecordedX, lastRecordedY, x, y);
    var timeSinceLastRecord = (historyIndex == 0) ? 999 : 1;
    var shouldRecord = (movementDistance >= minRecordDistance) || (timeSinceLastRecord >= 3);

    if (shouldRecord) {
        historyIndex = (historyIndex + 1) % historyBufferSize;
        
        positionX[historyIndex] = x;
        positionY[historyIndex] = y;
        recordSprite[historyIndex] = sprite_index;
        recordImageXScale[historyIndex] = image_xscale;
        recordSpeed[historyIndex] = point_distance(0, 0, hsp, vsp);
        recordDirection[historyIndex] = spriteDir;
        
        movementDistance = 0;
        lastRecordedX = x;
        lastRecordedY = y;
    }
}