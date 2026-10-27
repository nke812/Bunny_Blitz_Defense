extends Node2D

func _process(_delta: float) -> void :

    $Bushes/Bush01/Rookienho/AnimRookienho.speed_scale = 1 / Engine.time_scale

    # Puxa a lista dos inimigos normais e a lista dos bosses separadamente
    var normais = get_tree().get_nodes_in_group("Ghostlings")
    var bosses = get_tree().get_nodes_in_group("Bosses")

    var all_ghoztlings = normais + bosses
    
    

    for ghostling in all_ghoztlings:

        var o_pai = ghostling.get_parent()
        var goo = ghostling.get_node_or_null("Goo_Splash") # Usa get_node_or_null para não mandar erro logo aqui
 
        if o_pai is PathFollow2D:

           if o_pai.progress_ratio >= 0.6425 and o_pai.progress_ratio <= 0.7671:
              ghostling.modulate.a = 0.1
              if goo: goo.modulate.a = 0.1 # Só mexe na opacidade se o goo existir!

              ghostling.set_deferred("collision_layer", 0)
              ghostling.set_deferred("collision_mask", 0)
           else:
              ghostling.modulate.a = 1.0
              if goo: goo.modulate.a = 1.0 # Só mexe na opacidade se o goo existir!
        
              ghostling.set_deferred("collision_layer", 1)
              ghostling.set_deferred("collision_mask", 1)


func _on_button_pressed() -> void:
    var hud = get_tree().get_first_node_in_group("HUD")
    
    if PlayerAchievements.ALittleTinyBunny == 0:
        PlayerAchievements.ALittleTinyBunny = 1
        PlayerAchievements.guardar_dados()
        hud.anim()
    $Sign/Button.disabled = true
    $Bushes/Bush01/Rookienho/AnimRookienho.play("AnimRookienho")
