extends Node

var telon:Node
var UI:Node
var princeps:Node
var current_scene:Node

var current_scene_name:String = ""
var avancement:Dictionary = {}
var end:bool = false
#{scene : [coche, {madeleine : coche}]}

var game_name:String = ProjectSettings.get_setting("application/config/name")

var config = {
	"aide":false
}

var ext:String = ProjectSettings.get_setting("luzula/scene_extension")

func _ready() -> void:
	if charger():
		current_scene_name = ProjectSettings.get_setting("luzula/start_scene")
		init_avancement()

func report_errors(p_path:String, errors:PoolStringArray) -> void:
	var text = "Errors in file "+p_path+"\n\n"
	for e in errors:
		text += e+"\n"

	print("error is ", text)

	print_stack()
	assert(false)

func change_scene(scene:String, texte:String = "", temps:float = telon.temps_attente) -> void:
	telon.change_scene(scene, texte, temps)
	set_current_scene_name(scene)

func instance_scene(scene:String = current_scene_name) -> void:
	var scene_node = load("res://scene/" + scene + ".tscn").instance()
	princeps.add_child(scene_node)
	scene_node.name = "scene"

func set_scene_coche(scene:String, madeleines:PoolStringArray) -> void:
	if !avancement.has(scene):
		avancement[scene] = [true, {}]
	else:
		avancement[scene][0] = true
	for madeleine in madeleines:
		if !avancement[scene][1].has(madeleine):
			avancement[scene][1][madeleine] = false
	if UI:
		if scene == ProjectSettings.get_setting("luzula/end_scene"):
			UI.new_sceneButton(scene)
			end = true
		UI.update_button()
	test_end()

func get_scene_coche(scene:String) -> bool:
	return avancement[scene][0]

func set_current_scene_name(scene:String) -> void:
	current_scene_name = scene

func get_current_scene_name() -> String:
	return current_scene_name

func set_madeleine_coche(madeleine:String, scene:String = current_scene_name) -> void:
	if avancement.has(scene):
		avancement[scene][1][madeleine] = true
	else:
		report_errors("global", ["set_madeleine_coche : scene not found on avancement"])

func get_madeleine_coche(madeleine:String, scene:String = current_scene_name) -> bool:
	if avancement.has(scene):
		return avancement[scene][1][madeleine]
	else:
		return false

func init_avancement() -> void:
	avancement = {}
	var dir:Directory = Directory.new()
	if dir.open("res://scene/"):
		report_errors("globl", ["scene directory not found"])
	#warning-ignore:return_value_discarded
	dir.list_dir_begin(true, true)
	var file:String = dir.get_next()
	var end_scene:String = ProjectSettings.get_setting("luzula/end_scene")
	while file != "":
		if !dir.current_is_dir() and file.find(ext) != -1:
			file = file.get_basename()
			if file != end_scene:
				avancement[file.get_basename()] = [false, {}]
		file = dir.get_next()

func sauvegarde() -> void:
	var file:File = File.new()
	#warning-ignore:return_value_discarded
	file.open("user://" + game_name + ".luzula", File.WRITE)
	file.store_line(current_scene_name)
	file.store_line(String(end))
	var json:String = to_json(config)
	file.store_line(json)
	json = to_json(avancement)
	file.store_line(json)
	file.close()

func charger() -> int:
	var file:File = File.new()
	var err = file.open("user://" + game_name + ".luzula", File.READ)
	if !err:
		current_scene_name = file.get_line()
		end = file.get_line().to_lower() == "true"
		var json:String = file.get_line()
		config = parse_json(json)
		json = file.get_line()
		avancement = parse_json(json)
		test_end()
	return err

func test_end() -> void:
	if !end:
		for scene in avancement:
			if !avancement[scene][0]:
				return
		get_tree().call_group("madeleines", "queue_free")
		
		var madeleine_fin:Node = load("res://Luzula/madeleine.tscn").instance()
		madeleine_fin.scene = ProjectSettings.get_setting("luzula/end_scene")
		madeleine_fin.text = ProjectSettings.get_setting("luzula/end_text")
		var w:int = ProjectSettings.get_setting("display/window/size/width")
		var h:int = ProjectSettings.get_setting("display/window/size/height")
		var collisionShape2D:CollisionShape2D = CollisionShape2D.new()
		collisionShape2D.position = Vector2(w, h) / 2
		collisionShape2D.shape = RectangleShape2D.new()
		collisionShape2D.shape.extents  = Vector2(w, h) / 2
		madeleine_fin.add_child(collisionShape2D)
		current_scene.add_child(madeleine_fin)
