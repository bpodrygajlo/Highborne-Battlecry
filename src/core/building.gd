extends StaticBody2D

export var team = Globals.TEAM1

func _ready():
  pass # Replace with function body.


func get_actions():
  return ["Vill", "Swordman", "Spearman", "Destroy"]

func perform_action(action, world):
  if action == "Vill":
    var villager = load("res://scenes/core/villagermale.tscn").instance()
    villager.position = position
    villager.position.y += 100 + randf()
    world.add_child(villager)
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
