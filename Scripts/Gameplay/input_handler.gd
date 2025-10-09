class_name InputHandler
extends Node2D

@export var _das_timer: Timer

var _is_left_presed: bool
var _is_right_presed: bool

var _horizontal_input: int

signal horizontal_input_changed(direction: int)
signal das_changed(enabled: bool)
signal hard_drop_pressed()
signal soft_drop_input_changed(is_pressed: bool)
signal rotate_clockwise_pressed()
signal rotate_counterclockwise_pressed()
signal hold_pressed()
 
func _ready() -> void:
    TInput.actions[TInput.ActionId.MOVE_LEFT].changed.connect(_on_move_left_change)
    TInput.actions[TInput.ActionId.MOVE_RIGHT].changed.connect(_on_move_right_change)
    TInput.actions[TInput.ActionId.SOFT_DROP].changed.connect(_on_soft_drop_change)
    TInput.actions[TInput.ActionId.HARD_DROP].changed.connect(_on_hard_drop_change)
    TInput.actions[TInput.ActionId.ROTATE_CLOCKWISE].changed.connect(_on_rotate_clockwise_change)
    TInput.actions[TInput.ActionId.ROTATE_COUNTERCLOCKWISE].changed.connect(_on_rotate_counterclockwise_change)
    TInput.actions[TInput.ActionId.HOLD].changed.connect(_on_hold_change)
    
func _exit_tree() -> void:
    TInput.actions[TInput.ActionId.MOVE_LEFT].changed.disconnect(_on_move_left_change)
    TInput.actions[TInput.ActionId.MOVE_RIGHT].changed.disconnect(_on_move_right_change)
    TInput.actions[TInput.ActionId.SOFT_DROP].changed.disconnect(_on_soft_drop_change)
    TInput.actions[TInput.ActionId.HARD_DROP].changed.disconnect(_on_hard_drop_change)
    TInput.actions[TInput.ActionId.ROTATE_CLOCKWISE].changed.disconnect(_on_rotate_clockwise_change)
    TInput.actions[TInput.ActionId.ROTATE_COUNTERCLOCKWISE].changed.disconnect(_on_rotate_counterclockwise_change)
    TInput.actions[TInput.ActionId.HOLD].changed.disconnect(_on_hold_change)

func _on_move_left_change(is_pressed: bool):
    _is_left_presed = is_pressed
    _update_horizontal_movement()
    
func _on_move_right_change(is_pressed: bool):
    _is_right_presed = is_pressed
    _update_horizontal_movement()
        
func _update_horizontal_movement() -> void:
    var new_input = (1 if _is_right_presed else 0) + (-1 if _is_left_presed else 0)
    if new_input == _horizontal_input:
        return
        
    _horizontal_input = new_input
    if _horizontal_input != 0:
        _das_timer.start()
    else:
        _das_timer.stop()
        
    horizontal_input_changed.emit(_horizontal_input)
    das_changed.emit(false)
    
# TODO: Consider WASD as a Vector2 to DAS and Soft Drop cancel themselves when simultaneously, just like nes tetris
func _on_das_timer_timeout() -> void:
    das_changed.emit(true)
    
func _on_soft_drop_change(is_pressed: bool):
    soft_drop_input_changed.emit(is_pressed)
    
func _on_hard_drop_change(is_pressed: bool):
    if is_pressed:
        hard_drop_pressed.emit()
    
func _on_rotate_clockwise_change(is_pressed: bool):
    if is_pressed:
        rotate_clockwise_pressed.emit()
    
func _on_rotate_counterclockwise_change(is_pressed: bool):
    if is_pressed:
        rotate_counterclockwise_pressed.emit()

func _on_hold_change(is_pressed: bool):
    if is_pressed:
        hold_pressed.emit()
