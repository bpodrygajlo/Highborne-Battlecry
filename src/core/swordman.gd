extends Unit
class_name SwordMan

func _ready():
  ._ready()
  animation_player = $Node/BodyAnimator


func _physics_process(delta):
  if state == NORMAL:
    if target != null:
      match typeof(target):
        # Unit was just told to move
        TYPE_VECTOR2:
          if goto(target, 10):
            target = null
        # Something else as target. ATTACK!
        TYPE_OBJECT:
          goto(target.position)
          if is_within_range(target.position, attack_range):
            velocity = Vector2.ZERO
            state = ATTACKING
            $Node/BodyAnimator.play("attack_down")
            $SwordShieldAnimator.play("attack_down")

      
  ._physics_process(delta)


func update_animation():
  if state == NORMAL:
    if velocity.length() < 10:
      return
    if abs(velocity.x) > abs(velocity.y):
      if velocity.x > 0.1:
        $Node/BodyAnimator.play("walk_right")
        $SwordShieldAnimator.play("walk_right")
      elif velocity.x < -0.1:
        $Node/BodyAnimator.play("walk_left")
        $SwordShieldAnimator.play("walk_left")
    else:
      if velocity.y > 0.1:
        $Node/BodyAnimator.play("walk_down")
        $SwordShieldAnimator.play("walk_down")
      elif velocity.y < -0.1:
        $Node/BodyAnimator.play("walk_up")
        $SwordShieldAnimator.play("walk_up")
      
func get_actions():
  return ["Destroy"]

func perform_action(action, _world):
  if action == "Destroy":
    emit_signal("died")
    queue_free()
