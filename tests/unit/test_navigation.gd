extends "res://addons/gut/test.gd"


var size = Astar.IntVec2.new(4,4)

func test_navigation_get_vector():
  var nav = Astar.AstarTilemap.new()
  
  assert_eq(nav.get_vector(0, 1), Vector2(1, 0))
  assert_eq(nav.get_vector(1, 0), Vector2(-1, 0))
  assert_eq(nav.get_vector(0, nav.size.x), Vector2(0, 1))
  assert_eq(nav.get_vector(nav.size.x, 0), Vector2(0, -1))
  
  assert_eq(nav.get_vector(nav.size.x + 1, 0), Vector2(-1,-1))
  assert_eq(nav.get_vector(0, nav.size.x + 1), Vector2(1,1))
  
func test_point_id_to_tile():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, size)
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  var tile = nav.point_id_to_tile(0)
  assert_eq(tile.x, 0)
  assert_eq(tile.y, 0)
  
  tile = nav.point_id_to_tile(1)
  assert_eq(tile.x, 1)
  assert_eq(tile.y, 0)
  
  tile = nav.point_id_to_tile(3)
  assert_eq(tile.x, 3)
  assert_eq(tile.y, 0)
  
  tile = nav.point_id_to_tile(7)
  assert_eq(tile.x, 3)
  assert_eq(tile.y, 1)
  
  tile = nav.point_id_to_tile(8)
  assert_eq(tile.x, 0)
  assert_eq(tile.y, 2)
  
func test_get_neighbors():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, size)
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  _lgr.log("grid tile ids\n" +
           "0  1  2  3\n" +
           "4  5  6  7\n" +
           "8  9  10 11\n" +
           "12 13 14 15")
  _lgr.log("Neighbors of 1 " + str(nav.get_neighbors(1)[0]))
  assert_true(1 in nav.get_neighbors(0)[0])
  assert_true(4 in nav.get_neighbors(0)[0])
  assert_eq(2, nav.get_neighbors(0)[0].size())
  
  assert_true(8 in nav.get_neighbors(4)[0])
  
func test_get_neighbors_obstacle():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, size)
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  nav.set_point_weight(4, 0)
  assert_false(4 in nav.get_neighbors(0)[0])
  assert_false(4 in nav.get_neighbors(5)[0])
  assert_true(4 in nav.get_neighbors(8)[1])
  
  
func test_get_all_neighbors():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, size)
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  var neighbors = nav.get_all_neighbors(4)
  _lgr.log("Neighbors of 4: " + str(neighbors))
  assert_true(neighbors.size() == 5)
  assert_false(4 in neighbors)
  neighbors = nav.get_all_neighbors(0)
  _lgr.log("Neighbors of 0: " + str(neighbors))
  
  
  neighbors = nav.get_all_neighbors(5)
  _lgr.log("Neighbors of 5: " + str(neighbors))
  assert_true(neighbors.size() == 8)
  assert_true(0 in neighbors)
  assert_true(1 in neighbors)
  assert_true(2 in neighbors)
  assert_true(4 in neighbors)
  assert_true(6 in neighbors)
  assert_true(8 in neighbors)
  assert_true(9 in neighbors)
  assert_true(10 in neighbors)  
  
func test_get_all_neighbors_obstacle():
  var nav = Astar.AstarTilemap.new()
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  nav.set_point_weight(1, 0)
  var neighbors = nav.get_all_neighbors(5)
  _lgr.log("Neighbors of 5: " + str(neighbors))
  assert_true(neighbors.size() == 5)
  assert_false(1 in neighbors)
  assert_false(0 in neighbors)
  assert_false(2 in neighbors)
  neighbors = nav.get_all_neighbors(0)
  _lgr.log("Neighbors of 0: " + str(neighbors))
  

func test_navigation_get_distances():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, size)
  # grid tile ids
  # 0  1  2  3
  # 4  5  6  7
  # 8  9  10 11
  # 12 13 14 15
  var distances = nav.get_distances(4)
  assert_eq(distances[0], 1.0)
  assert_eq(distances[4], 0.0)
  assert_eq(distances[5], 1.0)
  

func test_navigation_get_flowfield():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, Astar.IntVec2.new(2,2))
  var flow_field : PoolVector2Array = nav.get_flow_field(3)
  _lgr.log("Flowfield towards 3")
  _lgr.log(str(flow_field[0]) + " " + str(flow_field[1]))
  _lgr.log(str(flow_field[2]) + " " + str(flow_field[3]))
  assert_eq(flow_field[0], Vector2(1,1))
  assert_eq(flow_field[3], Vector2.ZERO)
  assert_eq(flow_field[1], Vector2.DOWN)
  assert_eq(flow_field[2], Vector2.RIGHT)


func test_navigaion_distance_obstacle():
  var nav = Astar.AstarTilemap.new()
  nav.set_point_weight(1, 0)
  
  var distances = nav.get_distances(2)
  assert_eq(distances[0], 4.0)
  assert_eq(distances[4], 2.0)
  
func test_navigation_flow_field_obstalce():
  var nav = Astar.AstarTilemap.new()
  # put an obstacle
  nav.weights[1] = 0
  # grid looks like this:
  # 1 0 1
  # 1 1 1
  # 1 1 1
  var flow_field = nav.get_flow_field(2)
  _lgr.log("Obstacle on 1, flow field towards 2")
  _lgr.log(str(flow_field[0]) + " " + str(flow_field[1]) + " " + str(flow_field[2]))
  _lgr.log(str(flow_field[3]) + " " + str(flow_field[4]) + " " + str(flow_field[5]))
  _lgr.log(str(flow_field[6]) + " " + str(flow_field[7]) + " " + str(flow_field[8]))
  
# this doesn't work yet
func disabled_test_navigaion_difficult_terrain():
  var nav = Astar.AstarTilemap.new()
  # put an obstacle
  nav.weights[1] = 6
  # grid looks like this:
  # 1 6 1
  # 1 1 1
  # 1 1 1
  var distances = nav.get_distances(2)
  assert_eq(distances[0], 4.0)
  assert_eq(distances[4], 2.0)
  assert_eq(distances[5], 1.0)



func test_flowfield_performance_1():
  var nav = Astar.AstarTilemap.new()
  var start = OS.get_ticks_msec()
  var flow_field = nav.get_flow_field(15*16)
  var end = OS.get_ticks_msec()
  _lgr.log("Took " + str(end - start) + " msec")
  
  
func test_flowfield_performance_2():
  var nav = Astar.AstarTilemap.new()
  
  var diff = 0
  for i in range(10):
    var start = OS.get_ticks_msec()
    var flow_field = nav.get_flow_field(15*16)
    var end = OS.get_ticks_msec()
    diff += end - start
  _lgr.log("Took " + str(diff/10) + " msec")
  

  
# On my machine this takes 1359ms with rshift/mask optimization
#                          1250ms with all_neighbors cache, second run 1150ms
#                           524ms/469ms with vector pre-generation
#                           444ms/414ms without the get_vector func call
#                           310ms/274ms removing point_id_to_tile call
#                           258ms/255ms pregeneration all_neighbors in a dict
#                           192ms/176ms neighbors cache
#                           160ms/171ms remove get_neighbors call
func test_flowfield_performance_3():
  var nav = Astar.AstarTilemap.new(Vector2.ONE, Astar.IntVec2.new(128, 128))
  
  var diff = 0
  for i in range(10):
    var start = OS.get_ticks_msec()
    var flow_field = nav.get_flow_field(15*16)
    var end = OS.get_ticks_msec()
    diff += end - start
  _lgr.log("Took " + str(diff/10) + " msec")
  
  
  diff = 0
  for i in range(10):
    var start = OS.get_ticks_msec()
    var flow_field = nav.get_flow_field(15*16)
    var end = OS.get_ticks_msec()
    diff += end - start
  _lgr.log("Took " + str(diff/10) + " msec")
  
