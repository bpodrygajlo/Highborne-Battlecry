extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_unit = null

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _process(delta):
  var mouse_pos = get_global_mouse_position()
  var space = get_world_2d().direct_space_state

  if Input.is_action_just_released("select"):
    var result = space.intersect_point(mouse_pos, 1, [], 0x1)
    var unit = null
    if result != []:
      selected_unit = result[0]["collider"]
    else:
      selected_unit = null
  
  if Input.is_action_just_released("command"):
    if selected_unit != null:
      selected_unit.set_target(mouse_pos)
