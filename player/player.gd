extends CharacterBody3D

@onready var camera: Camera3D = %Camera3D
@onready var marker: Marker3D = %Marker3D
@onready var cooldown_timer: Timer = %CooldownTimer
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.3
		camera.rotation_degrees.x -= event.relative.y * 0.2
		camera.rotation_degrees.x = clampf(camera.rotation_degrees.x, -60, 60)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta: float) -> void:
	const SPEED: float = 5.5
	var input_direction_2D: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_direction_3D: Vector3 = Vector3(input_direction_2D.x, 0.0, input_direction_2D.y)
	var direction: Vector3 = transform.basis * input_direction_3D
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	const JUMP_VELOCITY: float = 5.5
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0
	else:
		velocity.y += get_gravity().y * delta
	
	move_and_slide()
	
	if Input.is_action_pressed("shoot") and cooldown_timer.is_stopped():
		shoot_bullet()


func shoot_bullet() -> void:
	const BULLET: PackedScene = preload("uid://pyfhur244reh")
	var bullet: Node3D = BULLET.instantiate()
	marker.add_child(bullet)
	bullet.global_transform = marker.global_transform
	
	cooldown_timer.start()
	audio_stream_player.play()
