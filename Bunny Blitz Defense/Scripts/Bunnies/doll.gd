extends Node2D

@onready var Doll = $Pega/Node2D/Doll

var valor_torre = 680

var MysticalBuff = false
var posicionado = false

var mostrar_range = false
var pronto_para_atacar = false

var dmg_Doll = 2
var targets = 2

var focus = false


var path1 = 0
var path2 = 0
var preços_p1 = [250, 420, 990, 2550]
var preços_p2 = [470, 730, 1470, 3450]

var P1status = "Damage: " + str(dmg_Doll)
var P2status = "Max Targets: " + str(targets)
var BuffStatus1 = "DMG: +0"
var BuffStatus2 = "Range: 1.0"





func _process(delta: float) -> void: 

    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false

    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar == true:
        verificar_e_atacar()


var alvos_atuais: Array = []

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
        
    $Pega/Node2D/Doll/DollAttack.play("DollAttack")


func atacar():
    for alvo in alvos_atuais:
        if is_instance_valid(alvo) and alvo.has_method("DMGED"):
            alvo.DMGED(dmg_Doll)
            
    alvos_atuais.clear()
    pronto_para_atacar = false
    $Timer.start()


func playSqueak():
    $DollSqueak.pitch_scale = 1 + randf_range(-0.1, 0.1)
    $DollSqueak.play()
    

#func receber_buff_mystical(nivel_mystical):
    #if posicionado and MysticalBuff == true:
        #var dmg_buff = 0
        #var scale_buff = Vector2(1.0, 1.0) 
    #
        #match nivel_mystical:
            #0: 
                #dmg_buff = 1
                #scale_buff = Vector2(1.1, 1.1)
            #1: 
                #dmg_buff = 2
                #scale_buff = Vector2(1.2, 1.2)
            #2: 
                #dmg_buff = 3
                #scale_buff = Vector2(1.3, 1.3)
            #3: 
                #dmg_buff = 4
                #scale_buff = Vector2(1.4, 1.4)
            #4: 
                #dmg_buff = 5
                #scale_buff = Vector2(1.5, 1.5)
#
#
        #if dmg_buff > dmg_Mystical:
                #dmg_Mystical = dmg_buff
                #$Range/CollisionRange.scale = scale_buff
        #else:
            #dmg_Mystical = 0
            #$Range/CollisionRange.scale = Vector2(1.0, 1.0)
    #
        #dmg_total = dmg_Rookie + dmg_Mystical
        #P1status = "Damage: " + str(dmg_total)
        #
    #
        #var hud = get_tree().get_first_node_in_group("HUD")
        #if hud and focus:
            #BuffStatus1 = "Dmg: +" + str(dmg_Mystical) 
            #hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            #
            #BuffStatus2 = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
            #hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            #hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
#
#func remover_buff_mystical():
    #dmg_Mystical = 0
    #MysticalBuff = false
    #$Range/CollisionRange.scale = Vector2(1.0, 1.0)
    #P1status = "Damage: " + str(dmg_total)
    #
    #var hud = get_tree().get_first_node_in_group("HUD")
    #if hud and focus:
        #hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        #hud.get_node("HUD_Shop/BuffStatus").visible = false
        
func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false


func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    hud.get_node("HUD_Shop/BuffStatus").visible = false
    if hud:
        hud.abrir_menu_upgrade(self)
        
        P1status = "Damage: " + str(dmg_Doll)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Doll.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        
        #if MysticalBuff == true:
            #BuffStatus1 = "Dmg: +" + str(dmg_Mystical)
            #BuffStatus2 = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
            #hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            #hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            #hud.get_node("HUD_Shop/BuffStatus").visible = true
        
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
    

func aplicar_upgrade(caminho):
    var hud = get_tree().get_first_node_in_group("HUD")
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
                1: 
                    dmg_Doll = 3
                    valor_torre += 250
                2: 
                    dmg_Doll = 3.5
                    valor_torre += 420
                3: 
                    dmg_Doll = 4
                    valor_torre += 990
                4: 
                    dmg_Doll = 5
                    valor_torre += 2550
                    auraMAISego()
                    
                    Doll.texture = load("res://Assets/Bunnies/Paths/Doll01.png")

            
            atualizar_valorTorre()
            P1status = "Damage: " + str(dmg_Doll)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
        else:
            path2 += 1
            match path2:
                1: 
                    targets = 3
                    valor_torre += 470
                2: 
                    targets = 5
                    valor_torre += 730       
                3:
                    targets = 7
                    valor_torre += 1470
                4: 
                    targets = 10
                    valor_torre += 3450
                    auraMAISego()
                    
                    Doll.texture = load("res://Assets/Bunnies/Paths/Doll02.png")
                        
            atualizar_valorTorre()            
            P2status = "Max Targets: " + str(targets)
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
        return true 
    return false 
    
func auraMAISego():
    Doll.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()

    tween.tween_property(Doll, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Doll, "modulate", Color(1, 1, 1, 1), 0.4)

func atualizar_valorTorre():
    var hud = get_tree().get_first_node_in_group("HUD")
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    hud.get_node("HUD_Shop/HudBgDown/Control/PanelSell/precoSell").text = str(valor_torre_60)

func vender_torre():
    var moedas = get_tree().current_scene.find_child("Moedas")
    var valor_atual = int(moedas.text)
    var valor_torre_60 : int = int(valor_torre * 0.6)
    
    moedas.text = str(valor_atual + valor_torre_60)
    
    queue_free()
