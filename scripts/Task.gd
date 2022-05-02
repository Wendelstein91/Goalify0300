extends Button

onready var content = $TextEdit
onready var todos = $GridContainer
var new_todo = load("res://scenes/Todo.tscn")

func _ready():
	todos.set_global_position(Vector2(2*rect_size.x, 0))
	_on_Button3_pressed()

func _on_Button_pressed():
	var inst = new_todo.instance()
	todos.add_child(inst)
	_on_Button3_pressed()
	
func save_data():
	var instanced_todos = []
	for child in todos.get_children():
		if child.is_in_group("todo"):
			var temp_dict = child.save_data()
			instanced_todos.append(temp_dict)
	var save_dict = {
		"filename" : "task",
		"description" : content.get_text(),
		"todos" : instanced_todos
	}
	return save_dict

func load_data():
	pass

func _on_Button2_pressed():
	queue_free()

func _on_Button3_pressed():
	for todo_container in get_tree().get_nodes_in_group("todo_container"):
		todo_container.visible = false
	$GridContainer.visible = true
