extends Node
class_name Action


enum {NONE, STOP, MOVE, ATTACK, MOVE_AND_ATTACK, DEFEND, DIE, CHANGE_STANCE,
      STANCE_DEFENSIVE, STANCE_PASSIVE, STANCE_OFFENSIVE, CREATE_SWORDMAN,
      CREATE_VILLAGER, CREATE_SPEARMAN}
enum {TARGET_NONE, TARGET_ANY, TARGET_FRIEND, TARGET_ENEMY, TARGET_POSITION}
var id : int
var target_type : int
var sublist : Array
func _init(_id, _target_type = TARGET_NONE, _sublist = []):
  self.id = _id
  self.target_type = _target_type
  self.sublist = _sublist

# translate action_id to string
static func action_to_string(action_id : int) -> String:
  var action_to_string = { STOP: "STOP",
                           MOVE: "MOVE",
                           ATTACK: "ATTACK",
                           MOVE_AND_ATTACK: "M&A",
                           DEFEND: "DEFEND",
                           DIE: "DIE",
                           CHANGE_STANCE: "STANCE",
                           CREATE_SWORDMAN: "SWORD",
                           CREATE_VILLAGER: "VILL",
                           CREATE_SPEARMAN: "SPEAR",
                           STANCE_DEFENSIVE: "DEF",
                           STANCE_PASSIVE: "PASSIVE",
                           STANCE_OFFENSIVE: "OFF"}
  return action_to_string[action_id]
