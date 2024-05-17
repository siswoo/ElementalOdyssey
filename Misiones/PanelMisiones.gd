extends CanvasLayer
@onready var main_menu: TextureRect = $MainMenu
var slot_misionInst = preload("res://Misiones/slot_mision.tscn")
var posicionInicial = Vector2(100,75)

func _ready():
	main_menu.visible = false

func menuVisible(condicion):
	if condicion:
		main_menu.visible = true
		listarMisiones()
	else:
		main_menu.visible = false

func listarMisiones():
	var separacionY = 110
	var listadomisiones = PROPIEDADES_PLAYER.misionesActivas
	var titulo
	var descripcion
	var recompensas
	var slots = main_menu.get_node("Slots")
	var hijos = slots.get_children()
	for child in hijos:
		slots.remove_child(child)
	for i in listadomisiones:
		recompensas = ""
		if i > 0:
			posicionInicial.y += separacionY
		var slot_mision = slot_misionInst.instantiate()
		slots.add_child(slot_mision)
		slot_mision.position = posicionInicial
		titulo = listadomisiones[i]["titulo"]
		descripcion = listadomisiones[i]["descripcion"]
		if listadomisiones[i]["experiencia"] != null:
			print(listadomisiones[i])
			recompensas += "Experiencia: "+str(listadomisiones[i]["experiencia"])+"   |   "
		if listadomisiones[i]["oro"] != null:
			recompensas += "Oro: "+str(listadomisiones[i]["oro"])+"   |   "
		if listadomisiones[i]["items"] != null:
			for j in listadomisiones[i]["items"]:
				recompensas += str(listadomisiones[i]["items"][j]["nombre"])+"   |   "
		slot_mision.generarTextos(titulo,descripcion,recompensas)
