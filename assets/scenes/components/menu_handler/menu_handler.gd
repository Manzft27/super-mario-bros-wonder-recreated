extends Node

@export var default_menu: String = ""
var current_menu: String = ""


func _ready() -> void:
	_check_menus_node()
	if (default_menu != ""):
		_change_menu(default_menu)


func _change_menu(menu: String):
	if (menu != ""):
		get_parent().get_node("menus/"+menu).show()
	if (current_menu != ""):
		get_parent().get_node("menus/"+current_menu).hide()
	current_menu = menu


func _check_menus_node() -> void:
	var node = get_parent().find_child("menus", false)
	if (node == null):
		print("Can't find menu node, can't handle menus system")
