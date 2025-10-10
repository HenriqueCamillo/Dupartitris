extends Node

func one_frame() -> void:
    await Engine.get_main_loop().process_frame

func frames(number_of_frames: int) -> void:
    for frame in range(number_of_frames):
        await Engine.get_main_loop().process_frame
        
func one_physics_frame() -> void:
    await Engine.get_main_loop().process_frame

func physics_frames(number_of_frames: int) -> void:
    for frame in range(number_of_frames):
        await Engine.get_main_loop().process_frame
