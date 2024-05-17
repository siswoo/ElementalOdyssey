extends CanvasLayer
@onready var nombre_pj: Label = $NombrePJ
@onready var nivel_pj: Label = $NivelPJ
@onready var experiencia_pj: TextureProgressBar = $ExperienciaPJ
@onready var experiencia_l: Label = $ExperienciaL
@onready var salud_b: TextureProgressBar = $SaludB
@onready var salud_l: Label = $SaludL
@onready var mana_b: TextureProgressBar = $ManaB
@onready var mana_l: Label = $ManaL
@onready var energia_b: TextureProgressBar = $EnergiaB
@onready var energia_l: Label = $EnergiaL
@onready var panel_estatus: CanvasLayer = $PanelEstatus
@onready var panel_habilidades: CanvasLayer = $PanelHabilidades
@onready var panel_inventario: CanvasLayer = $PanelInventario
@onready var panel_misiones: CanvasLayer = $PanelMisiones
var panelEstatusVisible: bool = false
var panelHabilidades: bool = false
var panelInventario: bool = false
var panelMisiones: bool = false

func iniciar(base):
	#print(base)
	nombre_pj.text = base.nombre
	nivel_pj.text = str(base.nivel)
	
	salud_b.value = base.salud
	salud_b.max_value = base.maxSalud
	salud_l.text = str(base.salud)+" / "+str(base.maxSalud)
	
	mana_b.value = base.mana
	mana_b.max_value = base.maxMana
	mana_l.text = str(base.mana)+" / "+str(base.maxMana)
	
	energia_b.value = base.energia
	energia_b.max_value = base.maxEnergia
	energia_l.text = str(base.energia)+" / "+str(base.maxEnergia)
	
	var nivelBase = base.nivel
	var experienciaPorNivel = nivelBase*75
	experiencia_pj.value = base.experiencia
	var experienciaPorcentaje = floor((base.experiencia*experienciaPorNivel)/100)
	experiencia_pj.max_value = experienciaPorNivel
	experiencia_l.text = str(base.experiencia)+" | "+str(experienciaPorNivel)+" ("+str(experienciaPorcentaje)+"%)"
	
func regeneraciones(saludBase,saludRege,manaBase,manaRege,energiaBase,energiaRege):
	saludBase += saludRege
	manaBase += manaRege
	energiaBase += energiaRege
	var regeneracionesReturn = {
		"salud" = saludBase,
		"mana" = manaBase,
		"energia" = energiaBase
	}
	return regeneracionesReturn

func _on_status_b_pressed() -> void:
	panelEstatusVisible = !panelEstatusVisible
	validarVistas("Estatus")
	panel_estatus.generarDatos()

func _on_skiles_b_pressed() -> void:
	panelHabilidades = !panelHabilidades
	validarVistas("Habilidad")
	obtenerHabilidades()

func _on_inventario_b_pressed() -> void:
	panelInventario = !panelInventario
	validarVistas("Inventario")
	generarInventario()

func _on_misiones_b_pressed() -> void:
	panelMisiones = !panelMisiones
	validarVistas("Misiones")
	generarMisiones()

func validarVistas(condicion):
	if condicion == "Estatus":
		panelHabilidades = false
		panelInventario = false
		panelMisiones = false
	if condicion == "Habilidad":
		panelEstatusVisible = false
		panelInventario = false
		panelMisiones = false
	if condicion == "Inventario":
		panelEstatusVisible = false
		panelHabilidades = false
		panelMisiones = false
	if condicion == "Misiones":
		panelEstatusVisible = false
		panelHabilidades = false
		panelInventario = false
	panel_estatus.menuVisible(panelEstatusVisible)
	panel_habilidades.menuVisible(panelHabilidades)
	panel_inventario.menuVisible(panelInventario)
	panel_inventario.menuVisible(panelInventario)
	panel_misiones.menuVisible(panelMisiones)

func obtenerHabilidades():
	var habilidades = PROPIEDADES_PLAYER.habilidades()
	panel_habilidades.organizarHabilidades(habilidades)

func generarInventario():
	var inventarioSlots = PROPIEDADES_PLAYER.slotsInventario()
	panel_inventario.generarSlots(inventarioSlots)

func generarMisiones():
	pass
