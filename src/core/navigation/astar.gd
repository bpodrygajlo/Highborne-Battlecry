extends Node
class_name Astar

class IntVec2:
  var x : int
  var y : int
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
  func _init(x : int = 0, y : int = 0):
    self.x = x
    self.y = y
  func _to_string():
    return "(%d, %d)" % [self.x, self.y]
    
class FlowField:
  var cell_size : Vector2
  var field : PoolVector2Array
  
  
# this class is optimized with the following assumptions about GDScript, which
# I've discovered when testing GDScript performance in test_gdscript.gd
#  - There is no optimization for const vs var
#  - rshift is faster than division
#  - mask is faster than modulo
#  - mul (*) is faster than lshift (????)
#  - PoolIntArray is faster than list
#  - GDScript doesnt substitute division by power of two into rshift
#  - arrays ([]) are faster than dicts, but similar to PoolArrays
# List of optimizations:
#  - size is limited to power of two so shift and mask can be used instead of div/mod
#  - all_neighbors are cached in a dictionary
#  - all possible vectors are cached in a dictionary
#  - flow_field doesnt call get_vector, instead it is inlined in the code
#  - distance and flow_field doesnt call point_id_to_tile, its inlined instead
#  - all_neighbors are pre-generated before flow_field is called
#  - neighbors caching
#  - remove get_neighbors call
class AstarTilemap:
  var size : IntVec2 = IntVec2.new()
  var log2size : IntVec2 = IntVec2.new()
  var mask : int
  var cell_size : Vector2
  var weights : PoolIntArray = PoolIntArray([])
  var all_neighbors = {}
  var neighbors_cache = {}
  var vectors = {}
  func log2(val : int) -> int:
    if val < 0:
      val *= -1
    var res = 0
    while val != 1:
      val = val >> 1
      res += 1
    return res
# warning-ignore:shadowed_variable
  func _init(cell_size : Vector2 = Vector2.ONE, size : IntVec2 = IntVec2.new(32,32)):
    self.cell_size = cell_size
    self.size = size
    self.log2size.x = log2(size.x)
    self.log2size.y = log2(size.y)
    assert(size.x == 1 << log2size.x)
    assert(size.y == 1 << log2size.y)
    self.mask = size.x - 1
    _generate_tilemap()
    generate_vectors()
    generate_all_neighbors()
  func tile_to_point_id(tile: IntVec2) -> int: return tile.x + tile.y * size.x
  func point_id_to_tile(id : int) -> IntVec2: return IntVec2.new(id & mask, id >> log2size.x)
  func get_tile_weight(tile : IntVec2) -> int: return weights[tile_to_point_id(tile)]
  func set_point_weight(id : int, value) -> void:
    weights[id] = value
    update_neighbors(id)
  func set_tile_weight(tile : IntVec2, value) -> void:
    set_point_weight(tile_to_point_id(tile), value)
  func is_in_bounds(id : int) -> bool:
    var tile = point_id_to_tile(id)
    return tile.x >= 0 and tile.x < size.x and tile.y >= 0 and tile.y < size.y
  func _generate_tilemap() -> void:
    weights.resize(size.x * size.y)
    for point_id in range(weights.size()):
        weights[point_id] = 1
  func get_tile_center(i, j) -> Vector2:
    return Vector2(i * cell_size.x, j * cell_size.y)
  func get_closest_point(position : Vector2):
    var tile = IntVec2.new(position.x / cell_size.x, position.y / cell_size.y)
    return tile_to_point_id(tile)
  func generate_vectors():
    var corners = [0, size.x - 1, (size.x - 1) * size.y, size.x * size.y - 1]
    for point in corners:
      for neighbor in get_all_neighbors(point):
        vectors[point - neighbor] = generate_vector(point, neighbor)
  func generate_all_neighbors():
    for i in range(size.x * size.y):
      get_all_neighbors(i)
      get_neighbors(i)
  func update_neighbors(point_id):
    var neighbors = get_all_neighbors(point_id)
    neighbors.append(point_id)
    for point in neighbors:
      neighbors_cache.erase(point)
      get_neighbors(point)
      all_neighbors.erase(point)
      get_all_neighbors(point)
  func get_vector(from: int, to : int):
    return vectors[from - to]
  func generate_vector(from, to):  
    var from_tile : IntVec2 = point_id_to_tile(from)
    var to_tile : IntVec2 = point_id_to_tile(to)
    return Vector2(to_tile.x - from_tile.x, to_tile.y - from_tile.y)
    
  func get_neighbors(point_id : int) -> Array:
    if neighbors_cache.has(point_id):
      return neighbors_cache[point_id]
    var tile_x = point_id & mask
    var tile_y = point_id >> log2size.x
    var neighbors = []
    var invalid_neighbors = []
    
    if tile_x - 1 >= 0:
      var left : int = point_id - 1
      if weights[left] > 0:
        neighbors.push_back(left)
      else:
        invalid_neighbors.push_back(left)
    
    if tile_x + 1 < size.x:
      var right : int = point_id + 1
      if weights[right] > 0:
        neighbors.push_back(right)
      else:
        invalid_neighbors.push_back(right)
      
    if tile_y - 1 >= 0:
      var up : int = point_id - size.x
      if weights[up] > 0:
        neighbors.push_back(up)
      else:
        invalid_neighbors.push_back(up)
      
    if tile_y + 1 < size.y:
      var down : int = point_id + size.x
      if weights[down] > 0:
        neighbors.push_back(down)
      else:
        invalid_neighbors.push_back(down)
    
    neighbors_cache[point_id] = [neighbors, invalid_neighbors]
    return [neighbors, invalid_neighbors]
    
  func get_distances(to : int) -> PoolRealArray:
    assert(is_in_bounds(to))
    
    var distances = PoolRealArray()
    distances.resize(weights.size())
    distances[to] = 0.0;
    
    var marked = {}
    marked[to] = true
    
    var to_visit = [to]
    while to_visit.size() > 0:
      var point = to_visit.pop_front()
      var neighbors = neighbors_cache[point]
      var valid_neighbors = neighbors[0]
      var invalid_neighbors = neighbors[1]
      for other_point in valid_neighbors:
        if not marked.has(other_point):
          distances[other_point] = weights[other_point] + distances[point]
          marked[other_point] = true
          to_visit.push_back(other_point)
      for other_point in invalid_neighbors:
        distances[other_point] = INF
        
    return distances

  func get_flow_field(to : int):
    var distances = get_distances(to)
    var flow_field : PoolVector2Array  = PoolVector2Array([])
    flow_field.resize(distances.size())
    for point_id in range(weights.size()):
      var neighbors = all_neighbors[point_id]
      var min_dist = INF
      for other_point in neighbors:
        var dist = distances[other_point] - distances[point_id]
        if dist < min_dist:
          min_dist = dist
          flow_field[point_id] = vectors[point_id - other_point]
    flow_field[to] = Vector2.ZERO
    return flow_field
    
  func get_all_neighbors(point_id : int) -> Array:
    if all_neighbors.has(point_id):
      return all_neighbors[point_id]
    var tile_x = point_id & mask
    var tile_y = point_id >> log2size.x
    var neighbors = []
    
    var left : int = point_id - 1
    var left_valid : bool = tile_x - 1 >= 0 and weights[left] > 0
    
    var right : int = point_id + 1
    var right_valid : bool = tile_x + 1 < size.x and weights[right] > 0
    
    var up : int = point_id - size.x
    var up_valid : bool = tile_y - 1 >= 0 and weights[up] > 0
  
    var down : int = point_id + size.x
    var down_valid : bool = tile_y + 1 < size.y and weights[down] > 0
    
    if left_valid:
      neighbors.push_back(left)
    if right_valid:
      neighbors.push_back(right)
    if up_valid:
      neighbors.push_back(up)
    if down_valid:
      neighbors.push_back(down)
    
    var up_right = point_id - size.x + 1
    if right_valid and up_valid:
      if weights[up_right] > 0:
        neighbors.push_back(up_right)
    
    var up_left = point_id - size.x - 1
    if left_valid and up_valid:
      if weights[up_left] > 0:
        neighbors.push_back(up_left)
        
    var down_right = point_id + size.x + 1
    if right_valid and down_valid:
      if weights[down_right] > 0:
        neighbors.push_back(down_right)
        
    var down_left = point_id + size.x - 1
    if left_valid and down_valid:
      if weights[down_left] > 0:
        neighbors.push_back(down_left)
    
    all_neighbors[point_id] = neighbors
    return neighbors
