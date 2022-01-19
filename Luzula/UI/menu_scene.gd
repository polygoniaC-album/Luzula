extends Control

onready var vbox:VBoxContainer = $VBoxContainer
var current_hbox:HBoxContainer = null

var button_per_line:int = 7

func _ready() -> void:
	var err = $button_aide.connect("toggled", self, "set_aide")
	if err:
		global.report_errors("UI", ["button_aide.toggled -> set_aide"])
	
	err = $button_sauvegarde.connect("pressed", global, "sauvegarde")
	if err:
		global.report_errors("UI", ["button_sauvegarde.pressed -> global.sauvegarde"])
	
	$button_aide.pressed = global.config["aide"]
	
	global.UI = self
	
	for scene in global.avancement:
		if scene !=  ProjectSettings.get_setting("luzula/end_scene"):
			new_sceneButton(scene)
	if global.avancement.has(ProjectSettings.get_setting("luzula/end_scene")):
		new_sceneButton(ProjectSettings.get_setting("luzula/end_scene"))


func set_aide(value:bool) -> void:
	global.config["aide"] = value
	update_button()

func set_sauvegarde(value:bool) -> void:
	global.config["sauvegarde"] = value

func update_button(node:Control = vbox) -> void:
	for child in node.get_children():
		if child is BaseButton:
			child.update()
		else:
			update_button(child)
	
	$button_aide.pressed = global.config["aide"]

func new_sceneButton(scene:String) -> void:
	if !current_hbox:
		current_hbox = HBoxContainer.new()
		current_hbox.rect_min_size.y = 100
		current_hbox.alignment = HBoxContainer.ALIGN_CENTER
		vbox.add_child(current_hbox)
	elif current_hbox.get_child_count() >= 2 * button_per_line - 1:
		var sep:Control = Control.new()
		sep.rect_min_size.y = 10
		vbox.add_child(sep)
		current_hbox = HBoxContainer.new()
		current_hbox.rect_min_size.y = 100
		current_hbox.alignment = HBoxContainer.ALIGN_CENTER
		vbox.add_child(current_hbox)
	else:
		var sep:Control = Control.new()
		sep.rect_min_size.x = 10
		current_hbox.add_child(sep)
	
	var newButton:Control = load("res://Luzula/SceneButton.tscn").instance()
	newButton.set_name(scene)
	current_hbox.add_child(newButton)

