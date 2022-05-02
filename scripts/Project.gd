extends Button

onready var content = $TextEdit
onready var tasks = $GridContainer
var new_task = load("res://scenes/Task.tscn")

func _ready():
	tasks.set_global_position(Vector2(rect_size.x, 0))
	_on_Button3_pressed()

func _on_Button_pressed():
	var inst = new_task.instance()
	tasks.add_child(inst)
	_on_Button3_pressed()
	
func save_data():
	var instanced_tasks = []
	# gather dictionaries of all tasks
	for child in tasks.get_children():
		if child.is_in_group("task"):
			var temp_dict = child.save_data()
			instanced_tasks.append(temp_dict)
	var save_dict = {
		"filename" : "project",
		"description" : content.get_text(),
		"tasks" : instanced_tasks
	}
	return save_dict

func load_data():
	pass

func _on_Button2_pressed():
	queue_free()

# make all other task container invisible
func _on_Button3_pressed():
	for project_container in get_tree().get_nodes_in_group("task_container"):
		project_container.visible = false
	$GridContainer.visible = true
