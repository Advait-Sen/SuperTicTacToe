//TODO use this to check for issues with room setup, maybe issues with window size

var _all_checks_passed = true;

for (var i = 0; i < 81; i++) {
	var _button_state = global.squares[i];
    var _dx = (_button_state.x - global.origin_x)/64;
    var _dy = (_button_state.y - global.origin_y)/64;
    
    var _index = _dx + 9*_dy;
    
    if(_index != i) {
        _all_checks_passed = false;
    }
    
}

show_debug_message($"All squares are present: {_all_checks_passed}");
