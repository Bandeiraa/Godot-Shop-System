extends Control

signal update_text

var slot_busy: bool = false
var current_slot: TextureRect

onready var slot_container: GridContainer = get_node("Container/SlotsContainer")
onready var animation: AnimationPlayer = get_node("Animation")

func _ready() -> void:
	make_request()
	mouse_signals()
	button_signals()
	
	
func make_request() -> void:
	var url_to_request: HTTPRequest = HTTPRequest.new()
	add_child(url_to_request)
	var _connect = url_to_request.connect("request_completed", self, "get_data")
	var _request = url_to_request.request("http://127.0.0.1:8080/")
	
	
func get_data(_result, _response_code, _headers, body) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	for item in json.result:
		slot_container.get_child(random_pick()).update_slot(item)
		
		
func random_pick() -> int:
	randomize()
	return randi() % slot_container.get_children().size()
	
	
func mouse_signals() -> void:
	for children in slot_container.get_children():
		children.connect("mouse_entered", self, "on_mouse_entered", [children.name])
		children.connect("mouse_exited", self, "on_mouse_exited", [children.name])
		
		
func on_mouse_entered(slot_name: String) -> void:
	current_slot = slot_container.get_node(slot_name)
	slot_busy = current_slot.is_busy
	current_slot.modulate = Color(1, 1, 1, .5)
	
	
func on_mouse_exited(slot_name: String) -> void:
	slot_busy = false
	slot_container.get_node(slot_name).modulate = Color(1, 1, 1, 1)
	
	
func button_signals() -> void:
	for button in get_tree().get_nodes_in_group("button"):
		button.connect("pressed", self, "on_button_pressed", [button.name])
		
		
func on_button_pressed(button_target: String) -> void:
	match button_target:
		"Shop":
			if slot_container.visible == true:
				animation.play("hide_shop")
			elif slot_container.visible == false:
				animation.play("show_shop")
				
				
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_click") and slot_busy != false:
		emit_signal("update_text", current_slot.item_name, str(current_slot.item_price))
