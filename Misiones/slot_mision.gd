extends ScrollContainer
@onready var titulo: Label = $VBoxContainer/Panel/titulo
@onready var descripcion: Label = $VBoxContainer/Panel/descripcion
@onready var recompensas: RichTextLabel = $VBoxContainer/Panel/recompensas

func generarTextos(t,d,r):
	titulo.text = str(t)
	descripcion.text = str(d)
	recompensas.text = str(r)
