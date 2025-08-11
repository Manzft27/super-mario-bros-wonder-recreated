@tool
extends Control

@onready var OpacitySlider = $HSlider
@onready var StretchOptions = $StretchOptions
@onready var ChangeButton = $ChangeBackgroundButton
@onready var RandomButton = $RandomButton
@onready var SaveButton = $SaveButton
@onready var OpacityValue = $BarValue
@onready var DirectoryInput = $DirectoryLine

signal Transparency_Update
signal Update_Stretch
signal RandomBG
signal SaveSettings
signal ChangeBackground

func _ready() -> void:
	OpacitySlider.value = 30
	OpacitySlider.connect("value_changed", Callable(self, "_on_OpacitySlider_value_changed"))
	StretchOptions.select(6)
	RandomButton.connect("pressed", Callable(self, "_on_random_button_pressed"))
	SaveButton.connect("pressed", Callable(self, "_on_save_button_pressed"))
	ChangeButton.connect("pressed", Callable(self, "_on_change_button_pressed"))


func _on_OpacitySlider_value_changed(value: float) -> void:
	OpacityValue.text = str(value)
	emit_signal("Transparency_Update", int(value))


func _on_stretch_options_item_selected(index: int) -> void:
	emit_signal("Update_Stretch", index)


func _on_random_button_pressed() -> void:
	if DirectoryInput.text != "":
		var files = dir_contents(DirectoryInput.text)
		emit_signal("RandomBG", files, DirectoryInput.text)


func dir_contents(path: String) -> Array:
	var dir = DirAccess.open(path)
	var files: Array
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if file_name.get_extension() in ["jpg", "jpeg", "png"]:
					files.append(path + "/" + file_name)
			file_name = dir.get_next()
		return files
	else:
		print("An error occurred when trying to access the path.")
		return []


func _on_save_button_pressed() -> void:
	emit_signal("SaveSettings")


func _on_change_button_pressed() -> void:
	emit_signal("ChangeBackground")


func LoadingData(Data: Dictionary) -> void:
	DirectoryInput.text = Data["randomFolder"]
	OpacityValue.text = str(Data["OpacityValue"])
	OpacitySlider.value = Data["OpacityValue"]
	StretchOptions.select(Data["mode"])
