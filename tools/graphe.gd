extends Node2D

var S = PoolVector2Array()
var vertices = []
var matrice
var matrice_prox
var V = []
const N = 31
var D = 200
var cf = 1
var coef_fro = 5

var dix = 10
var diy = 10

func _ready():
	var resver = load('res://tools/verticeGraphe.tscn')
	for n in range(N):
		S.append(init_coord(n))
		V.append(Vector2.ZERO)
		var instance = resver.instance()
		instance.set_text_n(n + 1)
		add_child(instance)
		vertices.append(instance)
	matrice_prox = import_csv()
	matrice = matrice_prox.duplicate()
	for i in range(N):
		for j in range(N):
			matrice[i][j] = max(matrice_prox[i][j], matrice_prox[j][i])
	for i in range(N):
		for j in range(N):
			match matrice[i][j]:
				0:
					matrice[i][j] = 3
				1:
					matrice[i][j] = 1

func init_coord(n:int):
	var R = Vector2(700, 500)
	var x = 1920.0 / 2.0 + R.x * cos(TAU * n / 31)
	var y = 1080.0 / 2.0 + R.y * sin(TAU * n / 31)
	return Vector2(x, y)

func import_csv():
	var res = []
	var file:File = File.new()
	file.open("res://tools/connexion.csv", File.READ)
	var line:String = file.get_line()
	while !file.eof_reached():
		var lineArray = line.split(',')
		var lineArray2 = []
		for i in range(lineArray.size()):
			lineArray2.append(int(lineArray[i]))
		res.append(lineArray2)
		line = file.get_line()
	return res

func _process(delta):
	var F = []
	var c = Vector2(960, 540)
	for i in range(N):
		var f = Vector2.ZERO
		for j in range(N):
			if i == j:
				continue
			elif matrice[i][j] != 0:
				var v = S[j] - S[i]
				var n = v.normalized()
				f += v - n * matrice[i][j] * D
		f -= coef_fro * V[i]
		F.append(f)
	for i in range(N):
		if vertices[i].dnd:
			S[i] = vertices[i].position
		else:
			V[i] += F[i] * cf * delta
			S[i] += V[i] * delta
			vertices[i].position = S[i]
	update()

func _draw():
	for i in range(N):
		for j in range(i):
			if matrice[i][j] == 1:
				draw_line(S[i], S[j], Color.black)
