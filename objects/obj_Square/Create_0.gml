
if(is_origin) { //Setting global origin x and y for the top left square
    reset_game_values();
    global.origin_x = x;
    global.origin_y = y;
}

coord_x = 0;
coord_y = 0;

index = 0;

register_square();


function clicked_action() {
    if (is_active()) {
    	state = get_tile_state();
        image_index = (state == TileState.CROSSES_ACTIVE)? 1 : 2;
        square_clicked();
    }
}


state = TileState.EMPTY_ACTIVE;


function is_active() {
    return state == TileState.EMPTY_ACTIVE;
}


//Visual stuff
hovering = false;
clicked = false;


function set_active(active) {
    var _image_frame = image_index;
    var _tile_state = state;
    
    if(active) {
        //Idk if this is the best way to handle it, but it works to whatever
        switch(_tile_state) {
            case TileState.EMPTY_ACTIVE:
            case TileState.EMPTY_INACTIVE:
                state = TileState.EMPTY_ACTIVE;
                break;

            case TileState.NOUGHTS_ACTIVE:
            case TileState.NOUGHTS_INACTIVE:
                state = TileState.NOUGHTS_ACTIVE;
                break;

            case TileState.CROSSES_ACTIVE:
            case TileState.CROSSES_INACTIVE:
                state = TileState.CROSSES_ACTIVE;
                break;
        }
        
        sprite_index = spr_Square_active;
    } else {
        //Idk if this is the best way to handle it, but it works to whatever
        switch(_tile_state) {
            case TileState.EMPTY_ACTIVE:
            case TileState.EMPTY_INACTIVE:
                state = TileState.EMPTY_INACTIVE;
                break;

            case TileState.NOUGHTS_ACTIVE:
            case TileState.NOUGHTS_INACTIVE:
                state = TileState.NOUGHTS_INACTIVE;
                break;

            case TileState.CROSSES_ACTIVE:
            case TileState.CROSSES_INACTIVE:
                state = TileState.CROSSES_INACTIVE;
                break;
        }
        
        sprite_index = spr_Square_inactive;
    }
    
    image_index = _image_frame;
}