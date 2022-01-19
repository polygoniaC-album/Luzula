extends CanvasLayer

func _ready() -> void:
	global.UI = self
	
	find_menu_button()

func collapse():
	$Control/panneau.collapse()

func open_menu(menu:String) -> void:
	for node in $Control/panneau.get_children():
		node.visible = node.name == menu

func find_menu_button(node:Node = self) -> void:
	for child in node.get_children():
		if child is BaseButton and child.name.substr(0, 5) == "menu_":
			var err:int = child.connect("pressed", self, "open_menu", [child.name])
			if err:
				global.report_errors("UI", [child.name + '.pressed -> open_menu'])
		find_menu_button(child)

func update_button():
	$Control/panneau/menu_scene.update_button()
