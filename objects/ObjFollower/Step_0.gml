if (instance_exists(target)) {
    //Update queues with player's current state
    ds_list_insert(positionQueue, 0, [target.x, target.y]);
    ds_list_insert(actionQueue, 0, [target.spriteAction, target.spriteDir]);
    
    //Keep queues at max size
    if (ds_list_size(positionQueue) > maxQueueSize) {
        ds_list_delete(positionQueue, maxQueueSize);
        ds_list_delete(actionQueue, maxQueueSize);
    }
    
    //Get target position and action from queue (delayed following)
    var queueIndex = min(maxQueueSize - 1, ds_list_size(positionQueue) - 1);
    var targetPos = ds_list_find_value(positionQueue, queueIndex);
    var targetAction = ds_list_find_value(actionQueue, queueIndex);
    var targetX = targetPos[0];
    var targetY = targetPos[1];
    var pastSpriteAction = targetAction[0];
    var pastSpriteDir = targetAction[1];
    
    //Calculate distance to target position
    var distanceToTarget = point_distance(x, y, targetX, targetY);
    
    //Always move towards target position to maintain specific distance
    if (distanceToTarget > 2) {
        //Calculate direction to target
        dir = point_direction(x, y, targetX, targetY);
        
        //Use appropriate speed based on distance
        var currentSpeed = (distanceToTarget > followDistance) ? catchUpSpeed : moveSpeed;
        
        //Move towards target position
        hsp = lengthdir_x(currentSpeed, dir);
        vsp = lengthdir_y(currentSpeed, dir);
        
        //Apply movement
        x += hsp;
        y += vsp;
        
        //Use the player's past sprite direction
        spriteDir = pastSpriteDir;
        
        //Use the player's past action (Walk/Run)
        spriteAction = pastSpriteAction;
        
        //Set animation speed based on movement
        if (abs(hsp) > 0.1 or abs(vsp) > 0.1) {
            image_speed = abs(hsp) + abs(vsp);
            image_speed = clamp(image_speed, 0, currentSpeed);
        }
    } else {
        //When very close, still copy player's past action but don't move
        hsp = 0;
        vsp = 0;
        spriteDir = pastSpriteDir;
        spriteAction = pastSpriteAction;
        
        //If player was idle, do idle animation
        if (pastSpriteAction == "") {
            blinkTimer = approach(blinkTimer, 0, 1);
            if (blinkTimer == 0) {
                blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
            } else if (blinkTimer <= 8) {
                image_index = 1;
            } else {
                image_index = 0;
            }
        }
    }
    
    //Apply sprite based on direction (same system as player)
    var _sprite = $"spr{character+spriteAction}Down";
    switch(round(spriteDir/(360/8))) {
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
    
    //Update depth
    depth = -bbox_bottom;
}

//Update draw position smoothly
drawX += (x - drawX) * spriteCatchupFactor;
drawY += (y - drawY) * spriteCatchupFactor;