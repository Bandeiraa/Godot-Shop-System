extends TextureRect
class_name Slot

var is_busy: bool = false

var item_name: String 
var item_id: int
var item_price: int

func update_slot(item_dict: Dictionary) -> void:
	is_busy = true
	item_name = item_dict.Name
	item_id = int(item_dict.Id)
	item_price = int(item_dict.Price)
	var item_sprite: String = item_dict.url
	var item_image_request: HTTPRequest = HTTPRequest.new()
	add_child(item_image_request)
	var _connect = item_image_request.connect("request_completed", self, "get_data")
	var _request = item_image_request.request(item_sprite)
	
	
func get_data(_result, _response_code, _headers, body) -> void:
	var image = Image.new()
	image.load_png_from_buffer(body)
	var texture = ImageTexture.new()
	texture.create_from_image(image, 0)
	get_node("ItemIcon").texture = texture
