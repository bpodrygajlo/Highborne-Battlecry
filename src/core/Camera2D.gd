extends Camera2D
# A camera that moves when mouse enters areas near screen edge.

# defines the size of the boundary area. If coursor is within boundary of 
# the screen edge camera will move towards the cursors position
var boundary = 0.03

func _process(delta):
  var viewport_size = get_viewport_rect().size
  var viewport_mouse_pos = get_viewport().get_mouse_position()
  
  var boundary_x = viewport_size.x * boundary
  var move_x : bool = (viewport_mouse_pos.x < boundary_x or
					   viewport_mouse_pos.x > viewport_size.x - boundary_x)
  var boundary_y = viewport_size.y * boundary
  var move_y : bool = (viewport_mouse_pos.y < boundary_y or
					   viewport_mouse_pos.y > viewport_size.y - boundary_x)
  
  var mouse_pos = get_global_mouse_position()
  if move_x:
	position.x = lerp(position.x, mouse_pos.x, delta)
  if move_y:
	position.y = lerp(position.y, mouse_pos.y, delta)  
