extends StaticBody2D

func _ready():
  pass # Replace with function body.


func get_actions():
  return ["Peon", "Swordman", "Spearman", "Destroy"]

func perform_action(action, world):
  if action == "Peon":
    var peon = load("res://scenes/core/peon.tscn").instance()
    peon.position = position
    peon.position.y += 100 + randf()
    world.add_child(peon)
  if action == "Swordman":
    var swordman = load("res://scenes/core/swordman.tscn").instance()
    swordman.position = position
    swordman.position.y += 100 + randf()
    world.add_child(swordman)
  if action == "Spearman":
    var spearman = load("res://scenes/core/spearman.tscn").instance()
    spearman.position = position
    spearman.position.y += 100 + randf()
    world.add_child(spearman)
  if action == "Destroy":
    queue_free()
