class_name GameModeDisplayer
extends VBoxContainer

@onready var _first_option: SelectableOption = $Split/SelectableOption

@onready var _split_option: OptionWithLabel = $Split
@onready var _spawn_option: OptionWithLabel = $Spawn
@onready var _hold_option: OptionWithLabel = $Hold
@onready var _next_pieces_option: OptionWithLabel = $Next
@onready var _hard_drop_option: OptionWithLabel = $"Hard Drop"

@onready var _options: Array[OptionWithLabel] = [_split_option, _spawn_option, _hold_option, _next_pieces_option, _hard_drop_option]

var _custom_game_mode: CustomGameMode

signal customization_finished(custom_game_mode: CustomGameMode)
signal customized_game_mode(custom_game_mode: CustomGameMode)

func _ready() -> void:
    for option in _options:
        option.confirmed.connect(_confirm_customization)
        option.changed.connect(_on_changed_customization)
    
func _exit_tree() -> void:
   for option in _options:
        option.confirmed.disconnect(_confirm_customization)
        option.changed.disconnect(_on_changed_customization)

func show_game_mode_options(game_mode: GameMode) -> void:
    _split_option.set_option(game_mode.get_split_enabled())
    _spawn_option.set_option(game_mode.get_piece_spawn_mode())
    _hold_option.set_option(game_mode.get_hold_piece_enabled())
    _next_pieces_option.set_option(game_mode.get_next_pieces_look_ahead())
    _hard_drop_option.set_option(game_mode.get_hard_drop_enabled())

func customize_game_mode(custom_game_mode: CustomGameMode) -> void:
    _custom_game_mode = custom_game_mode
    _first_option.grab_focus()

func _update_game_mode_options() -> void:    
    _custom_game_mode.set_split_enabled(_split_option.get_selected_option())
    _custom_game_mode.set_piece_spawn_mode(_spawn_option.get_selected_option())
    _custom_game_mode.set_hold_piece_enabled(_hold_option.get_selected_option())
    _custom_game_mode.set_next_pieces_look_ahead(_next_pieces_option.get_selected_option())
    _custom_game_mode.set_hard_drop_enabled(_hard_drop_option.get_selected_option())
    
func _on_changed_customization() -> void:
    _update_game_mode_options()
    customized_game_mode.emit(_custom_game_mode)
    
func _confirm_customization() -> void:
    _update_game_mode_options()
    customization_finished.emit(_custom_game_mode)
