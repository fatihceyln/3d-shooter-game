extends Node3D

@onready var score_label: Label = %ScoreLabel

var player_score: int = 0


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
