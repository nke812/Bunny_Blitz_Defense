extends CharacterBody2D

@export var speed = 200
@export var vida = 15
var speed_base = 200

var goo_stun = false

func _process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 1:
        get_tree().call_group("HP", "take_dmg", 15)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu(true)
        get_parent().queue_free()
        

func DMGED(quantidade):
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    
    vida -= quantidade
    if quantidade >= 1:
        $"../AnimationPlayer".play("new_animation")

    if vida <= 0:
        $Death.play()
        $Ghaztro/Goo_Splash.visible = false
        $HitBoxGhostling.set_deferred("disabled", true)

        moedas.text = str(valor_atual + 2)
        
        
        speed = 0
        $AnimationPlayer.play("new_animation")
        $"../POP".play("default")
        
        await $AnimationPlayer.animation_finished
        $Ghaztro.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $"../POP".animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return
    var tween_B = create_tween()
    
    goo_stun = true
    $Ghaztro/Goo_Splash.visible = true
    $Ghaztro/Goo_Splash.play(cor_ataque)
    
    if cor_ataque == "Green_Goo":
        tween_B.tween_property($Ghaztro, "modulate", Color("22f367ff"), 0.3)
    if cor_ataque == "Blue_Goo":
        tween_B.tween_property($Ghaztro, "modulate", Color("47ace0ff"), 0.3)
    if cor_ataque == "Purple_Goo":
        tween_B.tween_property($Ghaztro, "modulate", Color("7e50f8ff"), 0.3)
    if cor_ataque == "Void_Goo":
        tween_B.tween_property($Ghaztro, "modulate", Color("1a2938ff"), 0.3)
    
    speed = speed / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        goo_stun = false
        $Ghaztro/Goo_Splash.play_backwards(cor_ataque)
        await $Ghaztro/Goo_Splash.animation_finished
        
        speed = speed_base
        $Ghaztro.modulate = Color(1, 1, 1, 1)


func _on_buff_body_entered(body: Node2D) -> void:
    var corpos = $Buff.get_overlapping_bodies()
    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            corpo.speed += 100 
        break


#func _on_buff_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
    #var corpos = $Buff.get_overlapping_bodies()
    #for corpo in corpos:
        #if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            #corpo.speed += 100 
        #break
#
#
#func _on_buff_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
    #var corpos = $Buff.get_overlapping_bodies()
    #for corpo in corpos:
        #if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            #corpo.speed += 100 
        #break

#func _on_buff_area_entered(area: Area2D) -> void:
    #var corpos = $Buff.get_overlapping_bodies()
    #for corpo in corpos:
        #if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            #corpo.speed += 100 
        #break
