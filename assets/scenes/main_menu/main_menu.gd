extends Control

@export var bounce_length: float

func _ready() -> void:
	_start_logo_bounce_animation()
	_start_press_l_plus_r_bounce_animation()


func _start_logo_bounce_animation() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.bind_node($logo)
	tween.set_parallel(false)
	tween.set_loops()
	tween.tween_property($logo, "position:y", -bounce_length, 0.5).as_relative()
	tween.tween_property($logo, "position:y", bounce_length, 0.5).as_relative()


func _start_press_l_plus_r_bounce_animation() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.bind_node($"press_l+r")
	tween.set_parallel(false)
	tween.set_loops()
	tween.tween_property($"press_l+r", "position:y", -bounce_length*0.75, 0.5).as_relative()
	tween.tween_property($"press_l+r", "position:y", bounce_length*0.75, 0.5).as_relative()
