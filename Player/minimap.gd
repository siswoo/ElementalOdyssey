extends ColorRect
@export var target : NodePath
@export var camara_distancia := 20.0
@onready var player := get_node(target)
@onready var camara: Camera3D = $SubViewportContainer/SubViewport/Camera3D
@onready var coordenadas_l: Label = $CoordenadasL

var coordenadasTexto : String = ""

func _process(_delta):
	if target:
		camara.size = camara_distancia
		camara.position = Vector3(player.position.x, camara_distancia, player.position.z)

func coordenadasActualizar(coordenadasX, coordenadasY):
	coordenadas_l.text = str(coordenadasX)+" | "+str(coordenadasY)
