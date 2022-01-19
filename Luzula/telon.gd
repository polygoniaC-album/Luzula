extends CanvasLayer

var scene_ou_aller:String = ""
var etat:int = 0
var chrono:float = 0
var temps_attente:float = 2
var temps_rideau:float = 1

var prochaine_scene = null

enum {INACTIF,
FERMETURE,
ENTRACTE,
OUVERTURE}

func _process(delta) -> void:
	match etat:
		INACTIF:
			pass
		FERMETURE:
			$ecranNoir.modulate.a += delta / temps_rideau
			if $ecranNoir.modulate.a >= 1:
				$ecranNoir.modulate.a = 1
				etat = ENTRACTE
				var path:String = "res://scene/" + scene_ou_aller + global.ext
				prochaine_scene = load(path)
				
				var ancienne_scene = global.princeps.get_node_or_null("scene")
				if ancienne_scene:
					ancienne_scene.name = "ancienne"
					ancienne_scene.queue_free()
				var nouvelle_scene = prochaine_scene.instance()
				nouvelle_scene.name = "scene"
				global.princeps.add_child(nouvelle_scene)
				global.UI.collapse()
		ENTRACTE:
			chrono -= delta
			if chrono <= 0:
				etat = OUVERTURE
		OUVERTURE:
			$ecranNoir.modulate.a -= delta / temps_rideau
			if $ecranNoir.modulate.a <= 0:
				$ecranNoir.modulate.a = 0
				$ecranNoir.visible = false
				etat = INACTIF

func _ready() -> void:
	global.telon = self

func change_scene(scene:String, texte:String = "", temps:float = temps_attente, start:bool = false) -> void:
	scene_ou_aller = scene
	$ecranNoir.visible = true
	if start:
		$ecranNoir.modulate.a = 1
	else:
		$ecranNoir.modulate.a = 0
	etat = FERMETURE
	chrono = temps
	$ecranNoir/Label.text = "..." + texte + "..."
