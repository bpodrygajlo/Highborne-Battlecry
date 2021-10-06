extends Node2D
# This map node implements all user interactions with the game world

# Unit selected by the player
var selected_units = [] setget set_selected_units, get_selected_units
var selected_units_to_remove = []

# this is the UI that is displayed over the map
var gui : UserInterface = null
var camera : Camera2D = null
# player team
var team = Globals.TEAM1

onready var selection_box = $SelectionBox

var selected_action : Action = null

func _ready():
  # Create the gui and connect it to the map
  gui = load("res://scenes/gui/UserInterface.tscn").instance()
# warning-ignore:return_value_discarded
  gui.connect("perform_action", self, "receive_perform_action")
  add_child(gui)
  camera = load("res://scenes/gui/Camera2D.tscn").instance()
  add_child(camera)
  set_camera_limits()

func set_camera_limits():
  var map_limits = $TileMap.get_used_rect()
  var map_cellsize = $TileMap.cell_size
  camera.limit_left = map_limits.position.x * map_cellsize.x
  camera.limit_right = map_limits.end.x * map_cellsize.x
  camera.limit_top = map_limits.position.y * map_cellsize.y
  camera.limit_bottom = map_limits.end.y * map_cellsize.y


func _process(delta):
  if gui_need_update():
    update_gui()
    
  # player team switching
  if Input.is_action_just_pressed("ui_page_down"):
    team = (team + 1) % 4
    selected_units = []
  if Input.is_action_just_pressed("ui_page_up"):
    team = (team - 1) % 4
    selected_units = []

  # Mouse1 is pressed, start selection
  if Input.is_action_just_pressed("select"):
    if not gui.is_mouse_on_gui():
      selection_box.start()
    
  # Mouse1 released, check what is selected
  if Input.is_action_just_released("select"):
    if not gui.is_mouse_on_gui():
      var new_selection = selection_box.get_selected_units(team)
      selection_box.reset()
      gui.reset_actions()
      set_selected_units(new_selection)
      if gui_need_update():
        update_gui()
  
  # If right mouse button pressed, perfrom command based on what is
  # under the mouse cursor
  if Input.is_action_just_released("command"):
    var mouse_pos = get_global_mouse_position()
    
    # Player has selected an action previously. Perform action on target,
    # where target depends on action target_type
    if selected_action != null:
      var target = null
      match selected_action.target_type:
        Action.TARGET_ANY:
          target = selection_box.get_unit_at(mouse_pos, 0xff)
        Action.TARGET_ENEMY:
          target = selection_box.get_unit_at(mouse_pos, ~(1 << team))
        Action.TARGET_FRIEND:
          target = selection_box.get_unit_at(mouse_pos, 1 << team)            
        Action.TARGET_POSITION:
          target = mouse_pos
        _:
          print("Action type " + str(selected_action.target_type) + " not supprted")
          assert(false)
          
      # Target selected, order units to perform action
      if target != null:
        give_order_to_all_selected_units(selected_action.id, target)
      selected_action = null
    else:
      # No action selected so we need to figure out what the player
      # ment from the context
      var target : Unit = selection_box.get_unit_at(mouse_pos, 0xff)
      if target == null:
        #No unit at mouse_pos, just move to mouse_pos
        give_order_to_all_selected_units(Action.MOVE, mouse_pos)
      else:
        if target.team == team:
          # Clicked on a unit of your own team, order the units to defend
          give_order_to_all_selected_units(Action.DEFEND, target)
        else:
          # Clicked an enemy unit. Order units to attack
          give_order_to_all_selected_units(Action.ATTACK, target)
      
  if Input.is_action_pressed("zoom_in"):
    camera.zoom = lerp(camera.zoom, Vector2(0.1, 0.1), delta)
  elif Input.is_action_pressed("zoom_out"):
    camera.zoom = lerp(camera.zoom, Vector2(5, 5), delta)

# Either order units to perform the selected action or prepare to
# select a target for the action
func receive_perform_action(action : Action):
  if action.target_type != Action.TARGET_NONE:
    selected_action = action
  else:
    give_order_to_all_selected_units(action.id, $YSort)

func give_order_to_all_selected_units(action_id : int, target = null):
  for unit in get_selected_units():
    unit.perform_action(action_id, $YSort, target)

# Helper function to update unit display
func set_selected_units(new_selection : Array) -> void:
  for unit in get_selected_units():
    unit.set_selected(false)
  selected_action = null
  selected_units = new_selection
  for unit in get_selected_units(): 
    unit.set_selected(true)
    if not unit.is_connected("died", self, "handle_selected_unit_died"):
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

var selected_units_size = 0
func gui_need_update() -> bool:
  return get_selected_units().size() != selected_units_size
  
func update_gui() -> void:
  selected_units_size = get_selected_units().size()
  if selected_units_size > 0:
    gui.setup_actions(selected_units[0].get_actions())
  else:
    gui.reset_actions()
