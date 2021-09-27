extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var go_to_mouse = false

# Called when the node enters the scene tree for the first time.
func _ready():
  $ScrollDownArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  $ScrollDownArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  $ScrollUpArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  $ScrollUpArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  $ScrollLeftArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  $ScrollLeftArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  $ScrollRightArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  $ScrollRightArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")


func _process(delta):
  if go_to_mouse:
    var mouse_pos = get_global_mouse_position()
    position = lerp(position, mouse_pos, delta)

func _on_ScrollArea_mouse_entered():
  go_to_mouse = true

func _on_ScrollArea_mouse_exited():
  go_to_mouse = false
