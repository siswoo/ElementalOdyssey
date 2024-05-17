extends CanvasLayer
@onready var main_menu: TextureRect = $MainMenu
@onready var bx: Button = $MainMenu/BX
@onready var hubPlayer = get_parent()
@onready var slots: Node2D = $MainMenu/Slots
var slot_opcionesInst = preload("res://Player/slot_opciones.tscn")
var slot_inventarioInst = preload("res://Player/slot_inventario.tscn")
var baseRutaImagen = "res://Assets/"
var tooltip = preload("res://Globals/tooltip.tscn")
var tooltipInst = tooltip.instantiate()
var textoTooltip = ""
var dentroButton = true
var dentroPanel = true

func _ready():
	main_menu.visible = false
	add_child(tooltipInst)

func menuVisible(condicion):
	if condicion:
		main_menu.visible = true
	else:
		main_menu.visible = false

func _on_bx_pressed() -> void:
	hubPlayer._on_inventario_b_pressed()

func generarSlots(slotInfo):
	var slot
	var posiciones = Vector2(0,0)
	var hijos = slots.get_children()
	for child in hijos:
		slots.remove_child(child)
	var inventarioEspacio = PROPIEDADES_PLAYER.inventarioPersonaje
	for i in inventarioEspacio:
		slot = slot_inventarioInst.instantiate()
		slots.add_child(slot)
		slot.posicion = i
		if i == 0 or i == 4 or i == 8:
			posiciones.x = 0
		else:
			posiciones.x += 100
		if i > 3 and i < 8:
			posiciones.y = 80
		if i > 7 and i < 12:
			posiciones.y = 160
		slot.position = Vector2(posiciones.x,posiciones.y)
		if slotInfo.has(i) and slotInfo[i] != null:
			var nombre = slotInfo[i]["info"]["nombre"]
			var descripcion = slotInfo[i]["info"]["descripción"]
			var imagen = slotInfo[i]["info"]["imagen"]
			var oro = slotInfo[i]["info"]["oro"]
			var cantidad = slotInfo[i]["cantidad"]
			var rareza = slotInfo[i]["rareza"]
			var texturaPuesta = load(baseRutaImagen+imagen)
			slot.get_node("Button/img").texture  = texturaPuesta
			slot.get_node("Button/cantidad").text  = str(cantidad)
			if slot.get_node("Button").is_connected("mouse_entered",entrarMouse):
				slot.get_node("Button").disconnect("mouse_entered",entrarMouse)
				slot.get_node("Button").disconnect("mouse_exited",salirMouseHabilidad)
			slot.get_node("Button").connect("mouse_entered",entrarMouse.bind(nombre,descripcion,oro))
			slot.get_node("Button").connect("mouse_exited",salirMouseHabilidad)
			slot.get_node("Button").connect("pressed",clickSlot.bind(slot.position,slotInfo[i],i))
		else:
			pass

func entrarMouse(nombre,descripcion,oro):
	textoTooltip = "[p][b]"+str(nombre)+"[/b][/p]"+"[p]"+str(descripcion)+"[/p]"+"[p]"
	tooltipInst.mostrarOcultar(true,textoTooltip,oro)

func salirMouseHabilidad():
	tooltipInst.mostrarOcultar(false,textoTooltip)

func clickSlot(posicion,info,slotID):
	if slots.has_node("slotOpciones"):
		var nodo_opciones = slots.get_node("slotOpciones")
		slots.remove_child(nodo_opciones)
	var slot_opciones = slot_opcionesInst.instantiate()
	slots.add_child(slot_opciones)
	slot_opciones.position = Vector2(posicion.x+50,posicion.y)
	slot_opciones.get_node("Panel").connect("mouse_entered",sensibleOpcion.bind(slot_opciones))
	slot_opciones.get_node("Panel/eliminarB").connect("pressed",eliminar.bind(slotID))
	if info["uso"]:
		slot_opciones.get_node("Panel/usarB").disabled = false
		slot_opciones.get_node("Panel/usarB").connect("pressed",usar.bind(info,slotID))
	if info["equipar"]:
		slot_opciones.get_node("Panel/equiparB").disabled = false
		slot_opciones.get_node("Panel/equiparB").connect("pressed",equipar.bind(info,slotID))

func usar(item,slotID):
	var cantidadInicial = item["cantidad"]
	PROPIEDADES_PLAYER.usarItem(item["itemID"])
	cantidadInicial -= 1
	if cantidadInicial == 0:
		eliminar(slotID)
	if cantidadInicial > 0:
		PROPIEDADES_PLAYER.inventarioIniciales[slotID]["cantidad"] = cantidadInicial
		generarSlots(PROPIEDADES_PLAYER.inventarioIniciales)

func eliminar(slotID):
	PROPIEDADES_PLAYER.inventarioIniciales.erase(slotID)
	generarSlots(PROPIEDADES_PLAYER.inventarioIniciales)

func equipar(item,slotID):
	print("Equipar Item")

func sensibleOpcion(opcion):
	if opcion.get_node("Panel").is_connected("mouse_exited",dentro):
		opcion.get_node("Panel").disconnect("mouse_entered",dentro)
		opcion.get_node("Panel").disconnect("mouse_exited",dentro)
		opcion.get_node("Panel/eliminarB").disconnect("mouse_entered",dentro)
		opcion.get_node("Panel/eliminarB").disconnect("mouse_exited",dentro)
		opcion.get_node("Panel/usarB").disconnect("mouse_entered",dentro)
		opcion.get_node("Panel/usarB").disconnect("mouse_exited",dentro)
		opcion.get_node("Panel/equiparB").disconnect("mouse_entered",dentro)
		opcion.get_node("Panel/equiparB").disconnect("mouse_exited",dentro)
	opcion.get_node("Panel").connect("mouse_entered",dentro.bind("Panel",true,opcion))
	opcion.get_node("Panel").connect("mouse_exited",dentro.bind("Panel",false,opcion))
	opcion.get_node("Panel/eliminarB").connect("mouse_entered",dentro.bind("Button",true,opcion))
	opcion.get_node("Panel/eliminarB").connect("mouse_exited",dentro.bind("Button",false,opcion))
	opcion.get_node("Panel/usarB").connect("mouse_entered",dentro.bind("Button",true,opcion))
	opcion.get_node("Panel/usarB").connect("mouse_exited",dentro.bind("Button",false,opcion))
	opcion.get_node("Panel/equiparB").connect("mouse_entered",dentro.bind("Button",true,opcion))
	opcion.get_node("Panel/equiparB").connect("mouse_exited",dentro.bind("Button",false,opcion))

func dentro(donde,condicional,opcion):
	if donde == "Button":
		dentroButton = condicional
	if donde == "Panel":
		dentroPanel = condicional
	quitarOpcion(opcion)

func quitarOpcion(opcion):
	await get_tree().create_timer(1.0).timeout
	if !dentroButton and !dentroPanel:
		if is_instance_valid(opcion):
			opcion.queue_free()
