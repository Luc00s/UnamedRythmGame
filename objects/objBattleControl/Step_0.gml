if(keyboard_check_pressed(ord("1"))) {
    battleBoxCount = 1;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("2"))) {
    battleBoxCount = 2;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("3"))) {
    battleBoxCount = 3;
    battleBoxes = [];
    battleBoxActive = false;
}
if(keyboard_check_pressed(ord("4"))) {
    battleBoxCount = 4;
    battleBoxes = [];
    battleBoxActive = false;
}

if(keyboard_check_pressed(vk_space)) {
    if(!battleBoxActive) {
        battleBoxActive = true;
        animationTimer = 0;
        movingUp = true;
        
        topBarTargetY = 0;
        bottomBarTargetY = room_height + 48;
        barAnimTimer = 0;
        
        var screenWidth = 320;
        var boxWidth = 68;
        var totalBoxWidth = boxWidth * battleBoxCount;
        var remainingSpace = screenWidth - totalBoxWidth;
        var spacing = remainingSpace / (battleBoxCount + 1);
        
        for(var i = 0; i < battleBoxCount; i++) {
            var boxX = spacing + (i * (boxWidth + spacing));
            var startY = room_height + 50;
            var targetY = room_height - 58;
            
            var battleBox = {
                x: boxX,
                y: startY,
                startY: startY,
                targetY: targetY,
                velocity: 0,
                animationDelay: i * 5,
                hasStarted: false,
                springStrength: 0.3,
                damping: 0.7
            };
            
            array_push(battleBoxes, battleBox);
        }
    } else {
        movingUp = !movingUp;
        animationTimer = 0;
        
        for(var i = 0; i < array_length(battleBoxes); i++) {
            var box = battleBoxes[i];
            box.velocity = 0;
            box.hasStarted = false;
            box.animationDelay = i * 5;
            
            if(movingUp) {
                box.targetY = room_height - 58;
                topBarTargetY = 0;
                bottomBarTargetY = room_height + 48;
            } else {
                box.targetY = room_height + 50;
                topBarTargetY = -35;
                bottomBarTargetY = room_height + 96;
            }
            
            battleBoxes[i] = box;
        }
    }
}

if(battleBoxActive) {
    animationTimer++;
    
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        
        if(animationTimer >= box.animationDelay) {
            box.hasStarted = true;
        }
        
        if(box.hasStarted) {
            var distance = box.targetY - box.y;
            var force = distance * box.springStrength;
            box.velocity += force;
            box.velocity *= box.damping;
            box.y += box.velocity;
        }
        
        battleBoxes[i] = box;
    }
    
}

barAnimTimer++;

var topLerpAmount = topBarLerpSpeed + sin(barAnimTimer * 0.3) * 0.05;
var bottomLerpAmount = bottomBarLerpSpeed + cos(barAnimTimer * 0.25) * 0.03;

topLerpAmount = clamp(topLerpAmount, 0.15, 0.4);
bottomLerpAmount = clamp(bottomLerpAmount, 0.12, 0.35);

topBarY = lerp(topBarY, topBarTargetY, topLerpAmount);
bottomBarY = lerp(bottomBarY, bottomBarTargetY, bottomLerpAmount);

barScrollX -= barScrollSpeed;
if(barScrollX <= -32) barScrollX += 32;