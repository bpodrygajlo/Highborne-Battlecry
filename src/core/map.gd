extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_unit = null
var gui : UserInterface = null
var team = Globals.TEAM1

# Called when the node enters the scene tree for the first time.
func _ready():
  gui = load("res://scenes/gui/UserInterface.tscn").instance()
# warning-ignore:return_value_discarded
  gui.connect("perform_action", self, "receive_perform_action")
  add_child(gui)


func _process(_delta):
  if Input.is_action_just_pressed("ui_page_down"):
    team = (team + 1) % 4
    selected_unit = null
  if Input.is_action_just_pressed("ui_page_up"):
    team = (team - 1) % 4
    selected_unit = null

  if Input.is_action_just_released("select"):
    var result = get_unit_or_position_under_cursor(false)
    if typeof(result) == TYPE_VECTOR2:
      selected_unit = null
      gui.reset_actions()
    else:
      selected_unit = result
      gui.setup_actions(selected_unit.get_actions())
  
  if Input.is_action_just_released("command"):
    if selected_unit != null and selected_unit.name != "building":
      var result = get_unit_or_position_under_cursor(true)
      selected_unit.set_target(result)

func get_unit_or_position_under_cursor(any_team : bool):
  var mouse_pos = get_global_mouse_position()
  var space = get_world_2d().direct_space_state
  var team_filter = ~(1 << team) if any_team else 1 << team
  var result = space.intersect_point(mouse_pos, 1, [selected_unit], team_filter)
  if result != []:
    return result[0]["collider"]
  else:
    return mouse_pos

func receive_perform_action(action_name):
  if selected_unit != null:
    selected_unit.perform_action(action_name, $YSort)

