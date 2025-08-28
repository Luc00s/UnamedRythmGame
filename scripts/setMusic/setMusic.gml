/// setMusic(event_path, has_intro)
/// @param {string} event_path The FMOD event path (e.g., "event:/OST/forest")
/// @param {bool} has_intro Whether this music has an intro
function setMusic(_event, _intro = false) {
    global.newMusic = {
        event : _event,
        intro : _intro
    };
}

/// stopMusic()
/// Stops the current music immediately
function stopMusic() {
    if (global.music.instance != undefined) {
        fmod_studio_event_instance_stop(global.music.instance, FMOD_STUDIO_STOP_MODE.IMMEDIATE);
        fmod_studio_event_instance_release(global.music.instance);
        global.music.instance = undefined;
    }
    global.music.event = "";
    global.newMusic.event = "";
    
    // Reset musicGain if objControl exists
    if (instance_exists(objControl)) {
        with (objControl) {
            musicGain = 0;
        }
    }
}

/// fadeOutMusic(fade_speed)
/// @param {real} fade_speed How fast to fade out (default 0.025)
function fadeOutMusic(_speed = 0.025) {
    global.newMusic.event = "";
}