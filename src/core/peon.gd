extends Unit
  
func _ready():
  ._ready()
  
func _physics_process(delta):
  if state == NORMAL:
    if target != null:
      match typeof(target):
        # Unit was just told to move
        TYPE_VECTOR2:
          if goto(target):
            target = null
        # Something else as target. ATTACK!
        TYPE_OBJECT:
          goto(target.position)
          if is_within_range(target.position, attack_range):
            velocity = Vector2.ZERO
            state = ATTACKING
            $AnimationPlayer.play("attack_left")

      
  ._physics_process(delta)


func update_animation():
  if state == NORMAL:
    $AnimationPlayer.play("idle")
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
    emit_signal("died")
    queue_free()
