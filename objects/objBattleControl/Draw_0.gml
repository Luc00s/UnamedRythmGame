var screenWidth = 320;
var barHeight = 35;

for(var i = -1; i <= ceil(screenWidth / 32); i++) {
    draw_sprite(sprBattleBlackBar, 0, barScrollX + (i * 32), topBarY);
    draw_sprite_ext(sprBattleBlackBar, 0, barScrollX + (i * 32), bottomBarY - 47, 1, -(47/35), 0, c_white, 1);
}

if(battleBoxActive) {
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        draw_sprite(sprBattleBox, 0, box.x, box.y);
    }
}