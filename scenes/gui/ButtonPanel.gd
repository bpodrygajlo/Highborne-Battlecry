extends Panel

var action = "" setget set_action

signal perform_action(action_name)

# recieve button presss and emit action signal
func _on_Button_pressed():
  emit_signal("perform_action", action)

func set_action(action_name):
  action = action_name
  $CenterContainer/Button.text = action_name
