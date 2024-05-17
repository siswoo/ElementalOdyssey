extends StaticBody3D
class_name Npc1
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var nombre_npc: Label3D = $nombreNPC
@onready var mision_pedir: Node3D = $misionPedir
@onready var mision_entregar: Node3D = $misionEntregar
@onready var interactuar_l: Label3D = $interactuarL
@export var npcID: int = 1
@export var nombreNpc = ""
var state = "idle"
var random
var nombre
var hostil
var misiones
var vendedor
var player
var moverLabel = false
var nombre_npc_ubicacion

func _ready() -> void:
	mision_pedir.visible = false
	mision_entregar.visible = false
	animation_tree.set("parameters/initiate/transition_request", "false")
	obtenerData()
	nombre_npc_ubicacion = nombre_npc.rotation
	nombre_npc.text = nombreNpc
	nombre_npc.visible = false
	interactuar_l.visible = false

func _process(delta: float) -> void:
	delta = delta
	stateChange()
	if moverLabel:
		update_label_orientation()
	else:
		nombre_npc.visible = false
		interactuar_l.visible = false
	if mision_pedir.visible == true:
		mision_pedir.rotation.y += delta
	if mision_entregar.visible == true:
		mision_entregar.rotation.y += delta

func stateChange():
	if state == "idle":
		animation_tree.set("parameters/initiate/transition_request", "false")
	else:
		random = randi_range(1,2)
		animation_tree.set("parameters/initiate/transition_request", "true")
		if random == 1:
			animation_tree.set("parameters/talk/transition_request", "talk1")
		if random == 2:
			animation_tree.set("parameters/talk/transition_request", "talk2")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player = body
		moverLabel = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	moverLabel = false
	nombre_npc.rotation = Vector3(0,0,0)
	nombre_npc.scale = Vector3(1,1,1)

func _on_misiones_timer_timeout() -> void:
	obtenerData()

func obtenerData():
	var misionesDisponibles
	var misionesEntregables
	var datos = PROPIEDADES_PLAYER.npcList[npcID]
	var cadenaMisiones = datos["cadenaMisiones"]
	if cadenaMisiones.size() > 0:
		misionesEntregables = PROPIEDADES_PLAYER.misiones_proceso(cadenaMisiones)
		if misionesEntregables:
			mision_entregar.visible = true
		else:
			misionesDisponibles = PROPIEDADES_PLAYER.misiones_disponibles(cadenaMisiones)
			if misionesDisponibles:
				mision_pedir.visible = true
			
func update_label_orientation():
	if player != null:
		var direction_to_player = -(player.global_transform.origin - global_transform.origin).normalized()
		var look_at_transform = Transform3D().looking_at(direction_to_player, Vector3.UP)
		nombre_npc.visible = true
		interactuar_l.visible = true
		nombre_npc.global_transform.basis = look_at_transform.basis
		interactuar_l.global_transform.basis = look_at_transform.basis

func _input(event):
	event = event
	if Input.is_action_just_pressed("Interaccion") and moverLabel:
		print("ok")
