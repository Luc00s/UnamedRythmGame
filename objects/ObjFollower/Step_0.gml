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
} else if (jumpState == "preparing") {
    jumpPrepTimer++;
    sprite_index = sprPlayerJumpToFight;
    image_index = 0;
    if (jumpPrepTimer >= jumpPrepDuration) {
        jumpState = "jumping";
        jumpProgress = 0;
    }
} else if (jumpState == "jumping") {
    jumpProgress += 1 / jumpDuration;
    
    if (jumpProgress >= 1) {
        jumpProgress = 1;
        
        if (point_distance(jumpTargetX, jumpTargetY, jumpOriginalX, jumpOriginalY) < 5) {
            jumpState = "none";
            x = jumpTargetX;
            y = jumpTargetY;
            jumpIsExiting = false;
            battleBoxIndex = -1;
            
            jumpProgress = 0;
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
        } else {
            jumpState = "landed";
            x = jumpTargetX;
            y = jumpTargetY;
            jumpCurrentX = jumpTargetX;
            jumpCurrentY = jumpTargetY;
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
        
        depth = -10000;
    }
    
} else if (jumpState == "landed") {
    if (instance_exists(objBattleControl) && battleBoxIndex >= 0) {
        with (objBattleControl) {
            if (other.battleBoxIndex < array_length(battleBoxes)) {
                var box = battleBoxes[other.battleBoxIndex];
                other.x = box.x + 34;
                other.y = box.y + box.impactOffset + 24;
            }
        }
    }
    
} else {
    if (instance_exists(objPlayer)) {
        var bufferIndex = (objPlayer.historyIndex - record + objPlayer.historyBufferSize) % objPlayer.historyBufferSize;
        bufferIndex = max(0, min(bufferIndex, objPlayer.historyBufferSize - 1));
        
        var targetX = objPlayer.positionX[bufferIndex];
        var targetY = objPlayer.positionY[bufferIndex];
        var recordedSprite = objPlayer.recordSprite[bufferIndex];
        var recordedXScale = objPlayer.recordImageXScale[bufferIndex];
        
        var distanceToTarget = point_distance(x, y, targetX, targetY);
        
        if (distanceToTarget > 1) {
            var moveSpeed = min(distanceToTarget * 0.3, 3);
            var moveDir = point_direction(x, y, targetX, targetY);
            x += lengthdir_x(moveSpeed, moveDir);
            y += lengthdir_y(moveSpeed, moveDir);
        } else {
            x = targetX;
            y = targetY;
        }
        
        var movementDistance = point_distance(lastX, lastY, x, y);
        var isMoving = movementDistance > 0.1;
        
        if (isMoving) {
            sprite_index = recordedSprite;
            
            image_speed = clamp(movementDistance, 0.8, 2.5);
        } else {
            var spriteName = sprite_get_name(recordedSprite);
            var idleSprite = string_replace(spriteName, "Walk", "");
            idleSprite = string_replace(idleSprite, "Run", "");
            sprite_index = asset_get_index(idleSprite);
            
            image_speed = 0;
            
            blinkTimer = approach(blinkTimer, 0, 1);
            if (blinkTimer == 0) {
                blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
            } else if (blinkTimer <= 8) {
                image_index = 1;
            } else {
                image_index = 0;
            }
        }
        
        image_xscale = recordedXScale;
        
        lastX = x;
        lastY = y;
        
        depth = -bbox_bottom - followerChainPosition;
    }
}