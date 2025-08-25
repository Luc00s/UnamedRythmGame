
//Controles
var moveX = keyboard_check(vk_right)-keyboard_check(vk_left);
var moveY = keyboard_check(vk_down)-keyboard_check(vk_up);

//Velocidade
if(moveX != 0 or moveY != 0) {
    dir = point_direction(0, 0, moveX, moveY);
    hsp = approach(hsp, lengthdir_x(spd, dir), .25);
    vsp = approach(vsp, lengthdir_y(spd, dir), .25);
} else {
    hsp = approach(hsp, 0, .25);
    vsp = approach(vsp, 0, .25);
}

//Correndo
if(keyboard_check(ord("X"))) spd = approach(spd, runSpd, .1);
else spd = approach(spd, normalSpd, .1);

//Meus sprites
if(abs(hsp) > 0.1 or abs(vsp) > 0.1) { //Andando
    //Dando a velocidade a animação dependendo da velocidade de movimento
    image_speed = abs(hsp)+abs(vsp);
    image_speed = clamp(image_speed, 0, spd);
    
    //Virando suavemente para a direção correta
    spriteDir += angle_difference(dir, spriteDir)*.25;
    spriteDir = wrap(spriteDir, 0, 360);
    
    //Animação do personagem correndo
    if(abs(hsp)+abs(vsp) >= runSpd) spriteAction = "Run";
    //Animação do personagem andando
    else spriteAction = "Walk";
    
    //Som de passos
    if(image_index > 1 and image_index <= 2) {
        if(footstepSound = false) audio_play_sound(sndFootstep0, 0, false);
        footstepSound = true;
    }
    else if(image_index > 3 and image_index < 4) {
        if(footstepSound = false) audio_play_sound(sndFootstep1, 0, false);
        footstepSound = true;
    }
    else footstepSound = false;
}
else { //Parado
    blinkTimer = approach(blinkTimer, 0, 1);
    if(blinkTimer = 0) blinkTimer = irandom_range(defaultBlinkTimer[0], defaultBlinkTimer[1]);
    else if(blinkTimer <= 8) image_index = 1;
    else image_index = 0;
    
    spriteAction = "";
}

//Aplicando os sprites para todas as direções
var _sprite = $"spr{character+spriteAction}Down";
var _tired = "";
if(tired = true) _tired = "Tired";
switch(round(spriteDir/(360/8))) {
    case 0: case 8: _sprite = $"spr{character+spriteAction+_tired}Right"; break;
    case 1: _sprite = $"sprPlayer{spriteAction+_tired}UpRight"; break;
    case 2: _sprite = $"spr{character+spriteAction+_tired}Up"; break;
    case 3: _sprite = $"sprPlayer{spriteAction+_tired}UpLeft"; break;
    case 4: _sprite = $"spr{character+spriteAction+_tired}Left"; break;
    case 5: _sprite = $"sprPlayer{spriteAction+_tired}DownLeft"; break;
    case 6: _sprite = $"spr{character+spriteAction+_tired}Down"; break;
    case 7: _sprite = $"sprPlayer{spriteAction+_tired}DownRight"; break;
}
sprite_index = asset_get_index(_sprite);

//Colisão
collision();

//Enhanced movement recording with distance-based and time-based triggers
movementDistance += point_distance(lastRecordedX, lastRecordedY, x, y);
var timeSinceLastRecord = (historyIndex == 0) ? 999 : 1;
var shouldRecord = (movementDistance >= minRecordDistance) || (timeSinceLastRecord >= 3);

if (shouldRecord) {
    //Circular buffer - more efficient than array shifting
    historyIndex = (historyIndex + 1) % historyBufferSize;
    
    //Record current state
    positionX[historyIndex] = x;
    positionY[historyIndex] = y;
    recordSprite[historyIndex] = sprite_index;
    recordImageXScale[historyIndex] = image_xscale;
    recordSpeed[historyIndex] = point_distance(0, 0, hsp, vsp);
    recordDirection[historyIndex] = spriteDir;
    
    //Reset tracking
    movementDistance = 0;
    lastRecordedX = x;
    lastRecordedY = y;
}