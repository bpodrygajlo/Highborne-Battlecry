extends Node2D
# This map node implements all user interactions with the game world

# Unit selected by the player
var selected_units = [] setget set_selected_units, get_selected_units
var selected_units_to_remove = []

# this is the UI that is displayed over the map
var gui : UserInterface = null

# player team
var team = Globals.TEAM1

onready var selection_box = $SelectionBox

func _ready():
  # Create the gui and connect it to the map
  gui = load("res://scenes/gui/UserInterface.tscn").instance()
# warning-ignore:return_value_discarded
  gui.connect("perform_action", self, "receive_perform_action")
  add_child(gui)
  var camera = load("res://scenes/gui/Camera2D.tscn").instance()
  add_child(camera)


func _process(_delta):
  
  # player team switching
  if Input.is_action_just_pressed("ui_page_down"):
    team = (team + 1) % 4
    selected_units = []
  if Input.is_action_just_pressed("ui_page_up"):
    team = (team - 1) % 4
    selected_units = []

  # Mouse1 is pressed, start selection
  if Input.is_action_just_pressed("select"):
    selection_box.start()
    
  # Mouse1 released, check what is selected
  if Input.is_action_just_released("select"):
    var new_selection = selection_box.get_selected_units(team)
    selection_box.reset()
    gui.reset_actions()
    set_selected_units(new_selection)
    if selected_units.size() > 0:
      gui.setup_actions(selected_units[0].get_actions())
  
  # If right mouse button pressed, perfrom command based on what is
  # under the mouse cursor
  if Input.is_action_just_released("command"):
    for unit in get_selected_units():
      if unit.name == "building":
        continue
      var result = get_unit_or_position_under_cursor(true)
      unit.set_target(result)

# Function that returns a unit that is under the mouse cursor or 
# if there is no unit under the mouse just the mouse position
func get_unit_or_position_under_cursor(any_team : bool):
  var mouse_pos = get_global_mouse_position()
  var space = get_world_2d().direct_space_state
  var team_filter = ~(1 << team) if any_team else 1 << team
  var result = space.intersect_point(mouse_pos, 1, selected_units, team_filter)
  if result != []:
    return result[0]["collider"]
  else:
    return mouse_pos

# If gui reports action to perfrom, tell selected unit to perfrom action
func receive_perform_action(action_name):
  for unit in get_selected_units():
    unit.perform_action(action_name, $YSort)

# Helper function to update unit display
func set_selected_units(new_selection : Array) -> void:
  for unit in get_selected_units():
    unit.set_selected(false)
  selected_units = new_selection
  for unit in get_selected_units():
    unit.set_selected(true)
    unit.connect("died", self, "handle_selected_unit_died")

func handle_selected_unit_died(unit):
  selected_units_to_remove.push_back(unit)

func get_selected_units() -> Array:
  while selected_units_to_remove.size() > 0:
    var unit = selected_units_to_remove.pop_front()
    var index = selected_units.find(unit)
    if index != -1:
      selected_units.remove(index)
  return selected_units
