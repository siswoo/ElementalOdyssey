extends NinePatchRect
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: RichTextLabel = $Label
@onready var oroL: Label = $oro
@onready var moneda_img: TextureRect = $monedaImg

func _ready():
	texture_rect.visible = false
	label.visible = false
	oroL.visible = false
	moneda_img.visible = false

func mostrarOcultar(condicional,texto: String = "",oro = null):
	if condicional:
		$TextureRect.visible = true
		$Label.visible = true
		$Label.text = str(texto)
		if oro != null:
			oroL.visible = true
			oroL.text = str(oro)
			moneda_img.visible = true
		else:
			oroL.visible = false
			moneda_img.visible = false
	else:
		$TextureRect.visible = false
		$Label.visible = false
		$Label.text = ""
		oroL.visible = false
		moneda_img.visible = false
	
