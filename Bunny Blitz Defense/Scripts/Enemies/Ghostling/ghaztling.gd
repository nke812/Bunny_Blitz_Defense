extends CharacterBody2D

@export var speed_base = 550
@export var speed = 550
@export var vida = 1

var goo_stun = false


func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 1:
        get_tree().call_group("HP", "take_dmg", 3)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu(true)
        get_parent().queue_free()

func DMGED(quantidade):
    vida -= quantidade

    if vida <= 0:
        $Death.play()
        $"../Goo_Splash".visible = false
        $HitBoxGhostling.disabled = true
        
        var moedas = get_tree().current_scene.find_child("Moedas")
        var valor_atual = int(moedas.text)
        moedas.text = str(valor_atual + 2)

        speed = 0
        $AnimationPlayer.play("Animations/ghostling_TakeDMG")
        $"../POP".play("default")
        
        await $AnimationPlayer.animation_finished
        $Ghostling.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $"../POP".animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    $"../Goo_Splash".visible = true
    $"../Goo_Splash".play(cor_ataque)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $"../Goo_Splash".play_backwards(cor_ataque)
        speed = speed_base
        goo_stun = false
