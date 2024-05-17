extends Node3D
var piso1 = preload("res://Scenes/cementerio1_assets/piso_1.tscn")
var desdeX = 0
var desdeZ = 0

func _ready():
	var piso1Ins
	desdeX = 0
	desdeZ = 0
	for i in 5:
		desdeX = 3*i
		for j in 8:
			desdeZ = 3*j
			piso1Ins = piso1.instantiate()
			piso1Ins.position = Vector3(desdeX, 0, desdeZ)
			add_child(piso1Ins)
			
			piso1Ins = piso1.instantiate()
			piso1Ins.transform.origin = Vector3(desdeX, 0, -desdeZ)
			add_child(piso1Ins)

			piso1Ins = piso1.instantiate()
			piso1Ins.transform.origin = Vector3(-desdeX, 0, desdeZ)
			add_child(piso1Ins)

			piso1Ins = piso1.instantiate()
			piso1Ins.transform.origin = Vector3(-desdeX, 0, -desdeZ)
			add_child(piso1Ins)
