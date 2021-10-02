extends Node
class_name Globals

enum {TEAM1 = 0, TEAM2, TEAM3, TEAM4}

static func get_team_color(team_no):
  var team_colors = [Color.aqua,
                     Color.darkcyan,
                     Color.saddlebrown,
                     Color.webpurple]
  return team_colors[team_no]
