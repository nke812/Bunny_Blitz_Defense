extends Node2D

@onready var Doll = $Pega/Node2D/Doll

var valor_torre = 680

var MysticalBuff = false
var posicionado = false

var mostrar_range = false
var pronto_para_atacar = false

var dmg_Doll = 2.0
var targets = 2

# --- Variáveis do Buff da Mystical ---
var fontes_mystical: Dictionary = {} # Guarda { nó_mystical: nivel }
var range_buff_val: float = 0.0
var dmg_Mystical: float = 0.0

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [250, 420, 990, 2550]
var preços_p2 = [470, 730, 1470, 3450]

var P1status = "Damage: " + str(dmg_Doll)
var P2status = "Max Targets: " + str(targets)
var BuffStatus1 = "DMG: +0"
var BuffStatus2 = "Range: +0"

var alvos_atuais: Array = []


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
    var Ghostlings = []

    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            if corpo.has_method("DMGED"):
                Ghostlings.append(corpo)

    if Ghostlings.size() == 0:
        return

    var MaxTargets = targets
    alvos_atuais.clear()

    for i in range(min(MaxTargets, Ghostlings.size())):
        alvos_atuais.append(Ghostlings[i])
        
    if has_node("Pega/Node2D/Doll/DollAttack"):
        $Pega/Node2D/Doll/DollAttack.play("DollAttack")


func atacar():
    var dmg_total = dmg_Doll + dmg_Mystical
    for alvo in alvos_atuais:
        if is_instance_valid(alvo) and alvo.has_method("DMGED"):
            alvo.DMGED(dmg_total)
            
    alvos_atuais.clear()
    pronto_para_atacar = false
    $Timer.start()


func playSqueak():
    if has_node("DollSqueak"):
        $DollSqueak.pitch_scale = 1 + randf_range(-0.1, 0.1)
        $DollSqueak.play()


# --- Comunicação com a Mystical (Multi-Buff por Dicionário) ---

func receber_buff_mystical(arg1, arg2: int = -1):
    var fonte: Node = null
    var nivel_mystical: int = 0
    
    # Se a Mystical passou (self, nivel) -> 2 argumentos
    if arg1 is Node and arg2 != -1:
        fonte = arg1
        nivel_mystical = arg2
    # Se a Mystical passou apenas (nivel) -> 1 argumento
    else:
        fonte = self # Atribui uma referência para não dar erro no dicionário
        nivel_mystical = int(arg1)
        
    fontes_mystical[fonte] = nivel_mystical
    _recalcular_buffs_mystical()


func remover_buff_mystical(fonte: Node = null):
    if fonte in fontes_mystical:
        fontes_mystical.erase(fonte)
    _recalcular_buffs_mystical()


func _recalcular_buffs_mystical():
    # 1. Limpa Mysticals invalidadas
    for fonte in fontes_mystical.keys():
        if not is_instance_valid(fonte):
            fontes_mystical.erase(fonte)
            
    # 2. Se não houver nenhuma Mystical no raio:
    if fontes_mystical.is_empty():
        MysticalBuff = false
        range_buff_val = 0.0
        dmg_Mystical = 0.0
        $Range/CollisionRange.scale = Vector2(1.0, 1.0)
        BuffStatus1 = "DMG: +0"
        BuffStatus2 = "Range: +0"
    # 3. Se houver Mystical, escolhe a de nível MAIS ALTO:
    else:
        MysticalBuff = true
        var maior_nivel = -1
        for nivel in fontes_mystical.values():
            if nivel > maior_nivel:
                maior_nivel = nivel
                
        match maior_nivel:
            0: range_buff_val = 0.1; dmg_Mystical = 1.0
            1: range_buff_val = 0.2; dmg_Mystical = 2.0
            2: range_buff_val = 0.3; dmg_Mystical = 3.0
            3: range_buff_val = 0.4; dmg_Mystical = 4.0
            4: range_buff_val = 0.5; dmg_Mystical = 5.0
            _: range_buff_val = 0.1; dmg_Mystical = 1.0
            
        $Range/CollisionRange.scale = Vector2(1.0 + range_buff_val, 1.0 + range_buff_val)
        BuffStatus1 = "Dmg: +" + str(dmg_Mystical)
        BuffStatus2 = "Range: +" + str(snapped(range_buff_val, 0.1))

    # Atualiza a UI
    P1status = "Damage: " + str(dmg_Doll + dmg_Mystical)
    P2status = "Max Targets: " + str(targets)

    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        if MysticalBuff:
            hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            hud.get_node("HUD_Shop/BuffStatus").visible = true
        else:
            hud.get_node("HUD_Shop/BuffStatus").visible = false


# --- UI e Desenho ---

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

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        
        P1status = "Damage: " + str(dmg_Doll + dmg_Mystical)
        P2status = "Max Targets: " + str(targets)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Doll.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        
        if MysticalBuff:
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
                1: dmg_Doll = 3.0; valor_torre += 250
                2: dmg_Doll = 3.5; valor_torre += 420
                3: dmg_Doll = 4.0; valor_torre += 990
                4: 
                    dmg_Doll = 5.0; valor_torre += 2550
                    auraMAISego()
                    Doll.texture = load("res://Assets/Bunnies/Paths/Doll01.png")

            atualizar_valorTorre()
            _recalcular_buffs_mystical()
        else:
            path2 += 1
            match path2:
                1: targets = 3; valor_torre += 470
                2: targets = 5; valor_torre += 730        
                3: targets = 7; valor_torre += 1470
                4: 
                    targets = 10; valor_torre += 3450
                    auraMAISego()
                    Doll.texture = load("res://Assets/Bunnies/Paths/Doll02.png")
                        
            atualizar_valorTorre()            
            _recalcular_buffs_mystical()
            
        return true 
    return false 

func auraMAISego():
    Doll.modulate = Color(1, 1, 1)
    if has_node("AURA"): $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property(Doll, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Doll, "modulate", Color(1, 1, 1, 1), 0.4)

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
