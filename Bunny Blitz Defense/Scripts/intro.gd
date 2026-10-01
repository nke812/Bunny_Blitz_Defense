extends AnimationPlayer

func _ready() -> void:
    await $".".animation_finished
    get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
