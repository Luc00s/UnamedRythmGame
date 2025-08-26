// Atualização automática das caixas de batalha
battleBoxCount = getPartyMemberCount();

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
                animationDelay: i * 8,
                hasStarted: false,
                springStrength: 0.1,
                damping: 0.7,
                impactOffset: 0,
                impactVelocity: 0,
                hasBeenHit: false
            };
            
            array_push(battleBoxes, battleBox);
        }
        
        // Lista ordenada: jogador primeiro, depois seguidores
        var characterList = [];
        var boxIndex = 0;
        
        if (instance_exists(objPlayer)) {
            array_push(characterList, {inst: instance_find(objPlayer, 0), type: "player"});
        }
        
        var followerCount = instance_number(ObjFollower);
        for (var i = 0; i < followerCount; i++) {
            var followerInst = instance_find(ObjFollower, i);
            array_push(characterList, {inst: followerInst, type: "follower"});
        }
        
        // Atribui personagens às caixas de batalha
        for (var i = 0; i < min(array_length(characterList), array_length(battleBoxes)); i++) {
            var character = characterList[i];
            with (character.inst) {
                jumpState = "waiting";
                jumpOriginalX = x;
                jumpOriginalY = y;
                jumpOriginalSprite = sprite_index;
                jumpStartX = x;
                jumpStartY = y;
                jumpTargetX = other.battleBoxes[i].x + 34;
                jumpTargetY = other.battleBoxes[i].targetY + 24;
                jumpProgress = 0;
                jumpDelay = i * 8;
                jumpDelayTimer = 0;
                jumpPrepTimer = 0;
                jumpPrepDuration = 30;
                jumpIsExiting = false;
                
                var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                jumpDuration = max(60, min(100, jumpDistance * 0.35));
                jumpMaxHeight = max(80, jumpDistance * 0.5);
                
                battleBoxIndex = i;
                
            }
        }
    } else {
        movingUp = !movingUp;
        animationTimer = 0;
        
        
        for(var i = 0; i < array_length(battleBoxes); i++) {
            var box = battleBoxes[i];
            box.velocity = 0;
            box.hasStarted = false;
            
            if(movingUp) {
                box.animationDelay = i * 8;
                box.targetY = room_height - 58;
                topBarTargetY = 0;
                bottomBarTargetY = room_height + 48;
            } else {
                box.animationDelay = (array_length(battleBoxes) - 1 - i) * 8;
                box.targetY = room_height + 50;
                topBarTargetY = -35;
                bottomBarTargetY = room_height + 96;
                box.hasBeenHit = false;
                box.impactOffset = 0;
                box.impactVelocity = 0;
                
            }
            
            battleBoxes[i] = box;
        }
    }
}

if(battleBoxActive) {
    animationTimer++;
    
    // Verifica aterrissagens e efeitos de impacto
    var characterList = [];
    if (instance_exists(objPlayer)) {
        array_push(characterList, {inst: instance_find(objPlayer, 0), type: "player"});
    }
    var followerCount = instance_number(ObjFollower);
    for (var i = 0; i < followerCount; i++) {
        var followerInst = instance_find(ObjFollower, i);
        array_push(characterList, {inst: followerInst, type: "follower"});
    }
    
    for(var i = 0; i < array_length(battleBoxes); i++) {
        var box = battleBoxes[i];
        
        if(animationTimer >= box.animationDelay) {
            box.hasStarted = true;
            
            if (!movingUp && i < array_length(characterList)) {
                var character = characterList[i];
                with (character.inst) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        jumpState = "jumping"; // Jump instantly when box starts exiting
                        jumpStartX = x;
                        jumpStartY = y;
                        jumpTargetX = jumpOriginalX;
                        jumpTargetY = jumpOriginalY;
                        jumpProgress = 0;
                        jumpIsExiting = true;
                        
                        var jumpDistance = point_distance(jumpStartX, jumpStartY, jumpTargetX, jumpTargetY);
                        jumpDuration = max(60, min(100, jumpDistance * 0.35));
                        jumpMaxHeight = max(80, jumpDistance * 0.5);
                    }
                }
            }
        }
        
        if(box.hasStarted) {
            var distance = box.targetY - box.y;
            var force = distance * box.springStrength;
            box.velocity += force;
            box.velocity *= box.damping;
            box.y += box.velocity;
            
            if(i < array_length(characterList) && !box.hasBeenHit) {
                var character = characterList[i];
                with (character.inst) {
                    if (jumpState == "landed" && battleBoxIndex == i) {
                        other.battleBoxes[i].impactOffset = 15;
                        other.battleBoxes[i].impactVelocity = 0;
                        other.battleBoxes[i].hasBeenHit = true;
                    }
                }
            }
            
            if(abs(box.impactOffset) > 0.1 || abs(box.impactVelocity) > 0.1) {
                box.impactVelocity += -box.impactOffset * 0.08;
                box.impactVelocity *= 0.8;
                box.impactOffset += box.impactVelocity;
                
                if(abs(box.impactOffset) < 0.1 && abs(box.impactVelocity) < 0.1) {
                    box.impactOffset = 0;
                    box.impactVelocity = 0;
                }
            }
        }
        
        battleBoxes[i] = box;
    }
    
    // Verifica saída do modo batalha
    if (!movingUp) {
        var allBoxesGone = true;
        for (var i = 0; i < array_length(battleBoxes); i++) {
            if (battleBoxes[i].y < room_height + 100) {
                allBoxesGone = false;
                break;
            }
        }
        
        var allCharactersReturned = true;
        if (instance_exists(objPlayer)) {
            with (objPlayer) {
                if (jumpState == "landed" || jumpState == "jumping") {
                    allCharactersReturned = false;
                }
            }
        }
        
        with (ObjFollower) {
            if (jumpState == "landed" || jumpState == "jumping") {
                allCharactersReturned = false;
            }
        }
        
        if (allBoxesGone || allCharactersReturned) {
            battleBoxActive = false;
            battleBoxes = [];
            movingUp = true;
            
            if (instance_exists(objPlayer)) {
                with (objPlayer) {
                    if (jumpState != "none" && jumpState != "jumping") {
                        jumpState = "none";
                        battleBoxIndex = -1;
                    }
                }
            }
            
            with (ObjFollower) {
                if (jumpState != "none" && jumpState != "jumping") {
                    jumpState = "none";
                    battleBoxIndex = -1;
                }
            }
        }
    }
}

barAnimTimer++;

var topLerpAmount = topBarLerpSpeed + sin(barAnimTimer * 0.3) * 0.05;
var bottomLerpAmount = bottomBarLerpSpeed + cos(barAnimTimer * 0.25) * 0.03;

topLerpAmount = clamp(topLerpAmount, 0.15, 0.4);
bottomLerpAmount = clamp(bottomLerpAmount, 0.12, 0.35);

topBarY = lerp(topBarY, topBarTargetY, topLerpAmount);
bottomBarY = lerp(bottomBarY, bottomBarTargetY, bottomLerpAmount);

topBarScrollX += barScrollSpeed;
if(topBarScrollX >= 32) topBarScrollX -= 32;

bottomBarScrollX -= barScrollSpeed;
if(bottomBarScrollX <= -32) bottomBarScrollX += 32;

textureScrollX += textureScrollSpeedX;
textureScrollY -= textureScrollSpeedY;
if(textureScrollX >= 32) textureScrollX -= 32;
if(textureScrollY <= -32) textureScrollY += 32;