extends Node
var generado = ""
var fuente = ""
func obtenerFuente(texto,color):
	if color == "amarillo1":
		generado = "[color=#fbf607]"+str(texto)+"[/color]"
	if color == "rojo1":
		generado = "[color=#ff515a]"+str(texto)+"[/color]"
	if color == "azul1":
		generado = "[color=#81BCFB]"+str(texto)+"[/color]"
	return generado
