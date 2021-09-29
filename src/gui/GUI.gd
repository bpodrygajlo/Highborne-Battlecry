extends CanvasLayer



func _on_SPLabel_pressed():
# warning-ignore:return_value_discarded
  get_tree().change_scene("res://scenes/core/map.tscn")
