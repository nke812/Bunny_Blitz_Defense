extends Node2D

@onready var Rookie = $Pega/Node2D/Rookie
@onready var RookieHands = $Pega/Node2D/RookieHands_Attack

var skin = false
var valor_torre = 115

var MysticalBuff = false
var posicionado = false

var mostrar_range = false
var pronto_para_atacar = false

var dmg_Mystical = 0
var dmg_Rookie = 1
var dmg_total = dmg_Rookie + dmg_Mystical

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [140, 425, 2400, 5500]
var preços_p2 = [140, 425, 2400, 5500]

var P1status = "Damage: " + str(dmg_Rookie)
var P2status = "ATK Speed: 1s"
var BuffStatus1 = "DMG: +0"
var BuffStatus2 = "Range: 1.0"

func _ready() -> void:
    posicionado = true

func _process(_delta: float) -> void: 
    if focus:
        if has_node("ArrowDps"): $ArrowDps.visible = true
    else:
        if has_node("ArrowDps"): $ArrowDps.visible = false

    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            atacar(corpo)
            break

func atacar(alvo):
    if is_instance_valid(alvo) and alvo.has_method("DMGED"):
        $Pega/Node2D/Rookie/AnimationPlayer.play("RookieAttack")
        $Pega/Node2D/RookieHands_Attack.play()
        
        var sons_hit = [$Hit, $Hit2, $Hit3]
        var som_sorteado = sons_hit[randi() % sons_hit.size()]
        som_sorteado.play()
        
        alvo.DMGED(dmg_total)
        pronto_para_atacar = false
        $Timer.start()

# --- Comunicação com a Mystical ---

func receber_buff_mystical(nivel_mystical: int):
    MysticalBuff = true
    var dmg_buff = 0
    var scale_buff = Vector2(1.0, 1.0) 

    match nivel_mystical:
        0: dmg_buff = 1; scale_buff = Vector2(1.1, 1.1)
        1: dmg_buff = 2; scale_buff = Vector2(1.2, 1.2)
        2: dmg_buff = 3; scale_buff = Vector2(1.3, 1.3)
        3: dmg_buff = 4; scale_buff = Vector2(1.4, 1.4)
        4: dmg_buff = 5; scale_buff = Vector2(1.5, 1.5)
        _: dmg_buff = 1; scale_buff = Vector2(1.1, 1.1)

    dmg_Mystical = dmg_buff
    $Range/CollisionRange.scale = scale_buff
    
    dmg_total = dmg_Rookie + dmg_Mystical
    P1status = "Damage: " + str(dmg_total)
    
    BuffStatus1 = "Dmg: +" + str(dmg_Mystical)
    BuffStatus2 = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))

    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/BuffStatus").visible = true

func remover_buff_mystical():
    MysticalBuff = false
    dmg_Mystical = 0
    $Range/CollisionRange.scale = Vector2(1.0, 1.0)
    dmg_total = dmg_Rookie
    P1status = "Damage: " + str(dmg_total)
    BuffStatus1 = "DMG: +0"
    BuffStatus2 = "Range: 1.0"
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/BuffStatus").visible = false

# --- UI e Upgrades ---

func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false
    if has_node("ArrowDps"): $ArrowDps.visible = false

func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    
    var texture = Rookie.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Animations/RookieAttackIdle.png":
            Rookie.texture = load("res://Assets/Bunnies/Skins/buny.png")
            RookieHands.animation = "RookieSkin"
        "res://Assets/Bunnies/Skins/buny.png":
            Rookie.texture = load("res://Assets/Bunnies/Animations/RookieAttackIdle.png")
            RookieHands.animation = "Rookie"
        "res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png":
            Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny01.png")
            RookieHands.animation = "RookieSkin01"
        "res://Assets/Bunnies/Skins/Paths/buny01.png":
            Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
            RookieHands.animation = "Rookie01"
        "res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png":
            Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny02.png")
            RookieHands.animation = "RookieSkin02"
        "res://Assets/Bunnies/Skins/Paths/buny02.png":
            Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
            RookieHands.animation = "Rookie02"

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        
        P1status = "Damage: " + str(dmg_total)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        if not SaveManager.bunyUnlocked:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        else:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Rookie.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        
        if MysticalBuff:
            BuffStatus1 = "Dmg: +" + str(dmg_Mystical)
            BuffStatus2 = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
            hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            hud.get_node("HUD_Shop/BuffStatus").visible = true
        
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")

func aplicar_upgrade(caminho):
    var hud = get_tree().get_first_node_in_group("HUD")
    if not hud: return false
    
    var label_moedas = hud.get_node("Moedas")
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
                1: dmg_Rookie = 4; valor_torre += 140
                2: dmg_Rookie = 6; valor_torre += 425
                3: dmg_Rookie = 10; valor_torre += 2400
                4: 
                    dmg_Rookie = 15; valor_torre += 5500
                    auraMAISego()
                    if skin:
                        Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny01.png")
                        RookieHands.animation = "RookieSkin01"
                    else:
                        Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie01AttackIdle.png")
                        RookieHands.animation = "Rookie01"
            
            dmg_total = dmg_Rookie + dmg_Mystical
            P1status = "Damage: " + str(dmg_total)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: $Timer.wait_time = 0.8; valor_torre += 140
                2: $Timer.wait_time = 0.6; valor_torre += 425
                3: $Timer.wait_time = 0.4; valor_torre += 2400
                4: 
                    $Timer.wait_time = 0.2; valor_torre += 5500
                    auraMAISego()
                    if skin:
                        Rookie.texture = load("res://Assets/Bunnies/Skins/Paths/buny02.png")
                        RookieHands.animation = "RookieSkin02"
                    else:
                        Rookie.texture = load("res://Assets/Bunnies/Animations/Paths/Rookie02AttackIdle.png")
                        RookieHands.animation = "Rookie02"
                    
            P2status = "ATK Speed: " + str($Timer.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            atualizar_valorTorre()
            
        return true 
    return false 

func auraMAISego():
    Rookie.modulate = Color(1, 1, 1)
    RookieHands.modulate = Color(1, 1, 1)
    if has_node("AURA"): $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property(Rookie, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property(RookieHands, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Rookie, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property(RookieHands, "modulate", Color(1, 1, 1, 1), 0.4)

func atualizar_valorTorre():
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        var valor_torre_60 : int = int(valor_torre * 0.6)
        hud.get_node("HUD_Shop/HudBgDown/Control/PanelSell/precoSell").text = str(valor_torre_60)

func vender_torre():
    var moedas = get_tree().current_scene.find_child("Moedas")
    if moedas:
        var valor_atual = int(moedas.text)
        var valor_torre_60 : int = int(valor_torre * 0.6)
        moedas.text = str(valor_atual + valor_torre_60)
    
    remover_buff_mystical()
    queue_free()
