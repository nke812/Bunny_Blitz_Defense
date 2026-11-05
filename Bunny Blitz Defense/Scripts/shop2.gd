extends Node2D

func _ready() -> void:
    SaveManager.carregar_dados()
    $BunnyCoins/Price.text = str(SaveManager.BunnyCoins)

func _on_item_shop_pressed() -> void:
    $Maya/MayaHappy.play("MayaHappy")
    $Sparkle/SparkleAnim.play("new_animation")
    
    await $Maya/MayaHappy.animation_finished
    $Maya/MayaIdle.play("Idle")
    
    await get_tree().create_timer(1.0).timeout
    $Maya/MayaHappy.play_backwards("MayaHappy")

func VerificarMayaHead():
    var caminho_atual = $Maya/MayaHead.texture.resource_path if $Maya/MayaHead.texture else ""
    
    if caminho_atual == "res://Assets/Others/Menu_Assets/Shop/Shop2/MayaHeadHappy.png":
        $Maya/MayaHead.texture = load("res://Assets/Others/Menu_Assets/Shop/Shop2/MayaHead.png")
    else:
        $Maya/MayaHead.texture = load("res://Assets/Others/Menu_Assets/Shop/Shop2/MayaHeadHappy.png")
