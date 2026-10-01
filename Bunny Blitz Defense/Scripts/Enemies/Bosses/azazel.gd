extends CharacterBody2D

@export var speed = 150
@export var vida = 350
var speed_base = 150


var goo_stun = false


func _physics_process(delta):
    var pf = get_parent() as PathFollow2D
    pf.progress += speed * delta

    if $"..".progress_ratio >= 0.99:
        get_tree().call_group("HP", "take_dmg", 200)

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()
        get_parent().queue_free()

func DMGED(quantidade):
    var moedas = get_tree().current_scene.find_child("Moedas")

    vida -= quantidade
    atualizar_barra()
    $"../dmg".play("dmg")

    
    if vida <= 50:
        $Azazel.texture = load("res://Assets/Enemies/Bosses/AzazelDamaged.png")

    if vida <= 0:
        $Death.play()
        $Azazel/Goo_Splash.visible = false
        $HitBoxBoss.set_deferred("disabled", true)
        
        
        var novo_total = int(moedas.text)
        moedas.text = str(novo_total + 350)
        speed = 0
        $"../dmg".play("dmg")
        $POP.play("default")
        
        await $"../dmg".animation_finished
        $Azazel.modulate = Color(0.957, 0.478, 0.965, 0.0)
        
        await $POP.animation_finished

        var spawner_no = get_tree().get_first_node_in_group("spawner")
        spawner_no.inimigo_morreu()

        get_parent().queue_free()
        
func atualizar_barra():
    $"../BossHP".value = vida
    
    if $"../BossHP".visible == false:
        $"../BossHP".visible = true
        

func gooey_stun(TimeSlimed: float, cor_ataque: String):
    if goo_stun: return 
    
    goo_stun = true
    $Azazel/Goo_Splash.visible = true
    $Azazel/Goo_Splash.play(cor_ataque)
    
    speed = speed_base / 3

    await get_tree().create_timer(TimeSlimed).timeout
    
    if is_instance_valid(self):
        $Azazel/Goo_Splash.play_backwards(cor_ataque)
        speed = speed_base
        goo_stun = false
