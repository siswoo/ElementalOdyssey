extends Node
var propiedadesIniciales = {}
var habilidadesIniciales = {}
var inventarioIniciales = {}
var inventarioPersonaje = 0
var equipamentoJugador = {}
var itemsUsables = {}
var misionesActivas = {}
var misiones = {}
var npcList = {}
var misionesHechas = {}
var muerto = false

func _ready()->void:
	inventarioPersonaje = 8
	
	equipamentoJugador = {
		# Equipamento y Arma
		"casco": {
			"itemID": 21,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"pechera": {
			"itemID": 31,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"guantes": {
			"itemID": 41,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"pantalones": {
			"itemID": 51,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"botas": {
			"itemID": 61,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"manoPrincipal": {
			"itemID": 71,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
		"manoSecundaria": {
			"itemID": 81,
			"rareza": 1,
			"nivel": 1,
			"durabilidad": 40,
		},
	}
	
	propiedadesIniciales = {
		# Base
		"playerID": 1,
		"puntosHabilidades": 0,
		"nivel": 1,
		"nombre": "Dolar",
		"ubicacionX": 10.0,
		"ubicacionY": 0.7,
		"ubicacionZ": 10.0,
		"salud": 80,
		"mana": 30,
		"energia": 5,
		"experiencia": 0,
		# Estatus Subidas
		"maxSalud": 120,
		"maxMana": 40,
		"maxEnergia": 20,
		"poder fisico": 0,
		"poder magico": 0,
		"daño critico": 5,
		# Resultado del calculo de equipamento
		"resistencia fisica": 5,
		"armadura": 3,
		"precision": 1,
		"evasion": 1,
		"velocidad de movimiento": 1,
		"velocidad de ataque": 5,
		"Tiempo de habilidad": 1,
		"robo de vida": 0,
		"regeneracion de salud": 3,
		"regeneracion de mana": 1,
	}
	
	habilidadesIniciales = {
		1: {
			"rama": "fuerza",
			"datos": {
				"nombre": "Tajo",
				"dañoPuro": 0,
				"dañoArma": 10,
				"poderFisico": 5,
				"poderMagico": 0,
				"dañoFisico": 0,
				"dañoMagico": 0,
				"curaFisico": 0,
				"curaMagico": 0,
				"costeSalud": 0,
				"costeMagia": 3,
				"costeEnergia": 0,
				"tiempoRecargaOriginal": 5,
				"TiempoReduccion": 0,
				"imagen": "Icons-Warrior1/Icon4.png",
				"descripcion": "[b]Tajo:[/b] "+str(FUENTES.obtenerFuente('+10% Daño de arma','amarillo1'))+str(FUENTES.obtenerFuente(' +5% poder físico','rojo1')),
				"experiencia": 41,
			},
			"nivel": 1,
		},
		11: {
			"rama": "magia",
			"datos": {
				"nombre": "Ignición",
				"dañoPuro": 0,
				"dañoArma": 0,
				"poderFisico": 0,
				"poderMagico": 0,
				"dañoFisico": 0,
				"dañoMagico": 15,
				"curaFisico": 0,
				"curaMagico": 0,
				"costeSalud": 0,
				"costeMagia": 3,
				"costeEnergia": 0,
				"tiempoRecargaOriginal": 5,
				"TiempoReduccion": 0,
				"imagen": "SkillsMagicBuff/Spells/fire_spell.png",
				"descripcion": "[b]Ignición:[/b] "+" llama dañina "+str(FUENTES.obtenerFuente('15 Daño mágico','azul1')),
				"experiencia": 0,
			},
			"nivel": 1,
		},
		21: {
			"rama": "agilidad",
			"datos": {
				"nombre": "Punta Afilada",
				"dañoPuro": 0,
				"dañoArma": 200,
				"poderFisico": 0,
				"poderMagico": 0,
				"dañoFisico": 0,
				"dañoMagico": 0,
				"curaFisico": 0,
				"curaMagico": 0,
				"costeSalud": 0,
				"costeMagia": 0,
				"costeEnergia": 5,
				"tiempoRecargaOriginal": 2,
				"TiempoReduccion": 0,
				"imagen": "Icons-Warrior1/Icon13.png",
				"descripcion": "[b]Punta Afilada:[/b] "+" Daño punzante "+str(FUENTES.obtenerFuente('+30% Daño de arma','amarillo1'))+str(FUENTES.obtenerFuente(' +10 Daño físico','rojo1')),
				"experiencia": 0,
			},
			"nivel": 1,
		},
		2: {
			"rama": "fuerza",
			"datos": {
				"nombre": "Cuchilla Doble",
				"dañoPuro": 0,
				"dañoArma": 200,
				"poderFisico": 0,
				"poderMagico": 0,
				"dañoFisico": 0,
				"dañoMagico": 0,
				"curaFisico": 0,
				"curaMagico": 0,
				"costeSalud": 0,
				"costeMagia": 3,
				"costeEnergia": 0,
				"tiempoRecargaOriginal": 5,
				"TiempoReduccion": 0,
				"imagen": "Icons-Warrior1/Icon33.png",
				"descripcion": "[b]Cuchilla Doble:[/b] "+" Doble cortada genera "+str(FUENTES.obtenerFuente('200% Daño de arma','amarillo1')),
				"experiencia": 0,
			},
			"nivel": 1,
		},
	}
	
	inventarioIniciales = {
		1: {
			"itemID" = 1,
			"info" = {
				"nombre" = "Calavera",
				"descripción" = "Una calavera algo extraña, que miedo",
				"imagen" = "free-undead-loot/Icon1.png",
				"oro" = "5"
			},
			"cantidad" = 8,
			"rareza" = 1,
			"uso" = false,
			"equipar" = false,
			"stackMaximo" = 10
		},
		3: {
			"itemID" = 1,
			"info" = {
				"nombre" = "Calavera",
				"descripción" = "Una calavera algo extraña, que miedo",
				"imagen" = "free-undead-loot/Icon1.png",
				"oro" = "5"
			},
			"cantidad" = 8,
			"rareza" = 1,
			"uso" = false,
			"equipar" = false,
			"stackMaximo" = 10
		},
		4: {
			"itemID" = 2,
			"info" = {
				"nombre" = "hueso",
				"descripción" = "Hueso común y corriente",
				"imagen" = "free-undead-loot/Icon2.png",
				"oro" = "2"
			},
			"cantidad" = 1,
			"rareza" = 1,
			"uso" = false,
			"equipar" = false,
			"stackMaximo" = 10
		}
	}
	
	itemsUsables = {
		1: {
			"salud" = 500,
			"mana" = 0,
			"energia" = 0
		},
		11: {
			"salud" = 5,
			"mana" = 0,
			"energia" = 0
		},
		12: {
			"salud" = 0,
			"mana" = 5,
			"energia" = 0
		},
		13: {
			"salud" = 0,
			"mana" = 0,
			"energia" = 5
		}
	}
	
	misiones = {
		1: {
			"titulo" = "La Bienvenida",
			"descripcion" = "Hola viajero! un gusto conocerte mi nombre es Lyra, para iniciar tu aventura deberias hablar con Nova la cantinera... ella esta atendiendo en el Bar Local",
			"NpcInicio" = "Lyra",
			"NpcInicioID" = 1,
			"NpcFin" = "Nova",
			"NpcFinID" = 2,
			"experiencia" = 6,
			"oro" = 0,
			"items" = {},
			"misionRequeridas" = {},
			"nivelMinimo" = 1,
			"nivelMaximo" = 99,
			"repetible" = false,
			"itemsRequeridos" = {
				0: {
					"itemID" = 1,
					"cantidad" = 3,
				},
			},
		},
	}
	
	misionesActivas = {
		0: {
			"misionID" = 1,
			"titulo" = "La Bienvenida",
			"descripcion" = "Hola viajero! un gusto conocerte mi nombre es Lyra, para iniciar tu aventura deberias hablar con Nova la cantinera... ella esta atendiendo en el Bar Local",
			"experiencia" = 20,
			"oro" = 2,
			"items" = {
				0: {
					"itemID" = 1,
					"nombre" = "Espada Tusna",	
				},
			}
		}
	}
	
	misionesHechas = {
		0: {
			"misionID" = 2
		}
	}
	
	npcList = {
		1: {
			"nombre" = "Lyra",
			"nivelFijo" = 1,
			"nivelMinimo" = 0,
			"nivelMaximo" = 0,
			"vendedor" = true,
			"misiones" = true,
			"hostil" = false,
			"cadenaMisiones" = {
				0:{
					"misionID" = 1,
				},
			}
		},
		2: {
			"nombre" = "Nova",
			"nivelFijo" = 5,
			"nivelMinimo" = 0,
			"nivelMaximo" = 0,
			"vendedor" = true,
			"misiones" = true,
			"hostil" = false,
			"cadenaMisiones" = {}
		}
	}

func propiedadesBase():
	# AQUI va la consulta a BD
	return propiedadesIniciales

func estadisticas(_propiedades):
	pass

func salud(saludBase):
	var maximo = propiedadesIniciales["maxSalud"]
	if saludBase >= maximo:
		saludBase = maximo
	propiedadesIniciales["salud"] = saludBase

func mana(manaBase):
	var maximo = propiedadesIniciales["maxMana"]
	if manaBase >= maximo:
		manaBase = maximo
	propiedadesIniciales["mana"] = manaBase

func energia(energiaBase):
	var maximo = propiedadesIniciales["maxEnergia"]
	if energiaBase >= maximo:
		energiaBase = maximo
	propiedadesIniciales["energia"] = energiaBase

func habilidades():
	return habilidadesIniciales

func slotsInventario():
	return inventarioIniciales

func usarItem(itemID):
	var item = itemsUsables[itemID]
	if item.salud > 0:
		propiedadesIniciales.salud += item.salud
		if propiedadesIniciales.salud > propiedadesIniciales.maxSalud:
			propiedadesIniciales.salud = propiedadesIniciales.maxSalud
	if item.mana > 0:
		propiedadesIniciales.mana += item.mana
		if propiedadesIniciales.mana > propiedadesIniciales.maxMana:
			propiedadesIniciales.mana = propiedadesIniciales.maxMana
	if item.energia > 0:
		propiedadesIniciales.energia += item.energia
		if propiedadesIniciales.energia > propiedadesIniciales.maxEnergia:
			propiedadesIniciales.energia = propiedadesIniciales.maxEnergia

func intercambio(entranteIns,casillaIns):
	var entrante = inventarioIniciales[entranteIns["self"].posicion]
	if inventarioIniciales.has(casillaIns.posicion):
		if entranteIns["entradaPos"] == casillaIns.posicion:
			return false
		var casilla = inventarioIniciales[casillaIns.posicion]
		if entrante["itemID"] == casilla["itemID"]:
			var stackMaximo = casilla["stackMaximo"]
			var sumaCantidad = entrante["cantidad"]+casilla["cantidad"]
			if sumaCantidad > stackMaximo:
				var restante = sumaCantidad - stackMaximo
				inventarioIniciales[entranteIns["self"].posicion]["cantidad"] = restante
				inventarioIniciales[casillaIns.posicion]["cantidad"] = stackMaximo
			else:
				if inventarioIniciales.has(casillaIns.posicion) and inventarioIniciales.has(entrante):
					inventarioIniciales.erase(entranteIns["self"].posicion)
					inventarioIniciales[casillaIns.posicion]["cantidad"] += entrante["cantidad"]
		else:
			inventarioIniciales.erase(entranteIns["self"].posicion)
			inventarioIniciales.erase(casillaIns.posicion)
			inventarioIniciales[entranteIns["self"].posicion] = casilla
			inventarioIniciales[casillaIns.posicion] = entrante
	else:
		inventarioIniciales[casillaIns.posicion] = entrante
		inventarioIniciales.erase(entranteIns["self"].posicion)

func misiones_proceso(cadenaMisiones):
	for i in cadenaMisiones:
		var sePuede = validarMisionProceso(cadenaMisiones[i]["misionID"])
		return sePuede

func validarMisionProceso(misionID):
	for i in misionesActivas:
		if misionesActivas[i]["misionID"] == misionID:
			var info = misiones[misionID]
			var itemsRequeridos = info["itemsRequeridos"]
			var itemID
			var cantidad
			var cantidadTotal = {}
			var cantidadTotalRequerido = {}
			var contador = 0
			if itemsRequeridos.size() > 0:
				var validarCantidades = true
				for j in itemsRequeridos:
					itemID = itemsRequeridos[j]["itemID"]
					cantidad = itemsRequeridos[j]["cantidad"]
					cantidadTotal[contador] = 0
					cantidadTotalRequerido[contador] = cantidad
					for x in inventarioPersonaje:
						if inventarioIniciales.has(x):
							if inventarioIniciales[x]["itemID"] == itemID:
								cantidadTotal[contador] += inventarioIniciales[x]["cantidad"]
					contador += 1
				for z in contador:
					if cantidadTotal[z] < cantidadTotalRequerido[z]:
						validarCantidades = false
				if validarCantidades:
					return true
			else:
				return true
	return false

func misiones_disponibles(cadenaMisiones):
	for i in cadenaMisiones:
		var misionInfo = misiones[cadenaMisiones[i]["misionID"]]
		var sePuede = validarMisionPedir(cadenaMisiones[i]["misionID"])
		return sePuede

func validarMisionPedir(misionID):
	var info = misiones[misionID]
	var nivelActual = propiedadesIniciales["nivel"]
	var nivelMinimo = info["nivelMinimo"]
	var nivelMaximo = info["nivelMaximo"]
	var filtroHecho = false
	var filtroRepetible = false
	var filtroActivo = false
	var filtroNivel = false
	for j in misionesHechas:
		if misionesHechas[j]["misionID"] == misionID:
			filtroHecho = true
			if info["repetible"] == true:
				filtroRepetible = true
	for i in misionesActivas:
		if misionesActivas[i]["misionID"] == misionID:
			filtroActivo = true
	if nivelActual < nivelMinimo or nivelActual > nivelMaximo:
		filtroNivel = true
		
	if filtroActivo == true:
		return false
	if filtroHecho == true and filtroRepetible == false:
		return false
	if filtroNivel == true:
		return false
	return true
	
func dañoSalud(daño):
	var saludActual = propiedadesIniciales["salud"]
	var saludRestante = saludActual-daño
	if daño >= saludActual or saludRestante <= 0:
		muerte()
	else:
		propiedadesIniciales["salud"] = saludRestante

func muerte():
	propiedadesIniciales["salud"] = 0
