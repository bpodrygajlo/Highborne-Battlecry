extends "res://addons/gut/test.gd"


func test_navigation_get_vector():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(300,300), Vector2(30,30))
  
  assert_eq(nav.get_vector(0, 1), Vector2(1, 0))
  assert_eq(nav.get_vector(1, 0), Vector2(-1, 0))
  assert_eq(nav.get_vector(0, 10), Vector2(0, 1))
  assert_eq(nav.get_vector(10, 0), Vector2(0, -1))
  
  assert_eq(nav.get_vector(11, 0), Vector2(-1,-1))
  assert_eq(nav.get_vector(0, 11), Vector2(1,1))
  
func test_navigation_generation():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  assert_eq(nav.size.x, 3)
  assert_eq(nav.size.y, 3)
  
  nav.generate_tilemap(Vector2(2,2), Vector2(1,1))
  assert_eq(nav.size.x, 2)
  assert_eq(nav.size.y, 2)
  
  nav.generate_tilemap(Vector2(2.5,2.5), Vector2(1,1))
  assert_eq(nav.size.x, 2)
  assert_eq(nav.size.y, 2)
  
func test_point_id_to_tile():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # grid tile ids
  # 0 1 2
  # 3 4 5
  # 6 7 8
  var tile = nav.point_id_to_tile(0)
  assert_eq(tile.x, 0)
  assert_eq(tile.y, 0)
  
  tile = nav.point_id_to_tile(1)
  assert_eq(tile.x, 1)
  assert_eq(tile.y, 0)
  
  tile = nav.point_id_to_tile(3)
  assert_eq(tile.x, 0)
  assert_eq(tile.y, 1)
  
  tile = nav.point_id_to_tile(7)
  assert_eq(tile.x, 1)
  assert_eq(tile.y, 2)
  
  tile = nav.point_id_to_tile(8)
  assert_eq(tile.x, 2)
  assert_eq(tile.y, 2)
  
func test_get_neighbors():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # grid tile ids
  # 0 1 2
  # 3 4 5
  # 6 7 8
  _lgr.log("grid tile ids\n" +
           "0 1 2\n" +
           "3 4 5\n" +
           "6 7 8")
  _lgr.log("Neighbors of 1 " + str(nav.get_neighbors(1)[0]))
  assert_true(1 in nav.get_neighbors(0)[0])
  assert_true(3 in nav.get_neighbors(0)[0])
  assert_eq(2, nav.get_neighbors(0)[0].size())
  
  assert_true(7 in nav.get_neighbors(4)[0])
  
func test_get_neighbors_obstacle():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # grid tile ids
  # 0 1 2
  # 3 4 5
  # 6 7 8
  nav.weights[4] = 0
  assert_false(4 in nav.get_neighbors(1)[0])
  assert_false(4 in nav.get_neighbors(5)[0])
  assert_true(4 in nav.get_neighbors(1)[1])
  
  
func test_get_all_neighbors():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # grid tile ids
  # 0 1 2
  # 3 4 5
  # 6 7 8
  var neighbors = nav.get_all_neighbors(4)
  _lgr.log("grid tile ids\n" +
           "0 1 2\n" +
           "3 4 5\n" +
           "6 7 8")
  _lgr.log("Neighbors of 4: " + str(neighbors))
  assert_true(neighbors.size() == 8)
  assert_false(4 in neighbors)
  neighbors = nav.get_all_neighbors(0)
  _lgr.log("Neighbors of 0: " + str(neighbors))
  
  
  neighbors = nav.get_all_neighbors(5)
  _lgr.log("Neighbors of 5: " + str(neighbors))
  assert_true(neighbors.size() == 5)
  assert_true(1 in neighbors)
  assert_true(2 in neighbors)
  assert_true(4 in neighbors)
  assert_true(7 in neighbors)
  assert_true(8 in neighbors)
  
  
func test_get_all_neighbors_obstacle():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # grid tile ids
  # 0 1 2
  # 3 4 5
  # 6 7 8
  _lgr.log("grid tile ids\n" +
           "0 1 2\n" +
           "3 4 5\n" +
           "6 7 8")
  nav.weights[1] = 0
  var neighbors = nav.get_all_neighbors(4)
  _lgr.log("Neighbors of 4: " + str(neighbors))
  assert_true(neighbors.size() == 5)
  assert_false(4 in neighbors)
  assert_false(1 in neighbors)
  assert_false(0 in neighbors)
  assert_false(2 in neighbors)
  neighbors = nav.get_all_neighbors(0)
  _lgr.log("Neighbors of 0: " + str(neighbors))
  
  
  neighbors = nav.get_all_neighbors(5)
  _lgr.log("Neighbors of 5: " + str(neighbors))
  assert_true(neighbors.size() == 4)
  assert_true(2 in neighbors)
  assert_true(4 in neighbors)
  assert_true(7 in neighbors)
  assert_true(8 in neighbors)
  

func test_navigation_get_distances():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  var distances = nav.get_distances(4)
  assert_eq(distances[0], 2.0)
  assert_eq(distances[4], 0.0)
  assert_eq(distances[5], 1.0)
  

func test_navigation_get_flowfield():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  var flow_field : PoolVector2Array = nav.get_flow_field(4)
  _lgr.log("Flowfield towards 4")
  _lgr.log(str(flow_field[0]) + " " + str(flow_field[1]) + " " + str(flow_field[2]))
  _lgr.log(str(flow_field[3]) + " " + str(flow_field[4]) + " " + str(flow_field[5]))
  _lgr.log(str(flow_field[6]) + " " + str(flow_field[7]) + " " + str(flow_field[8]))
  assert_eq(flow_field[0], Vector2(1,1))
  assert_eq(flow_field[4], Vector2.ZERO)
  assert_eq(flow_field[1], Vector2.DOWN)
  assert_eq(flow_field[7], Vector2.UP)

func test_navigaion_distance_obstacle():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
  # put an obstacle
  nav.weights[1] = 0
  # grid looks like this:
  # 1 0 1
  # 1 1 1
  # 1 1 1
  
  var distances = nav.get_distances(2)
  assert_eq(distances[0], 4.0)
  assert_eq(distances[4], 2.0)
  assert_eq(distances[5], 1.0)
  
func test_navigation_flow_field_obstalce():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
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
  nav.generate_tilemap(Vector2(3,3), Vector2(1,1))
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
  nav.generate_tilemap(Vector2(100,100), Vector2(1,1))
  var start = OS.get_ticks_msec()
  var flow_field = nav.get_flow_field(50*100)
  var end = OS.get_ticks_msec()
  _lgr.log("Took " + str(end - start) + " msec")
  
  
func test_flowfield_performance_2():
  var nav = Astar.AstarTilemap.new()
  nav.generate_tilemap(Vector2(100,100), Vector2(1,1))
  
  var diff = 0
  for i in range(10):
    var start = OS.get_ticks_msec()
    var flow_field = nav.get_flow_field(50*100)
    var end = OS.get_ticks_msec()
    diff += end - start
  _lgr.log("Took " + str(diff/10) + " msec")
  
