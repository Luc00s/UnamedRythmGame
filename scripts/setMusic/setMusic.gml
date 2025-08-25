function setMusic(song, intro = false) {
    if(global.newMusic.song != song) {
        global.newMusic = {
            song : song,
            intro : intro,
        }
    }
}