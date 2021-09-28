extends Button

export var button_id = 0
signal register(button, number)

# Called when the node enters the scene tree for the first time.
func _ready():
  emit_signal("register", self, button_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
