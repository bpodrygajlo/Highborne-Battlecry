extends StaticBody2D

func _ready():
  pass # Replace with function body.


func get_actions():
  return ["Peon", "Destroy"]

func perform_action(action, world):
  if action == "Peon":
    var peon = load("res://peon.tscn").instance()
    peon.position = position
    peon.position.y += 100
    world.add_child(peon)
  if action == "Destroy":
    queue_free()
