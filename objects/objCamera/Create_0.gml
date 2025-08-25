//display_reset(0,1);

//Criando a câmera
cam = camera_create();
camera_set_view_size(cam, global.data.screen.width, global.data.screen.height);
view_set_camera(0, cam);
window_set_fullscreen(1)
//Setando o target da câmera
target = objPlayer;

//Pegando os valores da câmera
camWidth = camera_get_view_width(cam);
camHeight = camera_get_view_height(cam);

//Valor para deixar a câmera suave
camSmooth = 0.5;

//Coordenadas que devo seguir
xTo = 0;
yTo = 0;

//Seguindo a câmera
if(instance_exists(target)) {
    //Colocando as coordenadas que devo seguir como 
    xTo = target.x;
    yTo = target.y;
    
    x = xTo;
    y = yTo;
    
    x = clamp(x, camWidth/2, room_width-camWidth/2);
    y = clamp(y, camWidth/2, room_height-camHeight/2);
    
    camera_set_view_pos(cam, x-camWidth/2, y-camHeight/2);
}

layer_set_visible("Ground", false);