extends Node2D

@onready var Scrappy = $Pega/Scrappy

var mostrar_range = false
var pronto_para_atacar = false
var focus = false

var posicionado = false
var MysticalBuff = false
var valor_torre = 330

var path1 = 0
var path2 = 0

var preços_p1 = [250, 600, 2800, 7000]
var preços_p2 = [250, 600, 2800, 7000]

var distancias_knockback = [1.0, 3.0, 5.0, 7.5, 10.0]
var alvos_cadeia = [2, 5, 7, 10, 15]
var dmg_Scrappy = 0

var BuffStatus1 = "DMG: +0"

var P1status = "Knockback: " + str(distancias_knockback[0])
var P2status = "Target Amount: " + str(alvos_cadeia[0])

func _ready() -> void:
    posicionado = true

func _process(_delta: float) -> void:
    if focus:
        if has_node("ArrowStun"): $ArrowStun.visible = true
    else:
        if has_node("ArrowStun"): $ArrowStun.visible = false
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    var inimigos_validos = []

    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            if corpo.has_method("DMGED"):
                inimigos_validos.append(corpo)

    if inimigos_validos.size() == 0:
        return

    var quantidade_maxima = alvos_cadeia[path2]
    var alvos_atingidos = []

    for i in range(min(quantidade_maxima, inimigos_validos.size())):
        alvos_atingidos.append(inimigos_validos[i])

    atacar_em_cadeia(alvos_atingidos)

func atacar_em_cadeia(alvos):
    $Pega/Scrappy/AnimationPlayer.play("scrppy_Attack")
    $Attack.play()
    var forca_knockback = distancias_knockback[path1]

    for inimigo in alvos:
        if is_instance_valid(inimigo):
            if inimigo.has_method("aplicar_knockback"):
                inimigo.aplicar_knockback(forca_knockback)
            inimigo.DMGED(dmg_Scrappy) 

    pronto_para_atacar = false
    $Timer.start()

# --- Comunicação com a Mystical ---

func receber_buff_mystical(nivel_mystical: int):
    MysticalBuff = true
    
    match nivel_mystical:
        0: dmg_Scrappy = 1
        1: dmg_Scrappy = 2
        2: dmg_Scrappy = 3
        3: dmg_Scrappy = 4
        4: dmg_Scrappy = 5
        _: dmg_Scrappy = 1

    BuffStatus1 = "Dmg: +" + str(dmg_Scrappy)
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = ""
        hud.get_node("HUD_Shop/BuffStatus").visible = true

func remover_buff_mystical():
    MysticalBuff = false
    dmg_Scrappy = 0
    BuffStatus1 = "DMG: +0"
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/BuffStatus").visible = false

# --- UI e Upgrades ---

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Scrappy.png")
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        atualizar_valorTorre()
        
        if MysticalBuff:
            hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            hud.get_node("HUD_Shop/BuffStatus/Buff4").text = ""
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
                1: valor_torre += 250
                2: valor_torre += 600
                3: valor_torre += 2800
                4: 
                    valor_torre += 7000
                    auraMAISego()
                    Scrappy.texture = load("res://Assets/Bunnies/Paths/Scrappy01.png")

            P1status = "Knockback: " + str(distancias_knockback[path1])
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: valor_torre += 250
                2: valor_torre += 600        
                3: valor_torre += 2800
                4: 
                    valor_torre += 7000
                    auraMAISego()
                    Scrappy.texture = load("res://Assets/Bunnies/Paths/Scrappy02.png")
                        
            P2status = "Chain Targets: " + str(alvos_cadeia[path2])
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            atualizar_valorTorre()
            
        return true
    return false

func auraMAISego():
    Scrappy.modulate = Color(1, 1, 1)
    if has_node("AURA"): $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property(Scrappy, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Scrappy, "modulate", Color(1, 1, 1, 1), 0.4)

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
    if has_node("ArrowStun"): $ArrowStun.visible = false
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false

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
