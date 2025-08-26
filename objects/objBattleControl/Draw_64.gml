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
        
        // Draw HP and Mana for each player
        var playerNames = ["violet", "red", "robot", "gang"];
        if (i < array_length(playerNames)) {
            var playerName = playerNames[i];
            if (variable_struct_exists(playerStats, playerName)) {
                var player = playerStats[$ playerName];
                
                // Set text properties
                draw_set_font(fn1);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                
                // HP text (left side) - format as 3 digits with small spacing
                draw_set_color(c_black);
                var healthStr = string_format(player.health, 3, 0);
                var healthFormatted = string_char_at(healthStr, 1) + string_char_at(healthStr, 2) + string_char_at(healthStr, 3);
                draw_text(leftScoreX + 1, scoreY, healthFormatted);
                
                // Mana text (right side) - format as 3 digits with small spacing
                draw_set_color(c_black);
                var manaStr = string_format(player.mana, 3, 0);
                var manaFormatted = string_char_at(manaStr, 1) + string_char_at(manaStr, 2) + string_char_at(manaStr, 3);
                draw_text(rightScoreX - 1, scoreY, manaFormatted);
                
                // Status effects (if any)
                if (array_length(player.status) > 0) {
                    var statusText = "";
                    for (var s = 0; s < array_length(player.status); s++) {
                        statusText += player.status[s];
                        if (s < array_length(player.status) - 1) statusText += ",";
                    }
                    draw_set_color(c_yellow);
                    draw_text(box.x + 5, boxDrawY + 30, statusText);
                }
                
                // Reset text properties
                draw_set_color(c_white);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
    }
}

draw_text(32,32,string(mouse_x) + " " + string(mouse_y))