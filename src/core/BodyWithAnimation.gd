tool
extends Node2D

export(Texture) var head_texture setget set_head_texture, get_head_texture
export(Texture) var body_texture setget set_body_texture, get_body_texture

func get_animator():
  return $BodyAnimator
  
func _ready():
  $head.texture = head_texture
  $body.texture = body_texture

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
