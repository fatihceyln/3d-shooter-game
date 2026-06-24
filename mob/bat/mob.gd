extends RigidBody3D

signal died
signal health_depleted

var speed: float = randf_range(2.5, 4.0)
var health: int = 3

@onready var bat: Node3D = %BatModel
@onready var player: Node3D = get_node("/root/Game/Player")
@onready var death_timer: Timer = %DeathTimer
@onready var hurt_sound: AudioStreamPlayer3D = %HurtSound
@onready var death_sound: AudioStreamPlayer3D = %DeathSound


func _physics_process(_delta: float) -> void:
	var direction: Vector3 = global_position.direction_to(player.global_position)
	direction.y = 0
	linear_velocity = direction * speed
	bat.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI


func take_damage() -> void:
	if health == 0:
		return
		
	bat.hurt()
	health -= 1
	hurt_sound.play()
	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		lock_rotation = false
		var direction: Vector3 = -1 * global_position.direction_to(player.global_position)
		var random_upward_force: Vector3 = Vector3.UP * randf_range(1.0, 3.0)
		apply_central_impulse(direction * 10 * random_upward_force)
		death_timer.start()
		death_sound.play()
		health_depleted.emit()


func _on_death_timer_timeout() -> void:
	died.emit()
	queue_free()
