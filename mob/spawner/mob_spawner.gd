extends Node3D

signal mob_spawned(mob: Node3D)

@export var mob_to_spawn: PackedScene = null

@onready var marker: Marker3D = %Marker3D
@onready var timer: Timer = %Timer


func _on_timer_timeout() -> void:
	if mob_to_spawn == null: return
	
	var mob: Node3D = mob_to_spawn.instantiate() as Node3D
	add_child(mob)
	mob.global_position = marker.global_position
	mob_spawned.emit(mob)
