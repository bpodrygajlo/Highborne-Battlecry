extends Panel
# a simple panel with a button in the center

var action = "" setget set_action

signal perform_action(action_name)

# recieve button press and emit action signal
func _on_Button_pressed():
  emit_signal("perform_action", action)

func set_action(action_name):
  action = action_name
  $CenterContainer/Button.text = action_name
