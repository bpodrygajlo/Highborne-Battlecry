extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_unit = null
var gui = null

# Called when the node enters the scene tree for the first time.
func _ready():
  gui = load("res://scenes/gui/UserInterface.tscn").instance()
  gui.connect("perform_action", self, "receive_perform_action")
  add_child(gui)


func _process(_delta):
  var mouse_pos = get_global_mouse_position()
  var space = get_world_2d().direct_space_state

  if Input.is_action_just_released("select"):
    var result = space.intersect_point(mouse_pos, 1, [], 0x1)
    if result != []:
      selected_unit = result[0]["collider"]
      gui.setup_actions(selected_unit.get_actions())
    else:
      selected_unit = null
  
  if Input.is_action_just_released("command"):
    if selected_unit != null and selected_unit.name != "building":
      selected_unit.set_target(mouse_pos)


func receive_perform_action(action_name):
  if selected_unit != null:
    selected_unit.perform_action(action_name, $YSort)
