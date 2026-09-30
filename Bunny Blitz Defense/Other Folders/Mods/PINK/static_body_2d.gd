extends Node2D

var posicionado = false
var mostrar_range = false
var esta_a_atacar = false

# Renomeado para evitar conflito com a função reservada range() do GDScript
var tamanho_range = Vector2(1.0, 1.0)

var pink_ult = 3
var pink_mega_ult = 0

func _ready() -> void:
    anim_idle()

func _process(_delta: float) -> void: 
    
    $AnimationPlayer.speed_scale = 1 / Engine.time_scale
    $PINK.speed_scale = 1 / Engine.time_scale
    
    if esta_a_atacar:
        return
        
    if not $Timer.is_stopped():
        return

    if $Range.monitoring:
        if pink_ult >= 7:
            verificar_e_atacar_ult()
        else:
            verificar_e_atacar()


# --- ATAQUE NORMAL ---
func verificar_e_atacar():
    
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            esta_a_atacar = true
            atacar(corpo)
            break

func atacar(alvo):
    anim_atacar()
    $PINK.play("PreAttack")
    await $PINK.animation_finished
    
    # 🛡️ VERIFICAÇÃO DE SEGURANÇA: O alvo ainda existe/está vivo?
    if not is_instance_valid(alvo):
        # Se o inimigo morreu durante o PreAttack, cancela o ataque e volta ao normal!
        anim_idle()
        esta_a_atacar = false
        return

    # Se chegou aqui, o alvo ainda está vivo!
    if alvo.has_method("DMGED"):
        $PINK.play("Attack")
        alvo.DMGED(5)
        pink_ult += 1
        await $PINK.animation_finished
    
    anim_idle()
    
    print("Cargas Ult: ", pink_ult)
    
    $Timer.start()
    esta_a_atacar = false


# --- ATAQUE DA ULT (AoE) ---
func verificar_e_atacar_ult():
    var corpos = $Range.get_overlapping_bodies()
    var tem_alvos = false
    
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            tem_alvos = true
            break
            
    if tem_alvos:
        esta_a_atacar = true
        atacar_ult(corpos)

func atacar_ult(corpos):
    anim_atacar_ult()
    $attackUlt.play()
    $PINK.play("PreAttackUlt")
    await $PINK.animation_finished
    
    $PINK.play("AttackUlt")

    var corpos_atuais = $Range.get_overlapping_bodies()
    
    for corpo in corpos_atuais:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings") and corpo.has_method("DMGED"):
            corpo.DMGED(15)
            
    await $PINK.animation_finished
    anim_idle()
    
    pink_ult = 0 
    pink_mega_ult += 5
    varificar_mega_ult()
    
    $Timer.start()
    esta_a_atacar = false
    
    

# --- AÇÃO DO BOTÃO ---
func _on_button_pressed() -> void:
    $AnimationPlayer.play("PinkCutscene")
    $"../Map3Music".stop()
    $"MUSICA-FODA-PRA-CRLH".play()
    $Button.disabled = true

    await $"MUSICA-FODA-PRA-CRLH".finished
    $MAGICMEWMEWCUTIE.play()

    await $AnimationPlayer.animation_finished
    $pink.disabled = false


# --- ANIMAÇÕES E POSIÇÕES ---
func anim_idle():
    $Timer.start()
    $PINK.position = Vector2(0, 0)
    $PINK.play("Idle")
    
func anim_atacar():
    $PINK.position = Vector2(15, -49)
   
func anim_atacar_ult():
    $PINK.position = Vector2(-15, -99)


# --- ANIMAÇÕES CUTSCENE (Call Method Track) ---
func FootSlam():
    $PINK.play("FootSlam")
    $foot.play()

func Kick():
    $PINK.play("Kick")
    $kick.play()

func Laugh():
    $PINK.play("Laugh")
    $laugh.play()

func Push():
    $PINK.play("Push")

func Running():
    $PINK.play("Running")
    $running.play()

func AttackUltraUlt():
    $Timer.stop()
    $PINK.play("AttackUltraUlt")
    $laugh.play()
    $PINK.position = Vector2(13, -111)

func Release():
    $attackUlt.play()
    $PINK.play("Release")

func Exploded():
    $PINK.position = Vector2(0, 0)
    $PINK.play("Exploded")
    $running.play()

func ExplodedClean():
    $kick.play()
    $PINK.position = Vector2(0, 0)
    $PINK.play("ExplodedClean")

func EXPLOSION():
    $EXPLOSION.play("default")
    $EXPLOSION/AudioStreamPlayer.play()  
func EXPLOSION2():
    $"../EXPLOSION2".play("default")
    $EXPLOSION/AudioStreamPlayer.play()



func dar_dano_global() -> void:
    # Procura todos os nós vivos no grupo "inimigos"
    var Ghostlings = get_tree().get_nodes_in_group("Ghostlings")
    
    for Ghostling in Ghostlings:
        if Ghostling.has_method("DMGED"):
            Ghostling.DMGED(60)



# --- DESENHAR RANGE ---
func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x * $Range.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_pink_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_pink_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()


func varificar_mega_ult():
    if pink_mega_ult == 20:
        $"../ULTRAULT".disabled = false
        $UltraUltReady.play()
        $"../ULTRAULT/AnimationPlayer".play("bounce")
        

func _on_ultrault_pressed() -> void: 
    $AnimationPlayer.play("UltraUlt")
    $"../ULTRAULT".disabled = true
    $"../ULTRAULT/AnimationPlayer".play("RESET")
    pink_mega_ult = 0
