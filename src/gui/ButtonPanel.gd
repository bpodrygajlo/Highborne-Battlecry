extends Panel
# a simple panel with a button in the center

var action : Action = null setget set_action

signal perform_action(action)

# recieve button press and emit action signal
func _on_Button_pressed():
  emit_signal("perform_action", action)

func set_action(new_action : Action):
  action = new_action
  $CenterContainer/Button.text = Action.action_to_string(action.id)
