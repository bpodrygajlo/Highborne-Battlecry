extends Control

const icon_dir:String = "res://graphics/interface/unit stats icons/"
var stat_dict:Dictionary = {
  "attack": "Attack/slashing icon.png",
  "health": "Health/health points icon.png",
  "speed": "Speed/arcane icon.png",
  "accuracy": "Accuracy/range icon.png",
  "armor": "Armor/armor icon.png",
  "magic_resist": "Magic Resist/magic armor icon.png"
 }


func activate_unit_details(stat_list:Dictionary):
  var count = 1
  for k in stat_list.keys():
    var stat_node = get_node("HBoxContainer/VBoxContainer/StatBox" + (count as String))
    var dict_entry = stat_dict[k].split('/')
    stat_node.get_node("StatIcon").texture = load(icon_dir + dict_entry[1])
    stat_node.get_node("StatLabel").text = dict_entry[0] + ": " + (stat_list[k] as String)
    count += 1
  visible = true
  
func deactivate_unit_details():
  visible = false
