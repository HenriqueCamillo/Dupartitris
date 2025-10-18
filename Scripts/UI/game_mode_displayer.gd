class_name GameModeDisplayer
extends VBoxContainer

@onready var _first_option: SelectableOption = $Split/SelectableOption

@onready var _split_option: OptionWithLabel = $Split
@onready var _spawn_option: OptionWithLabel = $Spawn
@onready var _hold_option: OptionWithLabel = $Hold
@onready var _next_pieces_option: OptionWithLabel = $Next
@onready var _hard_drop_option: OptionWithLabel = $"Hard Drop"

var _custom_game_mode: CustomGameMode

signal customization_finished(custom_game_mode: CustomGameMode)

func _ready() -> void:
    _split_option.confirmed.connect(_confirm_customization)
    _spawn_option.confirmed.connect(_confirm_customization)
    _hold_option.confirmed.connect(_confirm_customization)
    _next_pieces_option.confirmed.connect(_confirm_customization)
    _hard_drop_option.confirmed.connect(_confirm_customization)
    
func _exit_tree() -> void:
    _split_option.confirmed.disconnect(_confirm_customization)
    _spawn_option.confirmed.disconnect(_confirm_customization)
    _hold_option.confirmed.disconnect(_confirm_customization)
    _next_pieces_option.confirmed.disconnect(_confirm_customization)
    _hard_drop_option.confirmed.disconnect(_confirm_customization)

func show_game_mode_options(game_mode: GameMode) -> void:
    _split_option.set_option(game_mode.get_split_enabled())
    _spawn_option.set_option(game_mode.get_piece_spawn_mode())
    _hold_option.set_option(game_mode.get_hold_piece_enabled())
    _next_pieces_option.set_option(game_mode.get_next_pieces_look_ahead())
    _hard_drop_option.set_option(game_mode.get_hard_drop_enabled())

func customize_game_mode(custom_game_mode: CustomGameMode) -> void:
    _custom_game_mode = custom_game_mode
    _first_option.grab_focus()
    
func _confirm_customization() -> void:
    _custom_game_mode.set_split_enabled(_split_option.get_selected_option())
    _custom_game_mode.set_piece_spawn_mode(_spawn_option.get_selected_option())
    _custom_game_mode.set_hold_piece_enabled(_hold_option.get_selected_option())
    _custom_game_mode.set_next_pieces_look_ahead(_next_pieces_option.get_selected_option())
    _custom_game_mode.set_hard_drop_enabled(_hard_drop_option.get_selected_option())
    
    customization_finished.emit(_custom_game_mode)
