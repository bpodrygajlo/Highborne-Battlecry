extends "res://addons/gut/test.gd"

func test_baseline():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000])) 

func test_division_var():
  var div = randi() % 3 + 30
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i / div
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))



func test_division():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
# warning-ignore:integer_division
    result[i] = i / 30
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_division_by_power_of_2():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
# warning-ignore:integer_division
    result[i] = i / 32
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))



func test_division_rshift():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i >> 5
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))

func test_mod():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i % 31
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mod_power_of_2():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i % 32
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mod_mask():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i & 0x1f
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mod_var():
  var div = randi() % 3 + 30
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i % div
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mod_mask_var():
  var mask = 1 << ((randi() % 3 + 1)) - 1
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i & mask
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_division_rshift_var():
  var div = randi() % 4 + 2
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i >> div
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))




func test_mul_var():
  var div = randi() % 4 + 2
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i * div
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mul_lshift_var():
  var div = randi() % 4 + 2
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i << div
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_mul_lshift():
  var x = []
  for i in range(100000):
    x.append(i)
  var result = PoolIntArray([])
  result.resize(100000)
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result[i] = i << 6
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000]))


func test_baseline_list():
  var x = []
  for i in range(100000):
    x.append(randi())
  var result = []
    
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result.push_back(x[i])
  var end = OS.get_ticks_usec()
  _lgr.log("Took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000])) 



func test_dict_vs_list_vs_pool_array():
  var x = []
  var dict = {}
  var array = PoolIntArray([])
  array.resize(100000)
  for i in range(100000):
    x.append(randi())
    dict[i] = randi()
    array[i] = randi()
  var result = []
  
  var start = OS.get_ticks_usec()
  for i in range(100000):
    result.push_back(dict[i])
  var end = OS.get_ticks_usec()
  _lgr.log("Dict: took " + str(end - start) + " usec")
  
  _lgr.log(str(result[randi() % 100000])) 
  
  result = []
  start = OS.get_ticks_usec()
  for i in range(100000):
    result.push_back(x[i])
  end = OS.get_ticks_usec()
  _lgr.log("List: took " + str(end - start) + " usec")
  _lgr.log(str(result[randi() % 100000])) 
  
  result = []
  start = OS.get_ticks_usec()
  for i in range(100000):
    result.push_back(array[i])
  end = OS.get_ticks_usec()
  _lgr.log("Array: took " + str(end - start) + " usec")
  _lgr.log(str(result[randi() % 100000])) 
  
