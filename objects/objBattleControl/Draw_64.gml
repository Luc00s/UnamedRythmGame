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
        
        var playerNames = ["violet", "red", "robot", "gang"];
        if (i < array_length(playerNames)) {
            var playerName = playerNames[i];
            if (variable_struct_exists(playerStats, playerName)) {
                var player = playerStats[$ playerName];
                var characterName = player.name;
                
                draw_set_font(fn1);
                var textWidth = string_width(characterName);
                var textHeight = string_height(characterName);

                var nameBoxWidth = textWidth + 8;
                var nameBoxHeight = textHeight;
                var nameBoxCenterX = box.x + 34;
                var nameBoxCenterY = boxDrawY;
                var nameBoxX = nameBoxCenterX - (nameBoxWidth / 2);
                var nameBoxY = nameBoxCenterY - (nameBoxHeight / 2);
                
                var scaleX = nameBoxWidth / sprite_get_width(sprBattleNameBox);
                var scaleY = nameBoxHeight / sprite_get_height(sprBattleNameBox);
                draw_sprite_ext(sprBattleNameBox, 0, nameBoxX, nameBoxY, scaleX, scaleY, 0, c_white, 1);
                
                // Draw character name
                draw_set_color(c_white);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(nameBoxCenterX, nameBoxCenterY - 1, characterName);
                
                if (array_length(player.status) > 0) {
                    var statusText = "";
                    for (var s = 0; s < array_length(player.status); s++) {
                        statusText += player.status[s];
                        if (s < array_length(player.status) - 1) statusText += ",";
                    }
                    draw_set_color(c_yellow);
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                    draw_text(box.x + 5, boxDrawY + 30, statusText);
                }
                
                // Reset text properties
                draw_set_color(c_white);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
        
        var leftScoreX = box.x + 7;
        var rightScoreX = box.x + 36;
        var scoreY = boxDrawY + 10;
        var leftElementX = box.x - 3;
        var rightElementX = box.x + 61;
        
        draw_sprite(sprBattleScore, 0, leftScoreX, scoreY);
        draw_sprite(sprBattleScore, 1, rightScoreX, scoreY);
        draw_sprite(sprBattleElement, 0, leftElementX, scoreY - 1);
        draw_sprite(sprBattleElement, 1, rightElementX, scoreY - 1);
    }
}
