# change test 
extends Control
var project_scene = preload("res://scenes/Project.tscn")
var task_scene = preload("res://scenes/Task.tscn")
var todo_scene = load("res://scenes/Todo.tscn")
var new_project	
var task_inst
onready var projects = $Projects
onready var cam = $Camera2D

func _input(event):
	if event.is_action_pressed("mouse_wheel_dwn"):
		cam.position.y += 100	
	if event.is_action_pressed("mouse_wheel_up"):
		cam.position.y -= 100

func _on_AddProj_pressed():
	var project
	project = project_scene.instance()
	projects.add_child(project)

func _on_Save_pressed():
	var save_game = File.new()
	save_game.open("res://save/savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("project")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save_data"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save_data")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func _on_Load_pressed():
	var save_game = File.new()
	if not save_game.file_exists("res://save/savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("project")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://save/savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
	# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		if node_data["filename"] == "project":
			new_project = project_scene.instance()
			projects.add_child(new_project)

			for i in node_data.keys():
				print(i)
				if i == "filename":
					continue
				if i == "description":
					new_project.get_node("TextEdit").set_text(node_data[i])
				if i == "tasks":
					for task_dict in node_data[i]:
						task_inst = task_scene.instance()
						task_inst.get_node("TextEdit").set_text(task_dict["description"])
						new_project.get_node("GridContainer").add_child(task_inst)
						for todo_dict in task_dict["todos"]:
							var todo_inst = todo_scene.instance()
							todo_inst.get_node("TextEdit").set_text(todo_dict["description"])
							task_inst.get_node("GridContainer").add_child(todo_inst)
						
	save_game.close()
