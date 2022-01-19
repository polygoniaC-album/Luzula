extends Area2D

export(String) var text:String = ""
export(String) var scene:String=""

func _ready() -> void:
	if !(global.avancement.has(scene) or scene ==  ProjectSettings.get_setting("luzula/end_scene")):
		queue_free()
		return
	
	global.current_scene.add_madeleine(name)
	
	var conn_err = connect("input_event", self, "area_input")
	if conn_err:
		global.report_errors("bouton", ["area.input_event -> area_input error: " + String(conn_err)])
	
	conn_err = connect("mouse_entered", self, "mouse_entered")
	if conn_err:
		global.report_errors("bouton", ["area.mouse_entered -> mouse_entered error: " + String(conn_err)])
	
	conn_err = connect("mouse_exited", self, "mouse_exited")
	if conn_err:
		global.report_errors("bouton", ["area.mouse_exited -> mouse_exited error: " + String(conn_err)])
	
	add_to_group("madeleines")

func area_input(_viewport, event, _shape_idx) -> void:
	# TODO: Expand this for other input events than mouse
	if event is InputEventMouseButton:
		if event.is_pressed():
			global.set_madeleine_coche(name)
			global.change_scene(scene, text)
			mouse_exited()

func mouse_entered() -> void:
	for node in get_tree().get_nodes_in_group("ui_souvenir"):
		node.enter_area(name)
func mouse_exited() -> void:
	for node in get_tree().get_nodes_in_group("ui_souvenir"):
		node.exit_area(name)
