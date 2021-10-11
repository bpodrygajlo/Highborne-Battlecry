extends Node2D

onready var nav_tile_map : NavTileMap = null

func _ready():
  nav_tile_map = get_parent().get_node("NavTileMap")
  nav_tile_map.generate_points_from_tiles()
  nav_tile_map.connect_points()
  portals = nav_tile_map.build_portals(0, 0)
  portals.append_array(nav_tile_map.build_portals(0, 1))
  portals.append_array(nav_tile_map.build_portals(1, 0))
  portals.append_array(nav_tile_map.build_portals(1, 1))
  portals.append_array(nav_tile_map.build_portals(2, 0))
  portals.append_array(nav_tile_map.build_portals(2, 1))

var path = null
var portals = null

func _draw():
  if path != null:
    draw_polyline(path, Color.blue, 10.0)
  if portals != null:
    for p in portals:
      draw_circle(p, 40, Color.rebeccapurple)
func _process(_delta):
  if Input.is_action_pressed("select"):
    path = nav_tile_map.get_point_path(Vector2.ZERO, get_global_mouse_position())
    update()
