extends Unit
  
func _ready():
  ._ready()
  speed = 100
  
func _physics_process(delta):
  if state == NORMAL:
    if target_position != null:
      if goto(target_position):
        target_position = null
      
  ._physics_process(delta)


func update_animation():
  if velocity.length() < 0.5:
    return
  if abs(velocity.x) > abs(velocity.y):
    if velocity.x > 0:
      $Sprite.frame = 2
    else:
      $Sprite.frame = 3
  else:
    if velocity.y > 0:
      $Sprite.frame = 1
    else:
      $Sprite.frame = 0
      
func get_actions():
  return ["Destroy"]

func perform_action(action, _world):
  if action == "Destroy":
    queue_free()
