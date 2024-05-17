extends CanvasLayer
@onready var main_menu: TextureRect = $MainMenu
@onready var salud_d: Label = $MainMenu/VBoxContainer/HBoxContainer2/SaludD
@onready var mana_d: Label = $MainMenu/VBoxContainer/HBoxContainer3/ManaD
@onready var energia_d: Label = $MainMenu/VBoxContainer/HBoxContainer4/EnergiaD
@onready var resistencia_fi_d: Label = $MainMenu/VBoxContainer/HBoxContainer5/ResistenciaFiD
@onready var armadura_d: Label = $MainMenu/VBoxContainer/HBoxContainer6/ArmaduraD
@onready var poder_magico_d: Label = $MainMenu/VBoxContainer/HBoxContainer7/PoderMagicoD
@onready var da_o_critico_d: Label = $"MainMenu/VBoxContainer/HBoxContainer8/DañoCriticoD"
@onready var precision_d: Label = $MainMenu/VBoxContainer/HBoxContainer9/PrecisionD
@onready var evasion_d: Label = $MainMenu/VBoxContainer/HBoxContainer10/EvasionD
@onready var v_ataque_d: Label = $MainMenu/VBoxContainer/HBoxContainer11/VAtaqueD
@onready var t_habilidad_d: Label = $MainMenu/VBoxContainer/HBoxContainer12/THabilidadD
@onready var robo_vida_d: Label = $MainMenu/VBoxContainer/HBoxContainer13/RoboVidaD
@onready var hubPlayer = get_parent()

func _ready():
	main_menu.visible = false

func menuVisible(condicional):
	if condicional:
		main_menu.visible = true
	else:
		main_menu.visible = false

func generarDatos():
	salud_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["maxSalud"])+" | "+str(PROPIEDADES_PLAYER.propiedadesIniciales["regeneracion de salud"])
	mana_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["maxMana"])+" | "+str(PROPIEDADES_PLAYER.propiedadesIniciales["regeneracion de mana"])
	energia_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["maxEnergia"])+" | 5"
	resistencia_fi_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["resistencia fisica"])
	armadura_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["armadura"])
	poder_magico_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["poder magico"])
	da_o_critico_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["daño critico"])
	precision_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["precision"])
	evasion_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["evasion"])
	v_ataque_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["velocidad de ataque"])
	t_habilidad_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["Tiempo de habilidad"])
	robo_vida_d.text = str(PROPIEDADES_PLAYER.propiedadesIniciales["robo de vida"])
	#print(PROPIEDADES_PLAYER.propiedadesIniciales)

func _on_xb_pressed() -> void:
	hubPlayer._on_status_b_pressed()
