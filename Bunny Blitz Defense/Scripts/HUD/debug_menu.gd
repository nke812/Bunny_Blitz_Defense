extends Node2D

var DebugMenu: bool = false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("god"):
        visible = !visible

func _on_seta_pressed() -> void:
    if DebugMenu:
        DebugMenu = false
    else:
        DebugMenu = true
    debug()

func debug():
    if DebugMenu:
        $PanelIntro.play("IntroPanel")
    else:
        $PanelIntro.play_backwards("IntroPanel")
        

# -----   DEBUG   ----- #
func _on_set_money_pressed() -> void:
    var SetMoney = int($Panel/Status/SpinBoxMoney.value)
    
    $"../HUD/PGB_M".value = SetMoney
    $"../HUD/Moedas".text = str(SetMoney)

func _on_plus_pressed() -> void:
    var SetMoney = int($Panel/Status/SpinBoxMoney.value)
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual + SetMoney)

func _on_minus_pressed() -> void:
    var SetMoney = int($Panel/Status/SpinBoxMoney.value)
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    moedas.text = str(valor_atual - SetMoney)


func _on_set_lifes_pressed() -> void:
    var SetLifes = int($Panel/Status/SpinBoxLifes.value)
    
    $"../HUD/PGB_V".value = SetLifes
    $"../HUD/Vida".text = str(SetLifes)


func _on_set_round_pressed() -> void:
    var SetRound = int($Panel/Status/SpinBoxRound.value)
    
    spawner.rodada_atual = int(SetRound)
    $"../HUD/UI_Selection/n_Round".text = str(SetRound)




        
        
# -----   SPAWN DOS GHOSTLINGS   ----- #
@onready var spawner = get_tree().get_first_node_in_group("spawner")

func _on_ghostling_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghostling.instantiate())

func _on_ghazt_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghazt.instantiate())

func _on_ghoul_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghoul.instantiate())

func _on_ghaztling_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghaztling.instantiate())

func _on_ghazely_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghazely.instantiate())

func _on_enhanced_ghaztling_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Enhanced_Ghaztling.instantiate())

func _on_enhanced_ghoul_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Enhanced_Ghoul.instantiate())

func _on_unholy_phantasm_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Unholy_Phantasm.instantiate())

func _on_brute_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Brute.instantiate())

func _on_ghaztro_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Ghaztro.instantiate())

func _on_undead_ghostling_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Undead_Ghostling.instantiate())

func _on_leviathan_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Leviathan.instantiate())

func _on_azazel_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Azazel.instantiate())

func _on_belzebu_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Belzebu.instantiate())

func _on_fenrir_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Fenrir.instantiate())

func _on_lucifer_pressed() -> void:
    spawner.get_node("../Path2D").add_child(spawner.Lucifer.instantiate())






func _on_ghostlings_pressed() -> void:
    $Panel/Status.visible = false
    $Panel/Ghostlings.visible = true
    
func _on_voltar_pressed() -> void:
    $Panel/Status.visible = true
    $Panel/Ghostlings.visible = false
