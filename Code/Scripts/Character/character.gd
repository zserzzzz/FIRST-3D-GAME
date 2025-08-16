extends CharacterBody3D

# --- Movement ---
const SPEED = 10.0
const JUMP_VELOCITY = 4.5

# --- Look sensitivity ---
const CONTROLLER_SENSITIVITY = 0.09
const MOUSE_SENSITIVITY = 0.005
const LOOK_SMOOTHNESS = 5.0  # higher = smoother

var vertical_look := 0.0
var target_horizontal_look := 0.0
var target_vertical_look := 0.0

# --- References ---
@onready var cam: Camera3D = $Camera3D
@onready var anim_player: AnimationPlayer = $Model/AnimationPlayer
@onready var model: Node3D = $Model


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		target_horizontal_look -= event.relative.x * MOUSE_SENSITIVITY
		target_vertical_look -= event.relative.y * MOUSE_SENSITIVITY

func _process(delta):
	# Controller look input (Right Stick: axis 2 = horizontal, axis 3 = vertical)
	var controller_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var controller_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

	target_horizontal_look -= controller_x * CONTROLLER_SENSITIVITY
	target_vertical_look -= controller_y * CONTROLLER_SENSITIVITY

	# Clamp vertical look
	target_vertical_look = clamp(target_vertical_look, deg_to_rad(-80), deg_to_rad(80))

	# Smoothly lerp towards target look values
	rotation.y = lerp_angle(rotation.y, target_horizontal_look, delta * LOOK_SMOOTHNESS)
	cam.rotation.x = lerp(cam.rotation.x, target_vertical_look, delta * LOOK_SMOOTHNESS)


func _physics_process(delta: float) -> void:
	# Gravity
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	# Jump
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var input_dir = Input.get_vector("a", "d", "s", "w")
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var direction = (forward * input_dir.y + right * input_dir.x).normalized()

	if direction.length() > 0.1:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if anim_player.current_animation != "walk":
			anim_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if anim_player.current_animation != "idle":
			anim_player.play("idle")

	move_and_slide()
