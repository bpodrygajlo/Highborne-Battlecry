extends Node2D

var size = 30
var nav = Astar.MyNavigation.new(Vector2.ONE * size, Astar.IntVec2.new(32, 32))
var flow_field

func _ready():
  update()
  $display_flow_field.tilemap = nav.tilemap

func _process(delta):
  if Input.is_action_pressed("command"):
    flow_field = nav.get_flow_field(get_global_mouse_position())
    var point_id = nav.tilemap.get_closest_point(get_global_mouse_position())
    $display_flow_field.draw_flow_field(flow_field)
  if Input.is_action_pressed("select"):
    var point_id = nav.tilemap.get_closest_point(get_global_mouse_position())
    nav.tilemap.set_point_weight(point_id, 0)
    if flow_field != null:
      flow_field = nav.get_flow_field(flow_field.goal)
      $display_flow_field.draw_flow_field(flow_field)
    $display_flow_field.update()
  if flow_field != null:
    $Sprite.position += delta * 100 * flow_field.get_closest_vector_to($Sprite.position)

func _draw():
  draw_rect(Rect2(0, 0, size * 32, size * 32), Color.rebeccapurple, false)
