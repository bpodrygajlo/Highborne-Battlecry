extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var go_to_mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


func _process(delta):
  if go_to_mouse:
    var mouse_pos = get_global_mouse_position()
    position = lerp(position, mouse_pos, delta / 3)

func _on_Area2D_mouse_exited():
  go_to_mouse = true


func _on_Area2D_mouse_entered():
  go_to_mouse = false
