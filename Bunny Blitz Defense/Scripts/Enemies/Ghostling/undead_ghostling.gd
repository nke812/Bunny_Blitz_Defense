extends CharacterBody2D

@export var speed = 210
@export var vida = 10
var speed_base = 210
var stunned = false

var goo_stun = false


func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 1:
        get_tree().call_group("HP", "take_dmg", 7)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu(true)
        get_parent().queue_free()

func DMGED(quantidade):
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)


    if stunned:
        $AnimationPlayer.play("new_animation")
        vida -= quantidade
        moedas.text = str(valor_atual + quantidade)

        if vida <= 0:
            $Death.play()
            $UndeadGhostling/Goo_Splash.visible = false
            $HitBoxGhostling.disabled = true
            moedas.text = str(valor_atual + 20)


            speed = 0
            $AnimationPlayer.play("new_animation")
            $"../POP".play("default")
        
            await $AnimationPlayer.animation_finished
            $Ghostling.modulate = Color(0.957, 0.478, 0.965, 0.0)
            
            await $"../POP".animation_finished

            var spawner_no = get_tree().get_first_node_in_group("spawner")
            spawner_no.inimigo_morreu()

            get_parent().queue_free()
    else:
        pass

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    stunned = true
    $UndeadGhostling/Goo_Splash.visible = true
    $UndeadGhostling/Goo_Splash.play(cor_ataque)
    
    var tween_B = create_tween()
    
    if cor_ataque == "Green_Goo":
        tween_B.tween_property($UndeadGhostling, "modulate", Color("22f367ff"), 0.3)
    if cor_ataque == "Blue_Goo":
        tween_B.tween_property($UndeadGhostling, "modulate", Color("47ace0ff"), 0.3)
    if cor_ataque == "Purple_Goo":
        tween_B.tween_property($UndeadGhostling, "modulate", Color("7e50f8ff"), 0.3)
    if cor_ataque == "Void_Goo":
        tween_B.tween_property($UndeadGhostling, "modulate", Color("1a2938ff"), 0.3)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $UndeadGhostling/Goo_Splash.play_backwards(cor_ataque)
        speed = speed_base
        $UndeadGhostling.modulate = Color(1, 1, 1, 1)
        
        stunned = false
        goo_stun = false
