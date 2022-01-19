extends TextureButton

const COCHE_PAS:float = - TAU / 20

var madeleines = []
var coche = {
	true : load("res://Luzula/img/coche_1.png"),
	false : load("res://Luzula/img/coche_0.png"),
}

func _ready() -> void:
	texture_disabled = load("res://Luzula/img/cercle.png")
	mouse_filter = Control.MOUSE_FILTER_PASS

func _draw() -> void:
	if !disabled and global.config["aide"]:
		var r:Vector2 = texture_normal.get_size() / 2.0
		var N:int = madeleines.size()
		var alpha = - PI / 4 - COCHE_PAS * N / 2.0
		for madeleine in madeleines:
			var c:Vector2 = r
			c += (r.x - 10) * Vector2(0, 1).rotated(alpha)
			c -= Vector2(10, 10)
	#		draw_circle(c, 10, Color.black)
	#		if !global.get_madeleine_coche(madeleines[i]):
	#			draw_circle(c, 8, Color.white)
			draw_texture(coche[madeleines[madeleine]], c)
			alpha += COCHE_PAS

func set_name(value:String) -> void:
	texture_normal = load("res://scene/icon/" + value + "_normal.png")
	texture_pressed = load("res://scene/icon/" + value + "_normal.png")
	texture_hover = load("res://scene/icon/" + value + "_hover.png")
	
	var err = connect("pressed", global, "change_scene", [value, "", 1])
	if err:
		global.report_errors(value, ["pressed -> global.change_scene" + String(err)])
	
	madeleines = global.avancement[value][1]
	
	.set_name(value)
	
	update()

func update() -> void:
	disabled = !global.get_scene_coche(name)
	.update()
