class_name LineClearSoundEffects
extends Resource

@export var _piece_placement_sfx: AudioStream
@export var _line_clear_sfx: AudioStream
@export var _split_line_clear_sfx: AudioStream
@export var _split_tritris_sfx: AudioStream

func get_sfx(lines_cleared: int, is_piece_splitted: bool) -> AudioStream:
    if lines_cleared <= 0:
        return _piece_placement_sfx

    if !is_piece_splitted:
       return _line_clear_sfx 

    if lines_cleared < 3:
       return _split_line_clear_sfx 

    return _split_tritris_sfx
