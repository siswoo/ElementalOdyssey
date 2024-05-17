extends CanvasLayer
@onready var main_menu: TextureRect = $MainMenu
@onready var hubPlayer = get_parent()
@onready var fuerza_skills: Node2D = $MainMenu/FuerzaSkills
@onready var fuerza_b: Button = $MainMenu/FuerzaB
@onready var magia_skills: Node2D = $MainMenu/MagiaSkills
@onready var magia_b: Button = $MainMenu/MagiaB
@onready var agilidad_skills: Node2D = $MainMenu/AgilidadSkills
@onready var agilidad_b: Button = $MainMenu/AgilidadB
#@onready var slot_skills: Node2D = $MainMenu/FuerzaSkills/SlotSkills
var slot_skills
var slot_skillsInst = preload("res://Player/slotHabilidad.tscn")
var tooltip = preload("res://Globals/tooltip.tscn")
var tooltipInst = tooltip.instantiate()
var textoTooltip = ""
var baseRutaImagen = "res://Assets/"
signal prueba(ok)
var puntosPorExperiencia = {
	1: 40*1,
	2: 50*2,
	3: 60*3,
	4: 70*4,
	5: 80*5,
	6: 90*6,
	7: 100*7,
	8: 110*8,
	9: 120*9,
	10: 999999999,
}

func _ready():
	main_menu.visible = false
	fuerza_skills.visible = false
	magia_skills.visible = false
	agilidad_skills.visible = false
	#main_menu.add_child(tooltipInst)
	add_child(tooltipInst)

func menuVisible(condicional):
	if condicional:
		main_menu.visible = true
	else:
		main_menu.visible = false

func _on_xb_pressed() -> void:
	hubPlayer._on_skiles_b_pressed()

# FUERZA
func _on_fuerza_b_pressed() -> void:
	if fuerza_skills.visible == true:
		fuerza_skills.visible = false
	else:
		fuerza_skills.visible = true
		magia_skills.visible = false
		agilidad_skills.visible = false
func _on_fuerza_b_mouse_entered() -> void:
	textoTooltip = "La fuerza aumenta el poder físico, la regeneración y salud máxima del jugador"
	tooltipInst.mostrarOcultar(true,textoTooltip)
func _on_fuerza_b_mouse_exited() -> void:
	tooltipInst.mostrarOcultar(false)
####################################

# MAGIA
func _on_magia_b_pressed() -> void:
	if magia_skills.visible == true:
		magia_skills.visible = false
	else:
		magia_skills.visible = true
		fuerza_skills.visible = false
		agilidad_skills.visible = false
func _on_magia_b_mouse_entered() -> void:
	textoTooltip = "La magia aumenta el poder magico, regeneración y mana máxima del jugador"
	tooltipInst.mostrarOcultar(true,textoTooltip)
func _on_magia_b_mouse_exited() -> void:
	tooltipInst.mostrarOcultar(false)
####################################	

# AGILIDAD
func _on_agilidad_b_pressed() -> void:
	if agilidad_skills.visible == true:
		agilidad_skills.visible = false
	else:
		fuerza_skills.visible = false
		magia_skills.visible = false
		agilidad_skills.visible = true
func _on_agilidad_b_mouse_entered() -> void:
	textoTooltip = "La agilidad aumenta el daño critico y la energia máxima del jugador"
	tooltipInst.mostrarOcultar(true,textoTooltip)
func _on_agilidad_b_mouse_exited() -> void:
	tooltipInst.mostrarOcultar(false)
####################################

func _make_custom_tooltip(for_text):
	var label = Label.new()
	label.text = for_text
	return label

# Skill Fuerzas
func _on_icono_habilidad_1_mouse_entered() -> void:
	tooltipInst.mostrarOcultar(true,"[b]Tajo:[/b] "+str(FUENTES.obtenerFuente('+10% Daño de arma','amarillo1'))+str(FUENTES.obtenerFuente(' +5% poder físico','rojo1')))
func _on_icono_habilidad_1_mouse_exited() -> void:
	#tooltipInst.mostrarOcultar(false)
	pass

func entrarMouseHabilidad(texto,experiencia):
	texto += "[p] [experiencia = "+str(experiencia)+" ]"
	tooltipInst.mostrarOcultar(true,texto)

func salirMouseHabilidad():
	tooltipInst.mostrarOcultar(false)

func organizarHabilidades(habilidades):
	#Limpiar Reinicio
	var HijosFuerza = fuerza_skills.get_children()
	var HijosMagia = magia_skills.get_children()
	var HijosAgilidad = agilidad_skills.get_children()
	for child in HijosFuerza:
		fuerza_skills.remove_child(child)
	for child in HijosMagia:
		magia_skills.remove_child(child)
	for child in HijosAgilidad:
		agilidad_skills.remove_child(child)
	#################################
	var fuerzaC = 0
	var magiaC = 0
	var agilidadC = 0
	var nodo_original
	var skills = ""
	var posiciones1 = Vector2(380,207)
	for clave in habilidades.keys():
		var valor = habilidades[clave]
		var experienciaActual = valor["datos"]["experiencia"]
		var nivelActual = valor["nivel"]
		if valor["rama"] == "fuerza":
			var texturaPuesta = load(baseRutaImagen+valor["datos"]["imagen"])
			if fuerzaC > 0:
				nodo_original = fuerza_skills.get_node("SlotSkills")
				skills = nodo_original.duplicate()
				fuerza_skills.add_child(skills)
				skills.position = Vector2(posiciones1.x+(120*fuerzaC),posiciones1.y)
			else:
				slot_skills = slot_skillsInst.instantiate()
				fuerza_skills.add_child(slot_skills)
				skills = fuerza_skills.get_node("SlotSkills")
			skills.get_node("IconoHabilidad1").texture  = texturaPuesta
			skills.get_node("Nivel").text = str(valor["nivel"])
			if skills.get_node("IconoHabilidad1").is_connected("mouse_entered",entrarMouseHabilidad):
				skills.get_node("IconoHabilidad1").disconnect("mouse_entered",entrarMouseHabilidad)
				skills.get_node("IconoHabilidad1").disconnect("mouse_exited",salirMouseHabilidad)
			skills.get_node("IconoHabilidad1").connect("mouse_entered",entrarMouseHabilidad.bind(valor["datos"]["descripcion"],valor["datos"]["experiencia"]))
			skills.get_node("IconoHabilidad1").connect("mouse_exited",salirMouseHabilidad)
			fuerzaC += 1
		if valor["rama"] == "magia":
			var texturaPuesta = load(baseRutaImagen+valor["datos"]["imagen"])
			if magiaC > 0:
				nodo_original = magia_skills.get_node("SlotSkills")
				skills = nodo_original.duplicate()
				magia_skills.add_child(skills)
				skills.position = Vector2(posiciones1.x+(120*magiaC),posiciones1.y)
			else:
				slot_skills = slot_skillsInst.instantiate()
				magia_skills.add_child(slot_skills)
				skills = magia_skills.get_node("SlotSkills")
			skills.get_node("IconoHabilidad1").texture  = texturaPuesta
			skills.get_node("Nivel").text = str(valor["nivel"])
			if skills.get_node("IconoHabilidad1").is_connected("mouse_entered",entrarMouseHabilidad):
				skills.get_node("IconoHabilidad1").disconnect("mouse_entered",entrarMouseHabilidad)
				skills.get_node("IconoHabilidad1").disconnect("mouse_exited",salirMouseHabilidad)
			skills.get_node("IconoHabilidad1").connect("mouse_entered",entrarMouseHabilidad.bind(valor["datos"]["descripcion"],valor["datos"]["experiencia"]))
			skills.get_node("IconoHabilidad1").connect("mouse_exited",salirMouseHabilidad)
			magiaC += 1
		if valor["rama"] == "agilidad":
			var texturaPuesta = load(baseRutaImagen+valor["datos"]["imagen"])
			if agilidadC > 0:
				nodo_original = agilidad_skills.get_node("SlotSkills")
				skills = nodo_original.duplicate()
				agilidad_skills.add_child(skills)
				skills.position = Vector2(posiciones1.x+(120*agilidadC),posiciones1.y)
			else:
				slot_skills = slot_skillsInst.instantiate()
				agilidad_skills.add_child(slot_skills)
				skills = agilidad_skills.get_node("SlotSkills")
			skills.get_node("IconoHabilidad1").texture  = texturaPuesta
			skills.get_node("Nivel").text = str(valor["nivel"])
			if skills.get_node("IconoHabilidad1").is_connected("mouse_entered",entrarMouseHabilidad):
				skills.get_node("IconoHabilidad1").disconnect("mouse_entered",entrarMouseHabilidad)
				skills.get_node("IconoHabilidad1").disconnect("mouse_exited",salirMouseHabilidad)
			skills.get_node("IconoHabilidad1").connect("mouse_entered",entrarMouseHabilidad.bind(valor["datos"]["descripcion"],valor["datos"]["experiencia"]))
			skills.get_node("IconoHabilidad1").connect("mouse_exited",salirMouseHabilidad)
			agilidadC += 1
		
		skills.get_node("Nivel").text = str(nivelActual)
		if calcularNivelHabilidad(experienciaActual,nivelActual):
			skills.get_node("Positivo").visible = true
			if skills.get_node("Positivo/Button").is_connected("pressed",subirNivel):
				skills.get_node("Positivo/Button").disconnect("pressed",subirNivel)
			else:
				skills.get_node("Positivo/Button").connect("pressed",subirNivel.bind(clave,experienciaActual,nivelActual,skills))
		else:
			skills.get_node("Positivo_disable").visible = true
		if valor["nivel"] == 1:
			skills.get_node("Negativo_disable").visible = true
		else:
			skills.get_node("Negativo").visible = true
			if skills.get_node("Negativo/Button").is_connected("pressed",subirNivel):
				skills.get_node("Negativo/Button").disconnect("pressed",bajarNivel)
			else:
				skills.get_node("Negativo/Button").connect("pressed",bajarNivel.bind(clave,nivelActual,skills))

func calcularNivelHabilidad(experienciasActuales,nivel)->bool:
	if(experienciasActuales>=puntosPorExperiencia[nivel]):
		return true
	else:
		return false

func subirNivel(id,experiencia,nivelActual,nodo):
	if(experiencia>=puntosPorExperiencia[nivelActual]):
		var nivelAumentado = nivelActual + 1
		nodo.get_node("Nivel").text = str(nivelAumentado)
		PROPIEDADES_PLAYER.habilidadesIniciales[id]["nivel"]=nivelAumentado
		organizarHabilidades(PROPIEDADES_PLAYER.habilidadesIniciales)
	
func bajarNivel(id,nivelActual,nodo):
	var nivelMenos = nivelActual - 1
	nodo.get_node("Nivel").text = str(nivelMenos)
	PROPIEDADES_PLAYER.habilidadesIniciales[id]["nivel"]=nivelMenos
	organizarHabilidades(PROPIEDADES_PLAYER.habilidadesIniciales)
