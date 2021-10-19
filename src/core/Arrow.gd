extends Node2D


var destination : Vector2
const speed = 700
var attacker : Unit

func _process(delta):
  var diff : Vector2 = destination - position
  if diff.length_squared() < 50:
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20
    var query : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
    query.set_shape(circle_shape)
    query.transform = Transform2D(0, position)
    query.collision_layer = (~(1 << attacker.team) & 0xf)
    query.collide_with_areas = false
    query.collide_with_bodies = true
    
    var space = get_world_2d().direct_space_state
    var result = space.intersect_shape(query)
    if result != []:
      var body = result[0]["collider"]
      body.take_damage(attacker.attack, attacker)
    queue_free()
  else:
    position += diff.normalized() * speed * delta   
