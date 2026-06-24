extends Node3D

@onready var score_label: Label = %ScoreLabel
@onready var time_label: Label = %TimeLabel
@onready var timer: Timer = %Timer
@onready var game_over_layer: CanvasLayer = %GameOverLayer

var player_score: int = 0
var time_left: int = 10

var mob_spawners: Array[MobSpawner] = []

func _ready() -> void:
	update_timer_label()
	find_mob_spawners()


func find_mob_spawners():
	for child in get_children():
		if child is MobSpawner:
			mob_spawners.append(child)


func update_timer_label() -> void:
		time_label.text = "Time left: " + str(time_left)


func increase_score() -> void:
	player_score += 1
	score_label.text = "Score: " + str(player_score)


func do_poof(mob_global_position: Vector3) -> void:
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof: Node3D = SMOKE_PUFF.instantiate() as Node3D
	add_child(poof)
	poof.global_position = mob_global_position


func _on_mob_spawner_mob_spawned(mob: Node3D) -> void:
	do_poof(mob.global_position)
	if mob.has_signal("died"):
		mob.died.connect(func () -> void:
			do_poof(mob.global_position)
		)
		
	if mob.has_signal("health_depleted"):
		mob.health_depleted.connect(increase_score)


func _on_kill_zone_body_entered(_body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()


func _on_timer_timeout() -> void:
	time_left -= 1
	update_timer_label()
	
	if time_left == 0:
		timer.stop()
		game_over_layer.visible = true
		for mob_spawner in mob_spawners:
			mob_spawner.stop_spawning()
