var _decor_layer = layer_get_id("Decoration_Back");
var _sprite = layer_sprite_get_id(_decor_layer, "winner_square");

switch (global.winner) {
	case TileState.CROSSES_ACTIVE:
        layer_sprite_index(_sprite, 1);
        break;
    
	case TileState.NOUGHTS_ACTIVE:
        layer_sprite_index(_sprite, 2);
        break;

    
	case TileState.EMPTY_INACTIVE:
        //Technically the default but still
        layer_sprite_index(_sprite, 0);
        break;
}
