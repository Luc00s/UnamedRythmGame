//Volume
var _volume = global.data.volume;
var _masterVolume = _volume.master/100;
var _musicVolume = _volume.music/100*_masterVolume;
var _soundVolume = _volume.sound/100*_masterVolume;

//Configurando a musica
if(global.music != global.newMusic) {
    //Diminuindo o volume da musica
    musicGain = approach(musicGain, 0, .025);
    if(musicGain = 0) {
        //Parando a musica antiga
        audio_stop_sound(global.music.song);
        
        //Mudando a musica
        global.music = global.newMusic;
        
        //Tocando a nova musica
        if(audio_exists(global.music.song)) {
            switch(global.music.intro) {
                case true: {
                    var _intro = audio_get_name(global.music.song)+"Intro";
                    var _asset = asset_get_index(_intro);
                    
                    if(audio_exists(_asset)) audio_play_sound(_asset, 0, false);
                } break;
                
                case false: {
                    audio_play_sound(global.music.song, 0, true);
                } break;
            }
            
            //Mostrando o display de qual musica está tocando
            
        }
    }
} else {
    var _intro = audio_get_name(global.music.song)+"Intro";
    var _asset = asset_get_index(_intro);
    if(audio_exists(_asset) and !audio_is_playing(_asset) and global.music.intro = true) {
        audio_play_sound(global.music.song, 0, true);
        setMusic(global.music.song, false);
    }
    
    if(!audio_is_paused(global.music.song)) musicGain = approach(musicGain, 1, .025);
}
if(audio_exists(global.music.song)) audio_sound_gain(global.music.song, musicGain*_musicVolume, 0);

//Pausando o jogo
if(keyboard_check_pressed(ord("P"))) {
    if(global.pause = false) global.pause = true;
    else if(global.pause = true) global.pause = false;
}

//Debug
if(keyboard_check_pressed(ord("R"))) room_restart();
if(keyboard_check(vk_shift) and keyboard_check_pressed(ord("R"))) game_restart();