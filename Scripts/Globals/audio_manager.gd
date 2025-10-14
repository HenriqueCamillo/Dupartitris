class_name AudioManager
extends Node2D

static var instance: AudioManager

@export var _music_player: AudioStreamPlayer2D
@export var _sfx_players: Array[AudioStreamPlayer2D]

func _ready() -> void:
    if instance != null:
        push_error("Trying to instantiate a second audio manager")
        queue_free()
        return
    
    instance = self

func _exit_tree() -> void:
    if instance == self:
        instance = null
        
func _get_sfx_player() -> AudioStreamPlayer2D:
    for sfx_player in _sfx_players:
        if !sfx_player.playing:
            return sfx_player
            
    return _sfx_players[0]
    
func play_music(music: AudioStream) -> void:
    if music == null:
        push_error("Trying to play null music:\n" + str(get_stack()))
        return

    _music_player.stream = music
    _music_player.play()

func stop_music() -> void:
    _music_player.stop()
        
func play_sfx(sfx: AudioStream) -> void:
    if sfx == null:
        push_error("Trying to play null sfx:\n" + str(get_stack()))
        return

    var sfx_player = _get_sfx_player()
    sfx_player.stream = sfx
    sfx_player.play()
