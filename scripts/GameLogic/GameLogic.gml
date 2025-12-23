enum Turn {
    NOUGHTS,
    CROSSES
};

enum TileState{
    EMPTY_ACTIVE,
    NOUGHTS_ACTIVE,
    CROSSES_ACTIVE,
    EMPTY_INACTIVE,
    NOUGHTS_INACTIVE,
    CROSSES_INACTIVE, 
}


function change_turn () {
    if(global.turn == Turn.NOUGHTS) {
        global.turn = Turn.CROSSES;
    } else {
        global.turn = Turn.NOUGHTS;
    }
}

function get_tile_state() {
    return (global.turn == Turn.CROSSES)? TileState.CROSSES_ACTIVE : TileState.NOUGHTS_ACTIVE;
}

turn = Turn.NOUGHTS;

//The position of square (0, 0), gets updated by the square itself during Create event
origin_x = 0;
origin_y = 0;


squares = [
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
     
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
    
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
    undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
]

minigames = [
    TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
    TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
    TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
]

function reset_game_values() {
    global.turn = Turn.NOUGHTS;
    global.squares = [
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
         
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
        
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined, 
        undefined, undefined, undefined,    undefined, undefined, undefined,    undefined, undefined, undefined,
    ]
    global.minigames = [
        TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
        TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
        TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE, TileState.EMPTY_ACTIVE,
    ]
}


//Taken from the Python version
win_conditions = [[0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 4, 8], [6, 4, 2]];

//TODO change this, because eventually button layout will break this code
function register_square() {
    
    coord_x = (x - global.origin_x)/64;
    coord_y = (y - global.origin_y)/64;
    
    index = coord_x + 9*coord_y;
    
    array_set(global.squares, index, self)
}

// We know the square is EMPTY_ACTIVE, and has been changed to the correct symbol, still active
// This is executing in the context of the squares
function square_clicked() {
    
    change_turn();
    
    var _minigame_index = get_minigame_index(coord_x, coord_y);
    update_minigame_status(_minigame_index);
    
    //Set this minigame to active, all others to inactive
    //Unless this minigame is over, in which case open the board up
    var _position_within_board = coord_x%3 + (coord_y%3)*3;
    
    
    
    if(check_game_over()!=TileState.EMPTY_ACTIVE) {
        //TODO handle various end game cases
        return;
    }
    
    //Tried to move to an inactive minigame
    if(global.minigames[_position_within_board]!=TileState.EMPTY_ACTIVE) {
        for (var i = 0; i < 9; i++) {
        	set_minigame_status(i, global.minigames[i]==TileState.EMPTY_ACTIVE)
        }
    } else {
        for (var i = 0; i < 9; i++) {
        	set_minigame_status(i, i==_position_within_board);
        }
    }
    
    /*
     
    if(minigame at _position_within_board is over) {
        activate all unfinished minigames
    } else {
    
      for(i from 0 to 9) { 
         if(i == _position_within_board) {
           set minigame i active
        }
         
         set minigame i inactive

      }
    }
    */
    
}


// MINIGAME HANDLING CODE

function get_minigame_index(_x=0, _y=0) {
    return floor(_x/3) + floor(_y/3)*3;
}

//I'm incredibly proud of this function
function get_minigame_indices(mg_index=0) {
    var _indices = []
    
    for (var _mx = 0; _mx < 3; _mx++) {
    	for (var _my = 0; _my < 3; _my++) {
            var _x = (mg_index % 3)*3 + _mx;
            var _y = floor(mg_index/3)*3 + _my;
        	var _index = _x + 9*_y;
            array_push(_indices, _index);
        }
    }
    return _indices;
}

//Also taken from Python version
function update_minigame_status(mg_index=0) {
    //If this minigame is over, don't update anything
    //This shouldn't be called, since the minigame should be inactive now
    if(global.minigames[mg_index]!=TileState.EMPTY_ACTIVE) {
        return;
    }
    
    var _minigame_squares = get_minigame_indices(mg_index);
    
    //Current state of the minigame
    var _mg_state = TileState.EMPTY_ACTIVE;
    
    for (var i = 0; i < array_length(global.win_conditions); i++) {
        var _cond = global.win_conditions[i];
    	var _pot_victor = _minigame_squares[_cond[0]];
        var _pot_vic_state = global.squares[_pot_victor].state;
        
        //TODO check errors when updating status of inactive minigame (shouldn't happen tho)
        if(_pot_vic_state == TileState.EMPTY_ACTIVE) {
            continue;
        }
        
        var _other_1 = _minigame_squares[_cond[1]];
        var _other_2 = _minigame_squares[_cond[2]];
        
        if(_pot_vic_state == global.squares[_other_1].state && _pot_vic_state == global.squares[_other_2].state){
            _mg_state = _pot_vic_state;
        }
    }
    
    //Minigame hasn't been won, could be a tie though
    if(_mg_state == TileState.EMPTY_ACTIVE) {
        var _tie = true;
        for (var i = 0; i < 9 && _tie; i++) {
        	if(global.squares[_minigame_squares[i]].state==TileState.EMPTY_ACTIVE){
                _tie = false;
            }
        }
        if(_tie) {
            _mg_state = TileState.EMPTY_INACTIVE;
        }
    }
    
    if(_mg_state != TileState.EMPTY_ACTIVE) {
        set_minigame_status(mg_index, false);
    }
    
    global.minigames[mg_index] = _mg_state;
}


function set_minigame_status(mg_index=0, active=true) {
    var _minigame_squares = get_minigame_indices(mg_index);
    
    for (var i = 0; i < 9; i++) {
        global.squares[_minigame_squares[i]].set_active(active);
    }
}


//GAME HANDLING CODE

function check_game_over() {
    var _victor = TileState.EMPTY_ACTIVE;
    for (var i = 0; i < array_length(global.win_conditions); i++) {
        var _cond = global.win_conditions[i];
    	var _pot_victor = global.minigames[_cond[0]];
        
        if(_pot_victor == TileState.EMPTY_ACTIVE) {
            continue;
        }
        
        var _other_1 = global.minigames[_cond[1]];
        var _other_2 = global.minigames[_cond[2]];
        
        if(_pot_victor == _other_1 && _pot_victor == _other_2){
            _victor = _pot_victor;
        }
    }
    
    if(_victor != TileState.EMPTY_ACTIVE) {
        show_debug_message($"There is a winner! {_victor}");
    }
    
    //Game hasn't been won, could be a tie though
    if(_victor == TileState.EMPTY_ACTIVE) {
        var _tie = true;
        for (var i = 0; i < 9 && _tie; i++) {
        	if(global.minigames[i]==TileState.EMPTY_ACTIVE){
                _tie = false;
            }
        }
        if(_tie) {
            _victor = TileState.EMPTY_INACTIVE;
        }
    }
    
    if(_victor != TileState.EMPTY_ACTIVE) {
        show_debug_message($"Game is over! {_victor}");
    }
    return _victor;
}
