extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_unit = null
onready var gui = $CanvasLayer/HBoxContainer
onready var gui_name
var buttons = [null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
  gui.visible = false


func _process(delta):
  var mouse_pos = get_global_mouse_position()
  var space = get_world_2d().direct_space_state

  if Input.is_action_just_released("select"):
    var result = space.intersect_point(mouse_pos, 1, [], 0x1)
    var unit = null
    if result != []:
      selected_unit = result[0]["collider"]
      gui.visible = true
      gui_name.set_text(selected_unit.name)
      for i in range(3):
        buttons[i].visible = false
        
      for index in selected_unit.get_actions().size():
        buttons[index].visible = true
        buttons[index].set_text(selected_unit.get_actions()[index])
    else:
      selected_unit = null
      gui.visible = false
  
  if Input.is_action_just_released("command"):
    if selected_unit != null and selected_unit.name != "building":
      selected_unit.set_target(mouse_pos)

func _on_NameDisplay_register(label):
  gui_name = label

func _on_Button_register(button, number):
  buttons[number] = button


func _on_Button_pressed(number):
  if selected_unit:
    selected_unit.perform_action(selected_unit.get_actions()[number], $YSort)
