extends CanvasLayer

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _on_SPLabel_pressed():
# warning-ignore:return_value_discarded
  get_tree().change_scene("res://scenes/core/map.tscn")
