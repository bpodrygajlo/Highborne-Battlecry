extends Camera2D
# A camera that moves when mouse enters areas near screen edge.
# Realized using Area2Ds that move with the camera

var go_to_mouse = false

func _ready():
  var err = OK
  err |= $ScrollDownArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  err |= $ScrollDownArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  err |= $ScrollUpArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  err |= $ScrollUpArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  err |= $ScrollLeftArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  err |= $ScrollLeftArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  err |= $ScrollRightArea.connect("mouse_entered", self, "_on_ScrollArea_mouse_entered")
  err |= $ScrollRightArea.connect("mouse_exited", self, "_on_ScrollArea_mouse_exited")
  if err != OK:
    print("Camera cannot connect to scroll areas")


func _process(delta):
  if go_to_mouse:
    var mouse_pos = get_global_mouse_position()
    position = lerp(position, mouse_pos, delta)

func _on_ScrollArea_mouse_entered():
  go_to_mouse = true

func _on_ScrollArea_mouse_exited():
  go_to_mouse = false
