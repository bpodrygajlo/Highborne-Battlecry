extends TileMap
class_name NavTileMap

var astar : AStar2D = AStar2D.new()
var cluster_astar : AStar2D = AStar2D.new()

const cluster_size = 16
var n_clusters_width : int
var n_clusters_height : int

class Cluster:
  var astar : AStar2D = AStar2D.new()
  var portals : PoolVector2Array = PoolVector2Array([])
  func build_flow_field(to : Vector2):
    pass
  func get_point_path(from : Vector2, to: Vector2):
    var from_id = astar.get_closest_point(from)
    var to_id = astar.get_closest_point(to)
    return astar.get_point_path(from_id, to_id)

func _ready():
  assert(get_used_rect().size.x as int % cluster_size == 0)
  assert(get_used_rect().size.y as int % cluster_size == 0)
  n_clusters_width = get_used_rect().size.x / cluster_size
  n_clusters_height = get_used_rect().size.y / cluster_size
  collision_mask = 0x0
  collision_layer = 0x0
 
func tile_to_point_id(i, j) -> int:
  var offset = get_used_rect().position
  return i - offset.x + get_used_rect().size.x * (j - offset.y)
  
func get_point_id(i, j) -> int:
  return i + get_used_rect().size.x * j
  
func generate_points_from_tiles():
  var tilemap_size : Vector2 = get_used_rect().size
  var tilemap_pos : Vector2 = get_used_rect().position
  for i in range(tilemap_pos.x, tilemap_pos.x + tilemap_size.x):
    for j in range(tilemap_pos.y, tilemap_pos.y + tilemap_size.y):
      var tile_id = get_cell(i, j)
      if tile_set.tile_get_navigation_polygon(tile_id) == null:
       continue
      var point_position = Vector2(cell_size.x * i, cell_size.y * j)
      point_position += cell_size / 2
      astar.add_point(tile_to_point_id(i,j), point_position)

func connect_points():
  for point_id in astar.get_points():
    var neighbors = get_possible_neighbor_ids(point_id)
    for neighbor in neighbors:
      if neighbor in astar.get_points():
        astar.connect_points(point_id, neighbor)

func get_i_from_point_id(point_id):
  return point_id % (get_used_rect().size.x as int)
  
func get_j_from_point_id(point_id):
  return (point_id / get_used_rect().size.x) as int

# finding possible neighbors. Only up/down/left/right is considered
func get_possible_neighbor_ids(point_id):
  var i = get_i_from_point_id(point_id)
  var j = get_j_from_point_id(point_id)
  var neigh : Array = []
  if i - 1 > 0:
    neigh.push_back(get_point_id(i - 1, j))
  if i + 1 < get_used_rect().size.x:
    neigh.push_back(get_point_id(i + 1, j))
  if j - 1 > 0:
    neigh.push_back(get_point_id(i, j - 1))
  if j + 1 < get_used_rect().size.y:
    neigh.push_back(get_point_id(i, j + 1))
  return neigh

func get_point_path(from : Vector2, to: Vector2):
  var from_id = astar.get_closest_point(from)
  var to_id = astar.get_closest_point(to)
  return astar.get_point_path(from_id, to_id)
          
func build_portals(cluster_i, cluster_j):
  var cluster_start_x = cluster_i * cluster_size
  var cluster_start_y = cluster_j * cluster_size
  var portals : PoolVector2Array = PoolVector2Array([])
  if cluster_i - 1 >= 0:
    portals.append_array(
      build_vertical_portals(cluster_start_y,
                             cluster_start_x,
                             cluster_start_x - 1))
  if cluster_i + 1 < n_clusters_width:
    portals.append_array(
      build_vertical_portals(cluster_start_y,
                             cluster_start_x + cluster_size - 1,
                             cluster_start_x + cluster_size))
  
  if cluster_j - 1 >= 0:
    portals.append_array(
      build_horizontal_portals(cluster_start_x,
                               cluster_start_y,
                               cluster_start_y - 1))
  if cluster_j + 1 < n_clusters_height:
    portals.append_array(
      build_horizontal_portals(cluster_start_x,
                               cluster_start_y + cluster_size - 1,
                               cluster_start_y + cluster_size))
  
  return portals


func build_horizontal_portals(cluster_start_x, row1, row2):
  var portal_start = 0
  var portal_length = 0
  var portals = []
  for i in range(cluster_size):
    var tile_id = get_cell(cluster_start_x + i, row1)
    if tile_set.tile_get_navigation_polygon(tile_id) == null:
      if portal_length > 1:
        portals.append(Vector2(
          col_to_x(portal_start + portal_length / 2),
          (row_to_y(row1)  + row_to_y(row2))/2))
      portal_length = 0
      continue
    tile_id = get_cell(cluster_start_x + i, row2)
    if tile_set.tile_get_navigation_polygon(tile_id) == null:
      if portal_length > 1:
        portals.append(Vector2(
          col_to_x(portal_start + portal_length / 2),
          (row_to_y(row1)  + row_to_y(row2))/2))
      portal_length = 0
      continue
    if portal_length == 0:
      portal_start = cluster_start_x + i
    portal_length += 1

  if portal_length > 1:
    portals.append(Vector2(
      col_to_x(portal_start + portal_length / 2),
      (row_to_y(row1)  + row_to_y(row2))/2))
  return portals

func build_vertical_portals(cluster_start_y, col1, col2):
  var portal_start = 0
  var portal_length = 0
  var portals = []
  for i in range(cluster_size):
    var tile_id = get_cell(col1, cluster_start_y + i)
    if tile_set.tile_get_navigation_polygon(tile_id) == null:
      if portal_length > 1:
        portals.append(Vector2(
          (col_to_x(col1) + col_to_x(col2)) / 2,
          row_to_y(portal_start + portal_length / 2)))
      portal_length = 0
      continue
    tile_id = get_cell(col2, cluster_start_y + i)
    if tile_set.tile_get_navigation_polygon(tile_id) == null:
      if portal_length > 1:
        portals.append(Vector2(
          (col_to_x(col1) + col_to_x(col2)) / 2,
          row_to_y(portal_start + portal_length / 2)))
      portal_length = 0
      continue
    if portal_length == 0:
      portal_start = i + cluster_start_y
    portal_length += 1
    
  if portal_length > 1:
    portals.append(Vector2(
      (col_to_x(col1) + col_to_x(col2)) / 2,
      row_to_y(portal_start + portal_length / 2)))
  return portals

func row_to_y(row):
  return row * cell_size.y
  
func col_to_x(col):
  return col * cell_size.x

func generate_cluster(cluster_i, cluster_j):
  var start_x = cluster_i * cluster_size
  var start_y = cluster_j * cluster_size
  var cluster = Cluster.new()
  for i in range(start_x, start_x + cluster_size):
    for j in range(start_y,  start_y + cluster_size):
      var tile_id = get_cell(i, j)
      if tile_set.tile_get_navigation_polygon(tile_id) == null:
       continue
      var point_position = Vector2(cell_size.x * i, cell_size.y * j)
      point_position += cell_size / 2
      cluster.astar.add_point(tile_to_point_id(i,j), point_position)
      cluster.portals = build_portals(cluster_i, cluster_j)

var clusters = []
func generage_clusters():
  for i in get_used_rect().size.x as int / cluster_size:
    for j in get_used_rect().size.y as int / cluster_size:
      clusters.append(generate_cluster(i, j))
  
