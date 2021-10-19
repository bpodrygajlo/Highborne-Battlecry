extends Node2D

var flow_field : Astar.FlowField = null    
var tilemap : Astar.AstarTilemap = null
func _draw():
  if flow_field != null:
    var size = flow_field.cell_size.x
    var pos = Vector2(0, 0)
    for vec in flow_field.field:
      var arrow_end : Vector2 = pos+vec*size/2
      draw_arrow(pos, arrow_end)
      
      pos.x += size
      if pos.x == size * tilemap.size.x:
        pos.x = 0
        pos.y += size
    pos = Vector2(0,0)
    for weight in tilemap.weights:
      if weight == 0:
        draw_rect(Rect2(pos - Vector2(size/2, size/2), Vector2(size,size)), Color.red, false)
      pos.x += size
      if pos.x == size * tilemap.size.x:
        pos.x = 0
        pos.y += size

func draw_flow_field(_flow_field):
  flow_field = _flow_field
  update()


func draw_arrow(from, to):
  draw_line(from, to, Color.green)
  var vec = from - to
  draw_line(to, to + (vec/2).rotated(PI/5), Color.green)
  draw_line(to, to + (vec/2).rotated(-PI/5), Color.green)
