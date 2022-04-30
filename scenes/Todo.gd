extends Button
onready var content = $TextEdit
onready var tasks = $GridContainer

func _ready():
	pass

func save_data():
	var save_dict = {
		"filename" : "todo",
		"description" : content.get_text()
	}
	return save_dict

func load_data():
	pass

func _on_Button2_pressed():
	queue_free()
