var speedSlider = document.getElementById("speed");



function play_song(name){
    url = "clips/"+name;
    play_url(url, document.getElementById('valDisplay').value);
}

function play_url(url, speed){
    mp3 = new Audio(url);
    mp3.playbackRate=speed;
    mp3.play();
}

function updateTextInput(val) {
    document.getElementById('valDisplay').value=val; 
}
