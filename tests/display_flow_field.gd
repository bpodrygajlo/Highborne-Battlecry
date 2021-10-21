extends Node2D

var flow_field : Astar.FlowField = null    
var tilemap : Astar.AstarTilemap = null

func _draw():
  if flow_field != null:
    var size = flow_field.cell_size.x
    for point_id in range(flow_field.field.size()):
      var tile = tilemap.point_id_to_tile(point_id)
      var pos : Vector2 = Vector2(size * tile.x, size * tile.y)
      var center = pos + flow_field.cell_size/2.0
      var diff : Vector2 = flow_field.field[point_id] * size/3
      draw_arrow(center - diff, center + diff)
      if tilemap.weights[point_id] == 0:
        draw_rect(Rect2(pos, flow_field.cell_size), Color.red, false)
        
func draw_flow_field(_flow_field):
  flow_field = _flow_field
  update()


func draw_arrow(from, to):
  draw_line(from, to, Color.green)
  var vec = from - to
  draw_line(to, to + (vec/2).rotated(PI/5), Color.green)
  draw_line(to, to + (vec/2).rotated(-PI/5), Color.green)
