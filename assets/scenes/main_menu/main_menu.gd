extends Control

@export var logo_bounce_length: float

func _ready() -> void:
	_start_logo_bounce_animation()


func _start_logo_bounce_animation() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.bind_node($logo)
	tween.set_parallel(false)
	tween.set_loops()
	tween.tween_property($logo, "position:y", -logo_bounce_length, 0.5).as_relative()
	tween.tween_property($logo, "position:y", logo_bounce_length, 0.5).as_relative()
