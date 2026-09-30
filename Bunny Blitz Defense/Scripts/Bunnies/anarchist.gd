extends Node2D

@onready var anarchist: Sprite2D = $Pega/Node2D/Anarchist
@onready var anarchist_hands: AnimatedSprite2D = $Pega/Node2D/Anarchist_Animations
@onready var range_area: Area2D = $Range
@onready var collision_shape: CollisionShape2D = $Range/CollisionRange
@onready var timer: Timer = $Timer
@onready var reload_timer: Timer = $Reload
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var arrow_dps: Sprite2D = $ArrowDps

# Textura pré-carregada para evitar lag no _process
var tex_reloading = preload("res://Assets/Others/UI_Assets/AmmunitionIconReloading.png")
var tex_bunny_sel = preload("res://Assets/Bunnies/Anarchist.png")
var tex_path1_attack = preload("res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png")
var tex_path2_attack = preload("res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png")

# Referências em cache (carregadas no _ready)
var spawner_ref: Node = null
var hud_ref: Node = null

var mostrar_range: bool = false
var pronto_para_atacar: bool = false

var balas_extras: int = 0
var pente_de_balas: int = 5
var balas: int = 5

var dmg_Anarchist: int = 2
var MysticalBuff: bool = false
var posicionado: bool = false
var valor_torre: int = 500
var focus: bool = false

var path1: int = 0
var path2: int = 0
var preços_p1: Array[int] = [500, 1300, 2000, 4550]
var preços_p2: Array[int] = [500, 1300, 2000, 4550]

var P1status: String = "Damage: 2"
var P2status: String = "Reload Speed: 3s"
var BuffStatus1: String = "Mag: +0"
var BuffStatus2: String = "ATK Speed: +0s"

func _ready() -> void:
    # Guarda as referências globais uma única vez
    spawner_ref = get_tree().get_first_node_in_group("spawner")
    hud_ref = get_tree().get_first_node_in_group("HUD")
    pente_de_balas = 5 + balas_extras
    balas = pente_de_balas

func _process(delta: float) -> void:
    if not spawner_ref: return
    
    # Lógica de Recarga
    if balas <= 0:
        if focus and hud_ref:
            hud_ref.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").texture = tex_reloading
            hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = "..."
            
        if spawner_ref.ronda_a_decorrer:
            reload_timer.paused = false
            if reload_timer.is_stopped():
                reload_timer.start()
                pronto_para_atacar = false
        else:
            reload_timer.paused = true

    # Barra de progresso de recarga
    progress_bar.max_value = reload_timer.wait_time
    progress_bar.value = reload_timer.wait_time - reload_timer.time_left
    progress_bar.visible = (balas <= 0)
    
    arrow_dps.visible = focus

    # Condição para estar apto a disparar
    if timer.is_stopped() and reload_timer.is_stopped() and balas > 0 and spawner_ref.ronda_a_decorrer:
        pronto_para_atacar = true
        verificar_e_atacar()
    else:
        pronto_para_atacar = false

func verificar_e_atacar() -> void:
    var corpos = range_area.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
            break # Dispara apenas sobre o primeiro Ghostling válido encontrado

func atacar(alvo: Node) -> void:
    if not alvo.has_method("DMGED"): return
    
    $Pega/Node2D/Anarchist/AnimationPlayer.play("AttackAnarchist")
    $Shot.play()
    
    var texture_path = anarchist.texture.resource_path
    match texture_path:
        "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": 
            anarchist_hands.play("Attack")
        "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": 
            anarchist_hands.play("Attack01")
        "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": 
            anarchist_hands.play("Attack02")
            
    alvo.DMGED(dmg_Anarchist)
    pronto_para_atacar = false
    balas -= 1
    
    if focus and hud_ref:
        hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        
    timer.start()

func _on_reload_timeout() -> void:
    balas = pente_de_balas
    if focus and hud_ref:
        hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        
    $Reload2.play()
    
    var texture_path = anarchist.texture.resource_path
    match texture_path:
        "res://Assets/Bunnies/Animations/AnarchistAttackIdle.png": 
            anarchist_hands.play("Reload")
        "res://Assets/Bunnies/Animations/Paths/Anarchist01AttackIdle.png": 
            anarchist_hands.play("Reload01")
        "res://Assets/Bunnies/Animations/Paths/Anarchist02AttackIdle.png": 
            anarchist_hands.play("Reload02")
            
    pronto_para_atacar = false

func receber_buff_mystical(mystical: int) -> void:
    var atk_speed_percent = 0.0
    
    if posicionado and MysticalBuff:
        match mystical:
            0: 
                balas_extras = 1; timer.wait_time = 1.3; atk_speed_percent = 1.3
            1: 
                balas_extras = 2; timer.wait_time = 1.1; atk_speed_percent = 1.1
            2: 
                balas_extras = 3; timer.wait_time = 1.0; atk_speed_percent = 1.0
            3: 
                balas_extras = 4; timer.wait_time = 0.8; atk_speed_percent = 0.8
            4: 
                balas_extras = 5; timer.wait_time = 0.7; atk_speed_percent = 0.7
    else:
        balas_extras = 0
        timer.wait_time = 1.5
        atk_speed_percent = 0.0

    pente_de_balas = 5 + balas_extras
    balas = pente_de_balas
    
    BuffStatus1 = "Pente: +" + str(balas_extras)
    BuffStatus2 = "Atk Speed: " + str(atk_speed_percent) + "s"
    
    if focus and hud_ref:
        hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        hud_ref.get_node("HUD_Shop/BuffStatus/Buff3").text = BuffStatus1
        hud_ref.get_node("HUD_Shop/BuffStatus/Buff4").text = BuffStatus2

func _draw() -> void:
    if mostrar_range and collision_shape.shape is CircleShape2D:
        var raio_final = collision_shape.shape.radius * collision_shape.scale.x
        draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.44))

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()
    
func reset_focus() -> void:
    if hud_ref:
        hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = ""
        hud_ref.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").visible = false
        hud_ref.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
        hud_ref.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
    focus = false

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    if hud_ref:
        hud_ref.get_node("HUD_Shop/BuffStatus").visible = false
        hud_ref.abrir_menu_upgrade(self)
        
        hud_ref.get_node("HUD_Shop/HudBgDown/Status1").text = P1status
        hud_ref.get_node("HUD_Shop/HudBgDown/Status2").text = P2status
        hud_ref.get_node("HUD_Shop/HudBgDown/StatusExtra").text = str(balas)
        hud_ref.get_node("HUD_Shop/HudBgDown/AmmunitionIcon").visible = true
        
        hud_ref.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud_ref.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        
        hud_ref.get_node("HUD_Shop/HudBgDown/BunnySel").texture = tex_bunny_sel
        atualizar_valorTorre()
        
        if MysticalBuff:
            hud_ref.get_node("HUD_Shop/BuffStatus/Buff3").text = BuffStatus1
            hud_ref.get_node("HUD_Shop/BuffStatus/Buff4").text = BuffStatus2
            hud_ref.get_node("HUD_Shop/BuffStatus").visible = true
        
        hud_ref.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud_ref.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")

func aplicar_upgrade(caminho: int) -> bool:
    if not hud_ref: return false
    
    var label_moedas = hud_ref.get_node("Moedas")
    var dinheiro_atual = int(label_moedas.text)

    var lista_precos = preços_p1 if caminho == 1 else preços_p2
    var nivel_atual = path1 if caminho == 1 else path2

    if nivel_atual >= lista_precos.size(): return false

    var custo = lista_precos[nivel_atual]

    if dinheiro_atual >= custo:
        dinheiro_atual -= custo
        label_moedas.text = str(dinheiro_atual)
    
        if caminho == 1:
            path1 += 1
            match path1:
                1: dmg_Anarchist = 4; pente_de_balas += 2; valor_torre += 500
                2: dmg_Anarchist = 7; pente_de_balas += 2; valor_torre += 1300
                3: dmg_Anarchist = 12; pente_de_balas += 2; valor_torre += 2000
                4: 
                    dmg_Anarchist = 17; pente_de_balas += 5; valor_torre += 4550
                    auraMAISego()
                    anarchist.texture = tex_path1_attack
                    anarchist_hands.animation = "Attack01"
                        
            P1status = "Damage: " + str(dmg_Anarchist)
            hud_ref.get_node("HUD_Shop/HudBgDown/Status1").text = P1status
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: reload_timer.wait_time = 2.5; pente_de_balas += 2; valor_torre += 500
                2: reload_timer.wait_time = 2.1; pente_de_balas += 2; valor_torre += 1300
                3: reload_timer.wait_time = 1.7; pente_de_balas += 2; valor_torre += 2000
                4: 
                    reload_timer.wait_time = 1.0; pente_de_balas += 5; valor_torre += 4550
                    auraMAISego()
                    anarchist.texture = tex_path2_attack
                    anarchist_hands.animation = "Attack02"
                    
            P2status = "Reload Speed: " + str(reload_timer.wait_time) + "s"
            hud_ref.get_node("HUD_Shop/HudBgDown/Status2").text = P2status
            atualizar_valorTorre()
        return true
    return false
    
func auraMAISego() -> void:
    anarchist.modulate = Color(1, 1, 1)
    anarchist_hands.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property(anarchist, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property(anarchist_hands, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(anarchist, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property(anarchist_hands, "modulate", Color(1, 1, 1, 1), 0.4)

func atualizar_valorTorre() -> void:
    if not hud_ref: return
    var valor_torre_60: int = int(valor_torre * 0.6)
    hud_ref.get_node("HUD_Shop/HudBgDown/Control/PanelSell/precoSell").text = str(valor_torre_60)

func vender_torre() -> void:
    var moedas = get_tree().current_scene.find_child("Moedas")
    if moedas:
        var valor_atual = int(moedas.text)
        var valor_torre_60: int = int(valor_torre * 0.6)
        moedas.text = str(valor_atual + valor_torre_60)
    
    queue_free()
