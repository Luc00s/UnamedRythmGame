
//Debug
depth = -9999;

//Data
global.data = {
    //Player
    save : [{
        character : array_create(0),
    }],
    
    currentSave : 0,
    
    //Tela
    screen : {
        width : 320,
        height : 180,
        
        size : 2,
        fullscreen : false,
    },
    
    volume : {
        master : 100,
        music : 100,
        sound : 100
    },
}

//Ajustando a tela
var _screen = global.data.screen
window_set_size(_screen.width*_screen.size, _screen.height*_screen.size);
display_reset(0, true);
surface_resize(application_surface, global.data.screen.width, global.data.screen.height);
display_set_gui_size(global.data.screen.width, global.data.screen.height);

//Ajustando o cursor
//window_set_cursor(cr_none);

//FMOD Music System
global.newMusic = {
    event : "event:/OST/forest", 
    intro : false,
}

global.music = {
    event : "",
    intro : false,
    instance : undefined 
}

musicGain = 0;
musicTransitioning = false;


global.musicVCA = fmod_studio_system_get_vca("vca:/Music");
global.masterVCA = fmod_studio_system_get_vca("vca:/Master");

//Pause
global.pause = false;

//Indo para a próxima tela
room_goto_next();