extends Node2D

const MIN_SIZE = 30

# mouse positions for drawing selection rectangle
var start_pos = null
var end_pos = null

func is_valid():
  if start_pos == null or end_pos == null:
    return false
  return (start_pos - end_pos).length_squared() > (MIN_SIZE * MIN_SIZE)
  
func start():
  start_pos = get_global_mouse_position()

func get_width_and_height() -> Vector2:
  return (start_pos - end_pos).abs()

func get_lower_left_corner() -> Vector2:
  var min_x = start_pos.x
  if min_x > end_pos.x:
    min_x = end_pos.x

  var min_y = start_pos.y
  if min_y > end_pos.y:
    min_y = end_pos.y
  return Vector2(min_x, min_y)

func draw_selection_rectangle():    
  draw_rect(Rect2(get_lower_left_corner(),
                  get_width_and_height()),
                  Color.aquamarine, false, 3.0)

func _draw():
  if is_valid():
    draw_selection_rectangle()

func _input(event):
  if event is InputEventMouseMotion:
    if start_pos != null:
      end_pos = get_global_mouse_position()
      if is_valid():
        update()

func get_selected_units(team):
  end_pos = get_global_mouse_position()
  var select_rect : RectangleShape2D = RectangleShape2D.new()
  select_rect.extents = get_width_and_height()/2
  
  var space = get_world_2d().direct_space_state
  var query : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
  query.set_shape(select_rect)
  query.transform = Transform2D(0, (end_pos + start_pos) / 2)
  query.collision_layer = 1 << team
  return space.intersect_shape(query)
  
func reset():
  start_pos = null
  end_pos = null
  update()
