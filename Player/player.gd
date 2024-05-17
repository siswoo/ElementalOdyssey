extends CharacterBody3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
#@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_tree: AnimationTree = $AnimationTree2
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var minimap: ColorRect = $Minimap
@onready var ray_1: RayCast3D = $Ray1
@onready var propiedades_player: Node = $PropiedadesPlayer
@onready var player_hub: CanvasLayer = $Player_HUB
@onready var timer_salud_mana_energia: Timer = $TimerSaludManaEnergia
@onready var base_jugador: Node3D = $BaseJugador
@onready var loot_panel: CanvasLayer = $LootPanel
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_look_input : Vector2
var look_sensitivity : float = 0.01
var look_sensitivityY : float = 0.1
var input_dir
var jumpTime = 0
var nombre = "juan maldonado"
var tiempoCaida = 30
var posicionGlobalX : float = 0
var posicionGlobalZ : float = 0
var posicionGlobalY : float = 0
var obstacle
var salud
var saludRege
var mana
var manaRege
var energia
var energiaRege
var nivel
var regeSalud
var regeMana
var regeEnergia
var propiedadesIniciales
var mouseVisible: bool = false
var playerID = 0

func _ready():	
	# Oculta el cursor del mouse cuando el juego comienza
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	propiedadesIniciales = PROPIEDADES_PLAYER.propiedadesBase()
	#print(propiedadesIniciales)
	playerID = propiedadesIniciales["playerID"]

func _process(_delta):
	player_hub.iniciar(propiedadesIniciales)
	salud = propiedadesIniciales["salud"]
	saludRege = propiedadesIniciales["regeneracion de salud"]
	mana = propiedadesIniciales["mana"]
	manaRege = propiedadesIniciales["regeneracion de mana"]
	energia = propiedadesIniciales["energia"]
	energiaRege = 5

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("PM_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_tree.set("parameters/Movements/transition_request", "Jump")
		jumpTime = 50
	if not is_on_floor():
		tiempoCaida -= 1
		velocity.y -= gravity * delta
	if is_on_floor():
		tiempoCaida = 30
	input_dir = Input.get_vector("PM_left", "PM_right", "PM_forward", "PM_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# Detectar un posible escalon
		detectarEscalon()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	#Camera Look
	rotate_y(-camera_look_input.x * look_sensitivity)
	camera_look_input = Vector2.ZERO
	
	#Animations
	if jumpTime > 0:
		jumpTime -= 1
	else:
		if is_on_floor() and jumpTime == 0:
			animation_tree.set("parameters/in_air/transition_request", "false")
			stateChange()
		else:
			if tiempoCaida <= 0:
				animation_tree.set("parameters/in_air/transition_request", "true")
	
	# Sistema de coordenadas
	mandarCoordenadas()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if !mouseVisible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			camera_look_input = event.relative
			var vertical_movement = event.relative.y
			var rotation_change = -vertical_movement * look_sensitivityY
			var current_rotation = spring_arm_3d.rotation_degrees.x
			var new_rotation = clamp(current_rotation + rotation_change, -60, 60)
			spring_arm_3d.rotation_degrees.x = new_rotation

func _input(event):
	event = event
	# ver ocultar mouse en pantalla
	if Input.is_action_just_pressed("MouseSwitch"):
		mouseVisible = !mouseVisible
		verMouse()

func stateChange():
	if input_dir.x == 0 and input_dir.y == 0:
		animation_tree.set("parameters/Movements/transition_request", "Idle")
	if input_dir.x != 0 or input_dir.y != 0:
		animation_tree.set("parameters/Movements/transition_request", "Walk")
		if input_dir.x == 0 and input_dir.y < 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "Forward")
		elif input_dir.x > 0 and input_dir.y < 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "ForwardR")
		elif input_dir.x < 0 and input_dir.y < 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "ForwardL")
		elif input_dir.x == 0 and input_dir.y > 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "Backward")
		elif input_dir.x > 0 and input_dir.y > 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "BackwardR")
		elif input_dir.x < 0 and input_dir.y > 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "BackwardL")
		elif input_dir.x < 0 and input_dir.y == 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "Left")
		elif input_dir.x > 0 and input_dir.y == 0:
			animation_tree.set("parameters/AnimationWalk/transition_request", "Right")

func mandarCoordenadas():
	if global_position.x != posicionGlobalX || global_position.z != posicionGlobalZ:
		posicionGlobalX = int(global_position.x)
		posicionGlobalZ = int(global_position.z)
		minimap.coordenadasActualizar(posicionGlobalX,posicionGlobalZ)

func detectarEscalon():
	# Verificar si el RayCast está colisionando con un objeto
	if ray_1.is_colliding():
		obstacle = ray_1.get_collider()
		
		if obstacle.is_in_group("escalon"):
			var mesh_instance = obstacle.get_parent()
			var obstacle_height = mesh_instance.transform.origin.y
			var obstacleX = mesh_instance.transform.origin.x
			var obstacleZ = mesh_instance.transform.origin.z
			var character_position = transform.origin
			var character_height = character_position.y
			var resultadoAltura = character_height - obstacle_height
			var step_heightResultante = character_height + character_height
			
			if resultadoAltura < step_heightResultante:
				transform.origin.y = obstacle_height+0.3
				transform.origin.x = obstacleX+0.1
				transform.origin.z = obstacleZ+0.1

func _on_timer_salud_mana_energia_timeout() -> void:
	if !PROPIEDADES_PLAYER.muerto:
		var regeneracionesReturn = player_hub.regeneraciones(salud,saludRege,mana,manaRege,energia,energiaRege)
		salud = regeneracionesReturn["salud"]
		mana = regeneracionesReturn["mana"]
		energia = regeneracionesReturn["energia"]
		PROPIEDADES_PLAYER.salud(salud)
		PROPIEDADES_PLAYER.mana(mana)
		PROPIEDADES_PLAYER.energia(energia)

func verMouse():
	if mouseVisible == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

