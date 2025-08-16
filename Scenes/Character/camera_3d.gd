extends Camera3D

var vertical_look = 0.0
const MOUSE_SENSITIVITY = 0.005

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		vertical_look += -event.relative.y * MOUSE_SENSITIVITY
		vertical_look = clamp(vertical_look, deg_to_rad(-80), deg_to_rad(80))
		rotation.x = vertical_look
