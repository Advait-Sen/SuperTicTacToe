if (clicked && hovering) {
    //audio_play_sound(snd_button, 1, false);
    clicked_action();
	image_index = 1;
} 
else {
	image_index = 0;
}

clicked = false;