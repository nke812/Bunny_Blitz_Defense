extends Panel

func fadeOut():
    if !$"../Black/FadeOut".is_playing():
        $"../Black/FadeOut".play("FadeOut")

        await $"../Black/FadeOut".animation_finished
        get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
