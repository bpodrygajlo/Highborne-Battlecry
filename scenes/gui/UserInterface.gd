extends CanvasLayer
class_name UserInterface
signal perform_action(action_name)

func _ready():
# warning-ignore:return_value_discarded
  $ActionPanel.connect("perform_action", self, "receive_perform_action")

func setup_actions(action_list):
  $ActionPanel.setup(action_list)
  
func reset_actions():
  $ActionPanel.empty()

func receive_perform_action(action_name):
  emit_signal("perform_action", action_name)
