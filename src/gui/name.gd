extends Label

signal register(label)

func _ready():
  emit_signal("register", self)
