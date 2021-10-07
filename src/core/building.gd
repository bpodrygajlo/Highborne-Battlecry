extends StaticBody2D

signal died(building)

export var team = Globals.TEAM1


var actions = [Action.new(Action.CREATE_SWORDMAN),
               Action.new(Action.CREATE_SPEARMAN),
               Action.new(Action.CREATE_VILLAGER),
               Action.new(Action.DIE)]

func get_actions():
  return actions

func perform_action(action_id, world, _target):
  match action_id:
    Action.CREATE_VILLAGER:
      var villager = load("res://scenes/core/villagermale.tscn").instance()
      villager.position = position
      villager.position.y += 100 + randf()
      world.add_child(villager)
    Action.CREATE_SWORDMAN:
      var swordman = load("res://scenes/core/swordman.tscn").instance()
      swordman.position = position
      swordman.position.y += 100 + randf()
      world.add_child(swordman)
    Action.CREATE_SPEARMAN:
      var spearman = load("res://scenes/core/spearman.tscn").instance()
      spearman.position = position
      spearman.position.y += 100 + randf()
      world.add_child(spearman)
    Action.DIE:
      emit_signal("died", self)
      queue_free()
    _:
      pass

func set_selected(_is_selected : bool) -> void:
  pass
