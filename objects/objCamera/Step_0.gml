
//Seguindo o meu objeto de target se ele existir
if(instance_exists(target)) {
    if(variable_instance_exists(target, "drawX") and variable_instance_exists(target, "drawY")) {
        xTo = target.drawX;
        yTo = target.drawY-target.sprite_yoffset+target.sprite_height/2;
    } else {
        xTo = target.x;
        yTo = target.y;
    }
}

//Movendo a minha câmera 
x = lerp(x, xTo, camSmooth);
y = lerp(y, yTo, camSmooth);

//Prendendo a minha câmera dentro da room
x = clamp(x, camWidth/2, room_width-camWidth/2);
y = clamp(y, camHeight/2, room_height-camHeight/2);

//Aplicando a minha coordenada a câmera
var pixel_perfect_x = x-camWidth/2;
var pixel_perfect_y = y-camHeight/2;

camera_set_view_pos(cam, pixel_perfect_x, pixel_perfect_y);