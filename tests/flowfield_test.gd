extends Node2D

var size = 30
var nav = Astar.MyNavigation.new(Vector2.ONE * size, Astar.IntVec2.new(32, 32))

func _ready():
  $display_flow_field.tilemap = nav.tilemap

func _process(delta):
  if Input.is_action_pressed("command"):
    var flow_field = nav.get_flow_field(get_global_mouse_position())
    $display_flow_field.draw_flow_field(flow_field)
  if Input.is_action_pressed("select"):
    nav.tilemap.set_point_weight(nav.tilemap.get_closest_point(get_global_mouse_position()), 0)
    $display_flow_field.update()
