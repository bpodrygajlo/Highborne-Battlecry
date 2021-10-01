tool
extends Node2D
class_name BodyWithAnimation

signal hit
signal attack_finished
signal death

export(Texture) var head_texture setget set_head_texture, get_head_texture
export(Texture) var body_texture setget set_body_texture, get_body_texture
export(Texture) var left_texture setget set_left_texture, get_left_texture
export(Texture) var right_texture setget set_right_texture, get_right_texture

func get_animator():
  return $BodyAnimator
  
func get_animation_tree():
  return $AnimationTree
  
func _ready():
  $head.texture = head_texture
  $body.texture = body_texture
  $item_l.texture = left_texture
  $item_r.texture = right_texture

func set_head_texture(texture):
  head_texture = texture
  if is_inside_tree():
    $head.texture = texture

func get_head_texture():
  return head_texture

func set_body_texture(texture):
  body_texture = texture
  if is_inside_tree():
    $body.texture = texture

func get_body_texture():
  return body_texture

func set_left_texture(texture):
  left_texture = texture
  if is_inside_tree():
    $item_l.texture = texture

func get_left_texture():
  return left_texture

func set_right_texture(texture):
  right_texture = texture
  if is_inside_tree():
    $item_r.texture = texture

func get_right_texture():
  return right_texture

func report_hit():
  emit_signal("hit")


func set_direction(dir : Vector2):
  $AnimationTree.set("parameters/walk/direction/blend_position", dir)
  $AnimationTree.set("parameters/attackonehand/direction/blend_position", dir)
  $AnimationTree.set("parameters/attackonehand/attack/blend_position", dir)
  
func set_animation(anim_name):
  var playback = $AnimationTree.get("parameters/playback")
  match anim_name:
    "walk":
      playback.travel("walk")
    "attack":
      if playback.get_current_node() == "attackonehand":
        playback.start("attackonehand")
      else:
        playback.travel("attackonehand")
    "death":
      playback.travel("death")
  
func report_attack_finished():
  emit_signal("attack_finished")
  
func report_death():
  emit_signal("death")

func stop():
  var playback = $AnimationTree.get("parameters/playback")
  playback.stop()
