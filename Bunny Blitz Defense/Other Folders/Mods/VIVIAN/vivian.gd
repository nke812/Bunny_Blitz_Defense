extends Node2D

@onready var Vivian = $Vivian

var skin = false
var valor_torre = 160000

var MysticalBuff = false
var posicionado = false

var mostrar_range = false
var pronto_para_atacar = false

var dmg_Vivian = 10

var focus = false

var path1 = 0
var path2 = 0
var preços_p1 = [1, 2, 3, 4]
var preços_p2 = [1, 2, 3, 4]

var P1status = "Damage: " + str(dmg_Vivian)
var P2status = "Speed ATK: 3.5s"

func _process(delta: float) -> void: 

    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false

    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar == true:
        verificar_e_atacar()

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    for corpo in corpos:
        if corpo.is_in_group("Ghostlings"):
            atacar(corpo)
            break

func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Vivian/AnimationPlayer.play("VivianAttack")
        
        var sons_hit = [$Hit, $Hit2, $Hit3]
        var som_sorteado = sons_hit[randi() % sons_hit.size()]
        som_sorteado.play()
        
        alvo.DMGED(dmg_Vivian)
        pronto_para_atacar = false
        $Timer.start()
        
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
        
        P1status = "Damage: " + str(dmg_Vivian)
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
        hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true 
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Mods/VIVIAN/VivianIcon.png")
        atualizar_valorTorre()
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        
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
                    dmg_Vivian = 150
                    valor_torre += 140
                2: 
                    dmg_Vivian = 300
                    valor_torre += 425
                3: 
                    dmg_Vivian = 700
                    valor_torre += 2400
                4: 
                    dmg_Vivian = 1000
                    valor_torre += 5500
                    auraMAISego()
                    
                    Vivian.texture = load("res://Mods/VIVIAN/Vivian1.png")
                    $Path1.play()
            atualizar_valorTorre()
            P1status = "Damage: " + str(dmg_Vivian)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
            $Vivian.position = Vector2(44, 68)
            
            
        else:
            path2 += 1
            match path2:
                1: 
                    $Timer.wait_time = 3.0
                    valor_torre += 140
                2: 
                    $Timer.wait_time = 2.7
                    valor_torre += 425        
                3:
                    $Timer.wait_time = 2.0
                    valor_torre += 2400
                4: 
                    $Timer.wait_time = 1.5
                    valor_torre += 5500
                    auraMAISego()
                
                    Vivian.texture = load("res://Mods/VIVIAN/Vivian2.png")
                    $Path2.play()
                    
            atualizar_valorTorre()            
            P2status = "Speed ATK: " + str($Timer.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
        return true 
    return false 
    
func auraMAISego():
    Vivian.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()
    tween.tween_property(Vivian, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Vivian, "modulate", Color(1, 1, 1, 1), 0.4)

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
