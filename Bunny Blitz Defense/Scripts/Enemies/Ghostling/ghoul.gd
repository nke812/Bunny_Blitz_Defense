extends CharacterBody2D

@export var speed = 235
@export var vida = 3
var speed_base = 235

var goo_stun = false


func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta


    if $"..".progress_ratio >= 0.99:
        get_tree().call_group("HP", "take_dmg", 3)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()
        get_parent().queue_free()

func DMGED(quantidade):
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)

    vida -= quantidade
    $AnimationPlayer.play("Animations/ghostling_TakeDMG")

    if vida <= 0:
        $Death.play()
        $"../Goo_Splash".visible = false
        $HitBoxGhostling.set_deferred("disabled", true)
        
        var novo_total = int(moedas.text)
        moedas.text = str(novo_total + 6)

        speed = 0
        $AnimationPlayer.play("Animations/ghostling_TakeDMG")
        $"../POP".play("default")
        
        await $AnimationPlayer.animation_finished
        $Ghoul.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $"../POP".animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    $"../Goo_Splash".visible = true
    $"../Goo_Splash".play(cor_ataque)
    
    var tween_B = create_tween()
    
    if cor_ataque == "Green_Goo":
        tween_B.tween_property($Ghoul, "modulate", Color("22f367ff"), 0.3)
    if cor_ataque == "Blue_Goo":
        tween_B.tween_property($Ghoul, "modulate", Color("47ace0ff"), 0.3)
    if cor_ataque == "Purple_Goo":
        tween_B.tween_property($Ghoul, "modulate", Color("7e50f8ff"), 0.3)
    if cor_ataque == "Void_Goo":
        tween_B.tween_property($Ghoul, "modulate", Color("1a2938ff"), 0.3)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $"../Goo_Splash".play_backwards(cor_ataque)
        speed = speed_base
        $Ghoul.modulate = Color(1, 1, 1, 1)
        goo_stun = false

func aplicar_knockback(distancia: float) -> void:
    var pai = get_parent()
    if pai is PathFollow2D:
        var progresso_alvo = pai.progress - (distancia * 30)
        
        if progresso_alvo < 0:
            progresso_alvo = 0
            
        var tween_A = create_tween()   
        tween_A.tween_property($Ghoul, "modulate", Color(2.0, 2.0, 0.289, 1.0), 0.3)
        tween_A.tween_property($Ghoul, "modulate", Color(1, 1, 1, 1), 0.4)
        speed = speed_base / 10
        
        var tween_recuo = create_tween()
        if tween_recuo:
            tween_recuo.set_trans(Tween.TRANS_QUAD)
            tween_recuo.set_ease(Tween.EASE_OUT)
            
            
            tween_recuo.tween_property(pai, "progress", progresso_alvo, 0.3)
            
            await tween_recuo.finished
        
        await get_tree().create_timer(0.2).timeout
        
        var tween_velocidade = create_tween()
        if tween_velocidade:
            tween_velocidade.set_trans(Tween.TRANS_SINE)
            tween_velocidade.set_ease(Tween.EASE_IN_OUT)
            tween_velocidade.tween_property(self, "speed", speed_base, 0.8)
