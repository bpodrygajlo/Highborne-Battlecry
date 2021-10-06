extends "res://addons/gut/test.gd"


func test_instances():
  var scenes  = ["res://scenes/core/swordman.tscn",
                 "res://scenes/core/spearman.tscn",
                 "res://scenes/core/villagermale.tscn",
                 "res://scenes/core/map.tscn",
                 "res://scenes/core/building.tscn"]
  
  for scene in scenes:
    load(scene).instance().queue_free()
  
