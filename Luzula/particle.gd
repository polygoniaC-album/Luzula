extends Particles2D

var current_madeleine:String = ""

func _ready():
	add_to_group("ui_souvenir")

func _process(_delta):
	global_position = get_global_mouse_position()

func enter_area(madeleine:String):
	emitting = true
	current_madeleine = madeleine
func exit_area(madeleine:String):
	if current_madeleine == madeleine:
		emitting = false
		current_madeleine = ""
