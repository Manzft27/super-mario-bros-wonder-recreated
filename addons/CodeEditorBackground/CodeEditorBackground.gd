@tool
extends EditorPlugin

var codes : Array = ["0", "1", "2", "3", "4", "5", "6",
"7", "8", "9", "a", "b", "c", "d", "e", "f"]

var cse
var se
var defaultBackground :String = "res://addons/CodeEditorBackground/Background/Background.png"
var at = load("res://addons/CodeEditorBackground/Background Options.tscn")
var at_inst
signal setData

var UserData : Dictionary = {
	"userBackground" : "",
	"userTransparency" : "1e",
	"randomFolder": "",
	"mode": 6,
	"OpacityValue": 30
}

func _enter_tree() -> void:
	get_editor_interface().get_script_editor().connect("editor_script_changed", Callable(self, "changed"))
	get_editor_interface().get_script_editor().connect("resized", Callable(self, "ResizeBackground"))
	add_tool_menu_item("Change Background", Callable(self, "ShowWindow"))
	at_inst = at.instantiate()
	add_control_to_dock(2, at_inst)
	at_inst.connect("Transparency_Update", Callable(self, "set_transparency"))
	at_inst.connect("Update_Stretch", Callable(self, "Stretch_Update"))
	at_inst.connect("RandomBG", Callable(self, "RandomBackground"))
	at_inst.connect("SaveSettings", Callable(self, "SaveData"))
	at_inst.connect("ChangeBackground", Callable(self, "ShowWindow"))
	self.connect("setData", Callable(at_inst, "LoadingData"))
	LoadData()
	changed(null)


func _exit_tree() -> void:
	remove_tool_menu_item("Change Background")
	cse = get_editor_interface().get_script_editor().get_open_script_editors()
	remove_control_from_docks(at_inst)
	for all in cse:
		se = all.get_child(0).get_child(0).get_child(0)
		if se.get_child_count() >= 1:
			se.get_child(0).queue_free()


func changed(script: Script) -> void:
	cse = get_editor_interface().get_script_editor().get_current_editor()
	se = cse.get_child(0).get_child(0).get_child(0)
	var bg = TextureRect.new()
	
	if UserData["userBackground"]:
		var img = Image.new()
		img.load(UserData["userBackground"])
		var tex = ImageTexture.new()
		tex.set_image(img)
		bg.texture = tex

	else:
		bg.texture = load(defaultBackground)
	bg.set_stretch_mode(UserData["mode"])
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.self_modulate = Color("ffffff" + UserData["userTransparency"])
	bg.size = cse.get_child(0).get_child(0).get_child(0).size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if se.get_child_count() >= 1:
		se.get_child(0).queue_free()
	se.add_child(bg)
	se.move_child(bg, 0)


func ResizeBackground() -> void:
	if se.get_child_count() == 1:
		se.get_child(0).size = se.size


func ShowWindow() -> void:
	var w = load("res://addons/CodeEditorBackground/file_dialog.tscn").instantiate()
	w.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
	w.size = Vector2(500, 300)
	w.title = "Choose an Image"
	add_child(w)
	w.connect("file_selected", Callable(self, "LoadImage"))


func LoadImage(path:String) -> void:
	UserData["userBackground"] = path
	changed(null)


func set_transparency(value:int ) -> void:
	var ans = value/16
	var rem = value%16
	UserData["userTransparency"] = codes[ans] + codes[rem]
	UserData["OpacityValue"] = value
	changed(null)


func Stretch_Update(id: int) -> void:
	UserData["mode"] = id
	changed(null)


func RandomBackground(files: Array, path: String) -> void:
	UserData["userBackground"] = files.pick_random()
	UserData["randomFolder"] = path
	changed((null))


func SaveData() -> void:
	var f = FileAccess.open_encrypted_with_pass("res://addons/CodeEditorBackground/UserSettings.json", FileAccess.WRITE, "PoutineForEnlynn")
	f.store_line(JSON.stringify(UserData))
	print("User data stored at res://addons/CodeEditorBackground/UserSettings.json")


func LoadData() -> void:
	if FileAccess.file_exists("res://addons/CodeEditorBackground/UserSettings.json"):
		var f = FileAccess.open_encrypted_with_pass("res://addons/CodeEditorBackground/UserSettings.json", FileAccess.READ, "PoutineForEnlynn")
		var j = JSON.new()
		var parse_error = j.parse(f.get_as_text())
		if parse_error == 0:
			UserData = j.get_data()
			setLoadedData()


func setLoadedData() -> void:
	emit_signal("setData", UserData)




