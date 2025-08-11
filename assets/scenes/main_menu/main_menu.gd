extends Control

@onready var menu_handler: Node = $menu_handler

@export var bounce_length: float

func _ready() -> void:
	_start_logo_bounce_animation()
	_start_l_plus_r_bounce_animation() 


func _input(event: InputEvent) -> void:
	if (event.is_pressed() && event.is_action_pressed("enter")):
		match (menu_handler.current_menu):
			"":
				$"audio/press_l+r".play()
				menu_handler._change_menu("users")


func _start_logo_bounce_animation() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.bind_node($logo)
	tween.set_parallel(false)
	tween.set_loops()
	tween.tween_property($logo, "position:y", -bounce_length, 0.5).as_relative()
	tween.tween_property($logo, "position:y", bounce_length, 0.5).as_relative()


func _start_l_plus_r_bounce_animation() -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.bind_node($"press_l+r/l+r")
	tween.set_parallel(false)
	tween.set_loops()
	tween.tween_property($"press_l+r/l+r", "position:y", bounce_length*0.75, 0.75).as_relative()
	tween.tween_property($"press_l+r/l+r", "position:y", -bounce_length*0.75, 0.75).as_relative()
