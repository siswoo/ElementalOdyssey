extends Node3D
@onready var zona_1: Node = $Piso/Zona1
@onready var paredes_entorno: Node = $Estructuras/ParedesEntorno
var piso1_3D = preload("res://Assets/Villages/Tscn/piso_piedra_1.tscn")
var desdeX
var desdeZ

func _ready():
	var piso1_3DIns
	desdeX = 0
	desdeZ = 0
	for i in 7:
		desdeX = 5*i
		for j in 7:
			desdeZ = 5*j
			piso1_3DIns = piso1_3D.instantiate()
			piso1_3DIns.position = Vector3(desdeX, 0.5, desdeZ)
			piso1_3DIns.scale = Vector3(5,1,5)
			zona_1.add_child(piso1_3DIns)
			
			piso1_3DIns = piso1_3D.instantiate()
			piso1_3DIns.transform.origin = Vector3(desdeX, 0.5, -desdeZ)
			piso1_3DIns.scale = Vector3(5,1,5)
			zona_1.add_child(piso1_3DIns)

			piso1_3DIns = piso1_3D.instantiate()
			piso1_3DIns.transform.origin = Vector3(-desdeX, 0.5, desdeZ)
			piso1_3DIns.scale = Vector3(5,1,5)
			zona_1.add_child(piso1_3DIns)

			piso1_3DIns = piso1_3D.instantiate()
			piso1_3DIns.transform.origin = Vector3(-desdeX, 0.5, -desdeZ)
			piso1_3DIns.scale = Vector3(5,1,5)
			zona_1.add_child(piso1_3DIns)

