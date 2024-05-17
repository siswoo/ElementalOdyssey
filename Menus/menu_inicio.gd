extends CanvasLayer
@onready var titulo: Label = $titulo
@onready var inicio: Button = $inicio
@onready var opciones_panel: Panel = $OpcionesPanel
@export var escenaNueva: PackedScene

func _ready():
	opciones_panel.visible = false

func _on_inicio_pressed() -> void:
	get_tree().change_scene_to_packed(escenaNueva)

func _on_opciones_pressed() -> void:
	switchOpciones(opciones_panel.visible)

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_modo_ventana_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_cerrar_opciones_b_pressed() -> void:
	switchOpciones(opciones_panel.visible)

func switchOpciones(condicion):
	if condicion:
		opciones_panel.visible = false
	else:
		opciones_panel.visible = true
