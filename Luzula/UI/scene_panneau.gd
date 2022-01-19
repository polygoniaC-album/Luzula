extends Control

enum {
	ETAT_FERME,
	ETAT_OUVERT,
}

var etat_actuel:int = ETAT_FERME
var etat_cible:int = ETAT_FERME

var pos_ouvert:float = -1920.0
var pos_ferme:float = -15.0
var duration:float = 1.6

func _ready():
	var conn_err = connect("mouse_entered", self, "_on_mouse_entered")
	if conn_err:
		global.report_errors("scene_panneau", ["mouse_entered -> _on_mouse_entered error: " + String(conn_err)])
	
	conn_err = $animation.connect("tween_completed", self, "_on_tween_completed")
	if conn_err:
		global.report_errors("scene_panneau", ["animation.tween_completed -> _on_tween_completed error: " + String(conn_err)])
	
	conn_err = $fermeture.connect("pressed", self, "_on_fermeture_pressed")
	
	margin_left = pos_ferme

func _on_mouse_entered():
	etat_cible = ETAT_OUVERT
	test_etat()

func _on_mouse_exited():
	etat_cible = ETAT_FERME
	test_etat()

func _on_fermeture_pressed():
	etat_cible = ETAT_FERME
	test_etat()

func _on_tween_completed(_object:Object, _key:NodePath):
	test_etat()

func collapse():
	etat_actuel = ETAT_FERME
	etat_cible = ETAT_FERME
	margin_left = pos_ferme

func test_etat():
	if etat_actuel != etat_cible:
		interpolate(etat_cible)

func interpolate(etat:int):
	var initial_val:float
	var final_val:float
	match etat:
		ETAT_OUVERT:
			initial_val = min(pos_ferme, margin_left)
			final_val = pos_ouvert
		ETAT_FERME:
			initial_val = max(pos_ouvert, margin_left)
			final_val = pos_ferme
	etat_actuel = etat
	$animation.interpolate_property(self, "margin_left", initial_val, final_val, duration, Tween.TRANS_EXPO, Tween.EASE_OUT)

	$animation.start()
