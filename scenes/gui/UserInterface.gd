extends CanvasLayer

signal perform_action(action_name)

func _ready():
  $ActionPanel.connect("perform_action", self, "receive_perform_action")

func setup_actions(action_list):
  $ActionPanel.setup(action_list)

func receive_perform_action(action_name):
  emit_signal("perform_action", action_name)
