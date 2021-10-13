extends Node2D

onready var nav_tile_map : NavTileMap = $NavTileMap

func _ready():
  nav_tile_map.generate_points_from_tiles()
  nav_tile_map.connect_points()

var path = null

func _draw():
  if path != null:
    draw_polyline(path, Color.blue, 3.0)

func _process(_delta):
  if Input.is_action_just_pressed("select"):
    path = nav_tile_map.get_point_path(Vector2.ZERO, get_global_mouse_position())
    print(path)
    update()
  
