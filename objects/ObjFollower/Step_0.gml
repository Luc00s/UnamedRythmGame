//Check if the player object exists to avoid errors
if (instance_exists(objPlayer)) {
    //Set the follower's position to the player's recorded position
    //at the index specified by its 'record' variable
    x = objPlayer.positionX[record];
    y = objPlayer.positionY[record];
    
    //Update the follower's sprite to match the player's sprite at that point in time
    sprite_index = objPlayer.recordSprite[record];
    
    //Update the follower's horizontal direction (facing left or right)
    image_xscale = objPlayer.recordImageXScale[record];
    
    //Sync the animation speed with the player's speed
    //This makes the follower stop animating when the player stops
    image_speed = objPlayer.image_speed;
    
    //Update depth
    depth = -bbox_bottom;
}