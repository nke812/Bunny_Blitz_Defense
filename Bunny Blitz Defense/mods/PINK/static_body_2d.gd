extends CharacterBody2D

var posicionado = false
var mostrar_range = false
var esta_a_atacar = false

var tamanho_range = Vector2(1.0, 1.0)

var pink_ult = 3
var pink_mega_ult = 5

func _ready() -> void:
    ultslabel()
    anim_idle()
    
func ultslabel():
    $Node2D/Ult.text = str(pink_ult) + "/7"
    $Node2D/UltraUlt.text = str(pink_mega_ult) + "/20"
    
func _process(_delta: float) -> void: 
    
    $AnimationPlayer.speed_scale = 1 / Engine.time_scale
    $Node2D/PINK.speed_scale = 1 / Engine.time_scale
    $Node2D/PINK/AnimationPlayer.speed_scale = 1 / Engine.time_scale
    
    if esta_a_atacar:
        return
        
    if not $Timer.is_stopped():
        return

    if $Node2D/Range.monitoring:
        if pink_ult >= 7:
            verificar_e_atacar_ult()
        else:
            verificar_e_atacar()


# --- ATAQUE NORMAL ---
func verificar_e_atacar():
    
    var corpos = $Node2D/Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            esta_a_atacar = true
            atacar(corpo)
            break

func atacar(alvo):
    anim_atacar()
    $Node2D/PINK.play("PreAttack")
    await $Node2D/PINK.animation_finished
    
    # 🛡️ VERIFICAÇÃO DE SEGURANÇA: O alvo ainda existe/está vivo?
    if not is_instance_valid(alvo):
        # Se o inimigo morreu durante o PreAttack, cancela o ataque e volta ao normal!
        anim_idle()
        esta_a_atacar = false
        return

    # Se chegou aqui, o alvo ainda está vivo!
    if alvo.has_method("DMGED"):
        $Node2D/PINK.play("Attack")
        alvo.DMGED(5)
        pink_ult += 1
        ultslabel()
        await $Node2D/PINK.animation_finished
    
    anim_idle()
    
    $Timer.start()
    esta_a_atacar = false


# --- ATAQUE DA ULT (AoE) ---
func verificar_e_atacar_ult():
    var corpos = $Node2D/Range.get_overlapping_bodies()
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
    $Node2D/PINK.play("PreAttackUlt")
    await $Node2D/PINK.animation_finished
    
    $Node2D/PINK.play("AttackUlt")

    var corpos_atuais = $Node2D/Range.get_overlapping_bodies()
    
    for corpo in corpos_atuais:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings") and corpo.has_method("DMGED"):
            corpo.DMGED(15)
            
    await $Node2D/PINK.animation_finished
    anim_idle()
    
    pink_ult = 0 
    pink_mega_ult += 5
    ultslabel()
    varificar_mega_ult()
    
    $Timer.start()
    esta_a_atacar = false
    
    

# --- AÇÃO DO BOTÃO ---
func _on_button_pressed() -> void:
    var Map3Music = get_tree().current_scene.find_child("Map3Music", true, false)
    
    $AnimationPlayer.play("PinkCutscene")
    Map3Music.stop()
    $"MUSICA-FODA-PRA-CRLH".play()
    $Button.disabled = true

    await $"MUSICA-FODA-PRA-CRLH".finished
    $MAGICMEWMEWCUTIE.play()
    $MAGICMEWMEWCUTIELYRICS.play()
    
    await $AnimationPlayer.animation_finished
    $Node2D/pink.disabled = false
    $Node2D.CanMove = true


# --- ANIMAÇÕES E POSIÇÕES ---
func anim_idle():
    $Timer.start()
    $Node2D/PINK.position = Vector2(0, 0)
    $Node2D/PINK.play("Idle")
    
func anim_atacar():
    $Node2D/PINK.position = Vector2(15, -49)
   
func anim_atacar_ult():
    $Node2D/PINK.position = Vector2(-15, -99)


# --- ANIMAÇÕES CUTSCENE (Call Method Track) ---
func FootSlam():
    $Node2D/PINK.play("FootSlam")
    $foot.play()

func Kick():
    $Node2D/PINK.play("Kick")
    $kick.play()

func Laugh():
    $Node2D/PINK.play("Laugh")
    $laugh.play()

func Push():
    $Node2D/PINK.play("Push")

func Running():
    $Node2D/PINK.play("Running")
    $running.play()

func AttackUltraUlt():
    $Timer.stop()
    $Node2D/PINK.play("AttackUltraUlt")
    $laugh.play()
    $Node2D/PINK.position = Vector2(13, -111)

func Release():
    $attackUlt.play()
    $Node2D/PINK.play("Release")

func Exploded():
    $Node2D/PINK.position = Vector2(0, 0)
    $Node2D/PINK.play("Exploded")
    $running.play()

func ExplodedClean():
    $kick.play()
    $Node2D/PINK.position = Vector2(0, 0)
    $Node2D/PINK.play("ExplodedClean")
    varificar_mega_ult()
    $Node2D.CanMove = true

func EXPLOSION():
    $EXPLOSION.play("default")
    $EXPLOSION/AudioStreamPlayer.play()  
func EXPLOSION2():
    $EXPLOSION2.play("default")
    $EXPLOSION/AudioStreamPlayer.play()



func dar_dano_global() -> void:
    # Procura todos os nós vivos no grupo "inimigos"
    var Ghostlings = get_tree().get_nodes_in_group("Ghostlings")
    
    for Ghostling in Ghostlings:
        if Ghostling.has_method("DMGED"):
            Ghostling.DMGED(60)



## --- DESENHAR RANGE ---
func _draw() -> void:
    if mostrar_range:
        var shape = $Node2D/Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Node2D/Range/CollisionRange.scale.x * $Node2D/Range.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_pink_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_pink_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()


func varificar_mega_ult():
    if pink_mega_ult >= 20 and $ULTRAULT.disabled:
        $ULTRAULT.disabled = false
        $UltraUltReady.play()
        $ULTRAULT/AnimationPlayer.play("bounce")
    

func _on_ultrault_pressed() -> void:
    if pink_mega_ult >= 20 and $ULTRAULT.disabled == false:
        $Node2D.CanMove = false
        $AnimationPlayer.play("UltraUlt")
        $ULTRAULT.disabled = true
        $ULTRAULT/AnimationPlayer.play("RESET")
        pink_mega_ult -= 20
        ultslabel()


func musics() -> void:
    if $MAGICMEWMEWCUTIE.volume_db == 0:
        # Se a instrumental está a ditar, passa para os lyrics
        $MAGICMEWMEWCUTIE.volume_db = -80
        $MAGICMEWMEWCUTIELYRICS.volume_db = 0
    else:
        # Caso contrário, volta para a instrumental
        $MAGICMEWMEWCUTIE.volume_db = 0
        $MAGICMEWMEWCUTIELYRICS.volume_db = -80
        
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_SPACE:
            _on_ultrault_pressed()
        
        # Tecla Shift (deteta tanto o Shift Esquerdo como o Direito)
        if event.keycode == KEY_SHIFT:
            musics()
