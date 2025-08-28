
//Volume
var _volume = global.data.volume;
var _masterVolume = _volume.master/100;
var _musicVolume = _volume.music/100;
var _soundVolume = _volume.sound/100;


if (global.masterVCA != undefined) {
    fmod_studio_vca_set_volume(global.masterVCA, _masterVolume);
}
if (global.musicVCA != undefined) {
    fmod_studio_vca_set_volume(global.musicVCA, _musicVolume);
}

//Configurando a musica
if(global.music.event != global.newMusic.event || global.music.intro != global.newMusic.intro) {
    //Iniciando transição
    if (!musicTransitioning) {
        musicTransitioning = true;
    }
    
    //Diminuindo o volume da musica
    musicGain = approach(musicGain, 0, .025);
    
    if(musicGain == 0) {
        //Parando a musica antiga
        if (global.music.instance != undefined) {
            fmod_studio_event_instance_stop(global.music.instance, FMOD_STUDIO_STOP_MODE.IMMEDIATE);
            fmod_studio_event_instance_release(global.music.instance);
            global.music.instance = undefined;
        }
        
        //Mudando a musica
        global.music.event = global.newMusic.event;
        global.music.intro = global.newMusic.intro;
        
        //Tocando a nova musica
        if (global.music.event != "") {
           
            var _eventDescription = fmod_studio_system_get_event(global.music.event);
            
            if (_eventDescription != undefined && fmod_last_result() == FMOD_RESULT.OK) {
                if (global.music.intro) {
                    
                    var _introEvent = global.music.event + "Intro";
                    var _introDescription = fmod_studio_system_get_event(_introEvent);
                    
                    if (_introDescription != undefined && fmod_last_result() == FMOD_RESULT.OK) {
                        
                        var _introInstance = fmod_studio_event_description_create_instance(_introDescription);
                        if (_introInstance != undefined) {
                            fmod_studio_event_instance_start(_introInstance);
                            fmod_studio_event_instance_release(_introInstance);
                            
                            
                            global.music.waitingForIntro = true;
                            global.music.introStartTime = current_time;
                            global.music.introDuration = 3000;
                        }
                    } else {
                        
                        global.music.instance = fmod_studio_event_description_create_instance(_eventDescription);
                        if (global.music.instance != undefined) {
                            fmod_studio_event_instance_start(global.music.instance);
                            global.music.waitingForIntro = false;
                        }
                    }
                } else {
                    
                    global.music.instance = fmod_studio_event_description_create_instance(_eventDescription);
                    if (global.music.instance != undefined) {
                        fmod_studio_event_instance_start(global.music.instance);
                        global.music.waitingForIntro = false;
                    }
                }
            }
            
            // Mostrando o display de qual musica está tocando
        }
        
        musicTransitioning = false;
    }
} else {
    if (variable_struct_exists(global.music, "waitingForIntro") && global.music.waitingForIntro) {
        if (current_time - global.music.introStartTime >= global.music.introDuration) {
            var _eventDescription = fmod_studio_system_get_event(global.music.event);
            if (_eventDescription != undefined && fmod_last_result() == FMOD_RESULT.OK) {
                global.music.instance = fmod_studio_event_description_create_instance(_eventDescription);
                if (global.music.instance != undefined) {
                    fmod_studio_event_instance_start(global.music.instance);
                }
            }
            global.music.waitingForIntro = false;
        }
    }
    

    if (!musicTransitioning && global.music.instance != undefined) {
        musicGain = approach(musicGain, 1, .025);
    }
}


if (global.music.instance != undefined) {
    fmod_studio_event_instance_set_volume(global.music.instance, musicGain);
}

//Pausando o jogo
if(keyboard_check_pressed(ord("P"))) {
    global.pause = !global.pause;
    
    if (global.music.instance != undefined) {
        fmod_studio_event_instance_set_paused(global.music.instance, global.pause);
    }
}

//Debug
if(keyboard_check_pressed(ord("R"))) room_restart();
if(keyboard_check(vk_shift) and keyboard_check_pressed(ord("R"))) game_restart();