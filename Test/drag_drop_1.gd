extends TextureRect

func _get_drag_data(at_position):
	var datos = {
		"nombre": "juan",
		"apellido": "maldonado",
		"self": self,
		"textura": texture
	}
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	set_drag_preview(preview)
	#texture = null
	#return preview_texture
	return datos

func _can_drop_data(_pos,data):
	#print("can..."+str(data))
	#return data is Texture2D
	return data
	
func _drop_data(_pos,data):
	#print("drop.."+str(data))
	if data is Dictionary:
		#texture = data.texture
		texture = data["self"].texture
		#data["self"].queue_free()
		data["self"].texture = null
	else:
		pass

