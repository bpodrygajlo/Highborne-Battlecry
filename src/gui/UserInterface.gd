extends CanvasLayer
class_name UserInterface
# Implement the in-game user interface

signal perform_action(action_name)

func _ready():
# warning-ignore:return_value_discarded
  $ActionPanel.connect("perform_action", self, "receive_perform_action")

# Fill action panel
func setup_actions(action_list):
  $ActionPanel.setup(action_list)

# empty action panel
func reset_actions():
  $ActionPanel.empty()

# receive perform_action signal and forward it to the listeners
func receive_perform_action(action_name):
  emit_signal("perform_action", action_name)
