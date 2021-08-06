extends TextureRect

onready var item_name: Label = get_node("VBox/HBox/VBox/ItemName")
onready var item_price: Label = get_node("VBox/HBox/VBox/ItemPrice")

func _ready() -> void:
	item_name.text = ""
	item_price.text = ""
	
	
func update_text(dict_name: String, dict_price: String) -> void:
	item_name.text = dict_name
	item_price.text = dict_price
