extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	z_index = 30
	modulate.a -= delta
	position.y -= 0.5
	if modulate.a <= 0.3:
		queue_free()
