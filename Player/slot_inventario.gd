extends TextureRect
@export var posicion: int = 0
var baseRutaImagen = "res://Assets/"

func _get_drag_data(at_position):
	at_position = at_position
	if !PROPIEDADES_PLAYER.inventarioIniciales.has(posicion):
		return false
	var item = PROPIEDADES_PLAYER.inventarioIniciales[posicion]
	var preview_texture = TextureRect.new()
	preview_texture.texture = get_node("Button/img").texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	var retornar = {
		"entradaPos": posicion,
		"self": self,
	}
	return retornar

func _can_drop_data(_pos,data):
	#print("can..."+str(data))
	#return data is Texture2D
	return data
	
func _drop_data(_pos,data):
	#var dataImagen = data["item"]["info"]["imagen"]
	if data is Dictionary:
		intercambio(data,self)
		
func intercambio(entranteIns,casillaIns):
	PROPIEDADES_PLAYER.intercambio(entranteIns,casillaIns)
	self.get_parent().get_parent().get_parent().generarSlots(PROPIEDADES_PLAYER.inventarioIniciales)

