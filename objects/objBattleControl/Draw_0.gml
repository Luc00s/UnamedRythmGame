var screenWidth = 320;
var barHeight = 35;

for(var i = -1; i <= ceil(screenWidth / 32); i++) {
    draw_sprite(sprBattleBlackBar, 0, barScrollX + (i * 32), topBarY);
    draw_sprite_ext(sprBattleBlackBar, 0, barScrollX + (i * 32), bottomBarY - 47, 1, -(47/35), 0, c_white, 1);
}

if(battleBoxActive) {
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        
        for(var tileX = -1; tileX < 5; tileX++) {
            for(var tileY = -1; tileY < 3; tileY++) {
                var drawX = box.x + 4 + (tileX * 16) + textureScrollX;
                var drawY = box.y + 4 + (tileY * 16) + textureScrollY;
                
                if(drawX + 16 > box.x + 4 && drawY + 16 > box.y + 4 && 
                   drawX < box.x + 64 && drawY < box.y + 28) {
                    
                    var clipLeft = max(0, (box.x + 4) - drawX);
                    var clipTop = max(0, (box.y + 4) - drawY);
                    var clipRight = max(0, (drawX + 16) - (box.x + 64));
                    var clipBottom = max(0, (drawY + 16) - (box.y + 28));
                    
                    var clipWidth = 16 - clipLeft - clipRight;
                    var clipHeight = 16 - clipTop - clipBottom;
                    
                    if(clipWidth > 0 && clipHeight > 0) {
                        draw_sprite_part(sprBattleBoxBack, i % 3, clipLeft, clipTop, clipWidth, clipHeight, 
                                       drawX + clipLeft, drawY + clipTop);
                    }
                }
            }
        }
        
        draw_sprite(sprBattleBox, 0, box.x, box.y);
    }
}