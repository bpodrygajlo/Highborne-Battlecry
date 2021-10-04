extends Node2D

const MIN_SIZE = 30

# mouse positions for drawing selection rectangle
var start_pos = null
var end_pos = null

func is_valid():
  if start_pos == null:
    return false
  return true
  
func is_drawable():
  return is_valid() and end_pos != null and (start_pos - end_pos).length_squared() > (MIN_SIZE * MIN_SIZE)
  
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
  if is_drawable():
    draw_selection_rectangle()

func _input(event):
  if event is InputEventMouseMotion:
    if start_pos != null:
      end_pos = get_global_mouse_position()
      if is_valid():
        update()

func get_unit_at(point : Vector2, team_filter : int) -> Unit:
  var space = get_world_2d().direct_space_state
  var result = space.intersect_point(point, 1, [], team_filter, false, true)
  if result != []:
    return result[0]["collider"].get_parent()
  return null

func get_selected_units(team):
  end_pos = get_global_mouse_position()
  if not is_valid():
    return []
  
  var team_filter = 1 << team
  if start_pos == end_pos:
    var result = get_unit_at(start_pos, team_filter)
    if result != null:
      return [result]
    else:
      return []
  
  var select_rect : RectangleShape2D = RectangleShape2D.new()
  select_rect.extents = get_width_and_height()/2
  
  var query : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
  query.set_shape(select_rect)
  query.transform = Transform2D(0, (end_pos + start_pos) / 2)
  query.collision_layer = 1 << team
  query.collide_with_areas = true
  query.collide_with_bodies = false
  var result = []
  var space = get_world_2d().direct_space_state
  for area2d in space.intersect_shape(query):
    result.append(area2d["collider"].get_parent())
  return result
  
func reset():
  start_pos = null
  end_pos = null
  update()
