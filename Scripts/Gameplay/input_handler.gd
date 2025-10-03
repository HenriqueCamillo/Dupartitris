extends Node2D
class_name InputHandler

@export var das_timer: Timer

var is_left_presed: bool
var is_right_presed: bool

var horizontal_input: int

signal horizontal_input_changed(direction: int)
signal das_changed(enabled: bool)
signal hard_drop_pressed()
signal soft_drop_input_changed(is_pressed: bool)
signal rotate_clockwise_pressed()
signal rotate_counterclockwise_pressed()

 
func _ready() -> void:
	TInput.actions[TInput.ActionId.MOVE_LEFT].changed.connect(on_move_left_change)
	TInput.actions[TInput.ActionId.MOVE_RIGHT].changed.connect(on_move_right_change)
	TInput.actions[TInput.ActionId.SOFT_DROP].changed.connect(on_soft_drop_change)
	TInput.actions[TInput.ActionId.HARD_DROP].changed.connect(on_hard_drop_change)
	TInput.actions[TInput.ActionId.ROTATE_CLOCKWISE].changed.connect(on_rotate_clockwise_change)
	TInput.actions[TInput.ActionId.ROTATE_COUNTERCLOCKWISE].changed.connect(on_rotate_counterclockwise_change)
	
func _exit_tree() -> void:
	TInput.actions[TInput.ActionId.MOVE_LEFT].changed.disconnect(on_move_left_change)
	TInput.actions[TInput.ActionId.MOVE_RIGHT].changed.disconnect(on_move_right_change)
	TInput.actions[TInput.ActionId.SOFT_DROP].changed.disconnect(on_soft_drop_change)
	TInput.actions[TInput.ActionId.HARD_DROP].changed.disconnect(on_hard_drop_change)
	TInput.actions[TInput.ActionId.ROTATE_CLOCKWISE].changed.disconnect(on_rotate_clockwise_change)
	TInput.actions[TInput.ActionId.ROTATE_COUNTERCLOCKWISE].changed.disconnect(on_rotate_counterclockwise_change)
	
func on_move_left_change(is_pressed: bool):
	is_left_presed = is_pressed
	update_horizontal_movement()
	
func on_move_right_change(is_pressed: bool):
	is_right_presed = is_pressed
	update_horizontal_movement()
		
func update_horizontal_movement() -> void:
	var new_input = (1 if is_right_presed else 0) + (-1 if is_left_presed else 0)
	if new_input == horizontal_input:
		return
		
	horizontal_input = new_input
	if horizontal_input != 0:
		das_timer.start()
	else:
		das_timer.stop()
		
	horizontal_input_changed.emit(horizontal_input)
	das_changed.emit(false)
	
func _on_das_timer_timeout() -> void:
	das_changed.emit(true)
	
func on_soft_drop_change(is_pressed: bool):
	soft_drop_input_changed.emit(is_pressed)
	
func on_hard_drop_change(is_pressed: bool):
	if is_pressed:
		hard_drop_pressed.emit()
	
func on_rotate_clockwise_change(is_pressed: bool):
	if is_pressed:
		rotate_clockwise_pressed.emit()
	
func on_rotate_counterclockwise_change(is_pressed: bool):
	if is_pressed:
		rotate_counterclockwise_pressed.emit()
