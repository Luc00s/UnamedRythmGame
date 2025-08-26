var screenWidth = 320;
var barHeight = 35;

for(var i = -1; i <= ceil(screenWidth / 32); i++) {
    draw_sprite(sprBattleBlackBar, 0, topBarScrollX + (i * 32), topBarY);
    draw_sprite_ext(sprBattleBlackBar, 0, bottomBarScrollX + (i * 32), bottomBarY - 47, 1, -(47/35), 0, c_white, 1);
}

if(battleBoxActive) {
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        var boxDrawY = box.y + box.impactOffset;
        
        for(var tileX = -1; tileX < 3; tileX++) {
            for(var tileY = -1; tileY < 2; tileY++) {
                var drawX = box.x + 4 + (tileX * 32) + textureScrollX;
                var drawY = boxDrawY + 4 + (tileY * 32) + textureScrollY;
                
                if(drawX + 32 > box.x + 4 && drawY + 32 > boxDrawY + 4 && 
                   drawX < box.x + 64 && drawY < boxDrawY + 28) {
                    
                    var clipLeft = max(0, (box.x + 4) - drawX);
                    var clipTop = max(0, (boxDrawY + 4) - drawY);
                    var clipRight = max(0, (drawX + 32) - (box.x + 64));
                    var clipBottom = max(0, (drawY + 32) - (boxDrawY + 28));
                    
                    var clipWidth = 32 - clipLeft - clipRight;
                    var clipHeight = 32 - clipTop - clipBottom;
                    
                    if(clipWidth > 0 && clipHeight > 0) {
                        draw_sprite_part(sprBattleBoxBack, i % 3, clipLeft, clipTop, clipWidth, clipHeight, 
                                       drawX + clipLeft, drawY + clipTop);
                    }
                }
            }
        }
        
        draw_sprite(sprBattleBox, 0, box.x, boxDrawY);
        
        var leftScoreX = box.x + 7; // Position sprite so its right edge is 4 pixels from box left
        var rightScoreX = box.x + 36; // Position sprite so its left edge is 4 pixels from box right (68 is box width)
        var scoreY = boxDrawY + 10;
        
        // Left score sprite (index 0)
        draw_sprite(sprBattleScore, 0, leftScoreX, scoreY);
        
        // Right score sprite (index 1) 
        draw_sprite(sprBattleScore, 1, rightScoreX, scoreY);
		
        var leftScoreSprite = box.x-3; // Position sprite so its right edge is 4 pixels from box left
        var rightScoreSprite = box.x + 61; // Position sprite so its left edge is 4 pixels from box right (68 is box width)
        
        // Left score sprite (index 0)
        draw_sprite(sprBattleElement, 0, leftScoreSprite, scoreY-1);
        
        // Right score sprite (index 1) 
        draw_sprite(sprBattleElement, 1, rightScoreSprite, scoreY-1);
    }
}