extends CharacterBody3D
@onready var rango_vision: Area3D = $RangoVision
@onready var nombre_label: Label3D = $nombreLabel
@onready var barra_salud: Sprite3D = $BarraSalud
@onready var mesh: Node3D = $Skeleton_Warrior
@onready var navegacion1: NavigationAgent3D = $NavigationAgent3D
@onready var rango_ataque: Area3D = $RangoAtaque
@onready var tiempo_ataques: Timer = $tiempoAtaques
@onready var animation_tree: AnimationTree = $AnimationTree
@export var npcID = ""
@export var nombreNPC = "Huesitos"
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocidad : float = 4.0
var ataqueRango : float = 2.5
var player
var moverElementos
var velocidadMovimiento = 1.0
var jugadorPosicion
var direction
var objects_in_range = []
var objetos_rango_ataque = []
var contadorPlayers = 0
var animacionAtaque = false
var animacionGeneral = false

func ready():
	nombre_label.visible = false
	barra_salud.visible = false
	animation_tree.set("parameters/Estados/transition_request", "Pasivo")
	
func _process(_delta):
	nombre_label.text = str(nombreNPC)
	stateChange()
	contadorPlayers = 0
	if objetos_rango_ataque.size()==0 and objects_in_range.size()==0:
		velocity = Vector3(0,0,0)
	if objetos_rango_ataque.size() == 0:
		for cuerpo in objects_in_range:
			if cuerpo.is_in_group("player"):
				contadorPlayers = 1
				player = cuerpo
		if contadorPlayers > 0:
			moverElementos = true
		else:
			moverElementos = false
		if moverElementos:
			nombre_label.visible = true
			barra_salud.visible = true
			update_label_orientation()
		else:
			nombre_label.visible = false
			barra_salud.visible = false
		pass
	
func _physics_process(_delta):
	if not is_on_floor():
		velocity.y -= gravity * _delta
		move_and_slide()

func stateChange():
	if animacionAtaque or animacionGeneral:
		return false
	var input_dir = velocity
	if input_dir.x == 0:
		animation_tree.set("parameters/Estados/transition_request", "Pasivo")
	if input_dir.x != 0 or input_dir.z != 0:
		animation_tree.set("parameters/Estados/transition_request", "Violento")
		animation_tree.set("parameters/Acciones/transition_request", "Seguir")

func _on_rango_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if objects_in_range.find(body) != 0:
			objects_in_range.append(body)
	
func _on_rango_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if objects_in_range.find(body) == 0:
			objects_in_range.erase(body)

func update_label_orientation():
	if player != null:
		var direction_to_player = -(player.global_transform.origin - global_transform.origin).normalized()
		var look_at_transform_player = Transform3D().looking_at(direction_to_player, Vector3.UP)
		var direction_to_camera = -(player.camera_3d.global_transform.origin - global_transform.origin).normalized()
		var look_at_transform_camera = Transform3D().looking_at(direction_to_camera, Vector3.UP)
		nombre_label.global_transform.basis = look_at_transform_camera.basis
		nombre_label.scale = Vector3(1,1,1)
		barra_salud.global_transform.basis = look_at_transform_camera.basis
		barra_salud.scale = Vector3(1,1,1)
		mesh.global_transform.basis = look_at_transform_player.basis
		mesh.scale = Vector3(1,1,1)
		
		jugadorPosicion = player.global_transform.origin
		jugadorPosicion = Vector3(jugadorPosicion.x,0,jugadorPosicion.z)
		if not navegacion1.is_navigation_finished():
			navegacion1.set_target_position(jugadorPosicion)
			var destino = navegacion1.get_next_path_position()
			var local_destino = destino - global_position
			var direccion = local_destino.normalized()
			velocity = direccion * velocidadMovimiento
			move_and_slide()
		else:
			#navegacion1.set_target_position(global_transform.origin)
			navegacion1.set_target_position(jugadorPosicion)

func _on_rango_ataque_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if objetos_rango_ataque.find(body) != 0:
			objetos_rango_ataque.append(body)
		
func _on_rango_ataque_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		if objetos_rango_ataque.find(body) == 0:
			objetos_rango_ataque.erase(body)

func _on_tiempo_ataques_timeout() -> void:
	if objetos_rango_ataque.size() > 0:
		animacionAtaque = true
		animation_tree.set("parameters/Acciones/transition_request", "Atacar")
		PROPIEDADES_PLAYER.dañoSalud(30)

func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	animacionGeneral = true

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	animacionGeneral = false
	if anim_name == "Unarmed_Melee_Attack_Punch_A":
		animacionAtaque = false

