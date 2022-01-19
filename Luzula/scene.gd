tool

extends Node2D

var madeleines:PoolStringArray = PoolStringArray([])
var scene_name:String = ""

var t:float = ProjectSettings.get_setting("luzula/tmargin")
var b:float = ProjectSettings.get_setting("luzula/bmargin")
var l:float = ProjectSettings.get_setting("luzula/lmargin")
var r:float = ProjectSettings.get_setting("luzula/rmargin")

func _init():
	if !Engine.editor_hint:
		global.current_scene = self

func _ready():
	if !Engine.editor_hint:
		scene_name = filename.get_file().get_basename()
		global.set_scene_coche(scene_name, madeleines)

func _draw() -> void:
	if ProjectSettings.get_setting("luzula/editor_view_margin") and Engine.editor_hint:
		var B = ProjectSettings.get_setting("display/window/size/height") - b
		var R = ProjectSettings.get_setting("display/window/size/width") - r
		draw_line(Vector2(l, t), Vector2(R, t), Color.black)
		draw_line(Vector2(l, B), Vector2(R, B), Color.black)
		draw_line(Vector2(l, t), Vector2(l, B), Color.black)
		draw_line(Vector2(R, t), Vector2(R, B), Color.black)

func add_madeleine(madeleine:String) -> void:
	madeleines.append(madeleine)
