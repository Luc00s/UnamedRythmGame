//Handle battle jump physics first (overrides normal following)
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
            image_index = 0; // Ground preparation sprite
        }
    }
    //Skip normal following during wait
} else if (jumpState == "preparing") {
    jumpPrepTimer++;
    sprite_index = sprPlayerJumpToFight;
    image_index = 0; // Stay in ground preparation sprite
    if (jumpPrepTimer >= jumpPrepDuration) {
        jumpState = "jumping";
        jumpProgress = 0;
    }
    //Skip normal following during preparation
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
            y = jumpTargetY;
            jumpIsExiting = false; // Reset exit flag
            battleBoxIndex = -1;
            
            // Reset all jump variables for clean re-entry
            jumpProgress = 0;
            jumpDelayTimer = 0;
            jumpPrepTimer = 0;
            // Don't set sprite here - let normal follower logic handle it
        } else {
            // Landing on battle box
            jumpState = "landed";
            x = jumpTargetX;
            y = jumpTargetY;
            jumpCurrentX = jumpTargetX;
            jumpCurrentY = jumpTargetY;
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
        y = jumpCurrentY;
        
        //Render in front of black bars during jump
        depth = -10000;
    }
    
    //Skip normal following during jump
} else if (jumpState == "landed") {
    //Follow the battle box position including impact offset
    if (instance_exists(objBattleControl) && battleBoxIndex >= 0) {
        with (objBattleControl) {
            if (other.battleBoxIndex < array_length(battleBoxes)) {
                var box = battleBoxes[other.battleBoxIndex];
                other.x = box.x + 34; // Center of battle box
                other.y = box.y + box.impactOffset + 24; // Follow box movement + impact
            }
        }
    }
    
    //Skip normal following when landed
} else {
    //Normal follower logic
    if (instance_exists(objPlayer)) {
        //Get target position from circular buffer
        var bufferIndex = (objPlayer.historyIndex - record + objPlayer.historyBufferSize) % objPlayer.historyBufferSize;
        bufferIndex = max(0, min(bufferIndex, objPlayer.historyBufferSize - 1));
        
        //Get recorded data from player history
        var targetX = objPlayer.positionX[bufferIndex];
        var targetY = objPlayer.positionY[bufferIndex];
        var recordedSprite = objPlayer.recordSprite[bufferIndex];
        var recordedXScale = objPlayer.recordImageXScale[bufferIndex];
        
        //Smooth movement instead of direct teleportation
        var distanceToTarget = point_distance(x, y, targetX, targetY);
        
        if (distanceToTarget > 1) {
            //Move smoothly toward target
            var moveSpeed = min(distanceToTarget * 0.3, 3);
            var moveDir = point_direction(x, y, targetX, targetY);
            x += lengthdir_x(moveSpeed, moveDir);
            y += lengthdir_y(moveSpeed, moveDir);
        } else {
            //Close enough to target
            x = targetX;
            y = targetY;
        }
        
        //Check if follower is actually moving
        var movementDistance = point_distance(lastX, lastY, x, y);
        var isMoving = movementDistance > 0.1;
        
        if (isMoving) {
            //Always use the recorded sprite when moving (Walk/Run)
            sprite_index = recordedSprite;
            
            //Set proper animation speed based on movement
            image_speed = clamp(movementDistance, 0.8, 2.5);
        } else {
            //Convert to idle sprite when not moving
            var spriteName = sprite_get_name(recordedSprite);
            var idleSprite = string_replace(spriteName, "Walk", "");
            idleSprite = string_replace(idleSprite, "Run", "");
            sprite_index = asset_get_index(idleSprite);
            
            //Stop animation and handle blinking
            image_speed = 0;
            
            //Blinking animation for idle state
            blinkTimer = approach(blinkTimer, 0, 1);
            if (blinkTimer == 0) {
                blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
            } else if (blinkTimer <= 8) {
                image_index = 1;
            } else {
                image_index = 0;
            }
        }
        
        //Match player's facing direction
        image_xscale = recordedXScale;
        
        //Update last position for next frame comparison
        lastX = x;
        lastY = y;
        
        //Depth sorting based on chain position
        depth = -bbox_bottom - followerChainPosition;
    }
}