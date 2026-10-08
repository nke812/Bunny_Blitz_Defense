extends Node2D

@onready var Gooey = $Pega/Gooey

var mostrar_range = false
var pronto_para_atacar = false

var TimeSlimed = 3.0
var TimeSlimed_buff = 0.0
var TimeSlimed_Total = TimeSlimed + TimeSlimed_buff

var valor_torre = 225

var MysticalBuff = false
var posicionado = false

var focus = false
var skin = false

var Goo_Color = "Green_Goo"

var path1 = 0
var path2 = 0
var preços_p1 = [250, 600, 2800, 7000]
var preços_p2 = [250, 600, 2800, 7000]

var P1status = "Stun Time: " + str(TimeSlimed_Total)
var P2status = "ATK Speed: 2.5s"
var BuffStatus1 = "Stun Extra:"
var BuffStatus2 = "+0s"


func _process(_delta: float) -> void:
    if focus:
        $ArrowStun.visible = true
    else:
        $ArrowStun.visible = false
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar:
        verificar_e_atacar()

# --- Receber e Remover Buffs da Mystical ---

func receber_buff_mystical(nivel_mystical: int):
    MysticalBuff = true
    
    match nivel_mystical:
        0: TimeSlimed_buff = 0.5
        1: TimeSlimed_buff = 0.8
        2: TimeSlimed_buff = 1.2
        3: TimeSlimed_buff = 1.6
        4: TimeSlimed_buff = 2.2
        _: TimeSlimed_buff = 0.5
        
    TimeSlimed_Total = TimeSlimed + TimeSlimed_buff
    P1status = "Stun Time: " + str(TimeSlimed_Total)
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        BuffStatus2 = "+" + str(TimeSlimed_buff) + "s"
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
        hud.get_node("HUD_Shop/BuffStatus").visible = true

func remover_buff_mystical():
    MysticalBuff = false
    TimeSlimed_buff = 0.0
    TimeSlimed_Total = TimeSlimed
    P1status = "Stun Time: " + str(TimeSlimed_Total)
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/BuffStatus").visible = false

# --- Lógica de Ataque ---

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    var alvo_final = null
    var primeiro_fantasma = null

    for corpo in corpos:
        if is_instance_valid(corpo) and corpo.is_in_group("Ghostlings"):
            if primeiro_fantasma == null:
                primeiro_fantasma = corpo
            
            if not corpo.goo_stun:
                alvo_final = corpo
                break 

    if alvo_final == null and primeiro_fantasma != null:
        alvo_final = primeiro_fantasma

    if alvo_final != null:
        atacar(alvo_final)

func atacar(alvo):
    if is_instance_valid(alvo) and alvo.has_method("gooey_stun"):
        $Pega/Gooey/AnimationPlayer.play("Gooey_Attack")
        alvo.gooey_stun(TimeSlimed_Total, Goo_Color)
        pronto_para_atacar = false
        $Timer.start()

# --- Desenho do Raio ---

func _draw() -> void:
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_button_mouse_entered() -> void:
    mostrar_range = true
    queue_redraw()

func _on_button_mouse_exited() -> void:
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false

func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    
    var path = Gooey.texture.resource_path
    match path:
        "res://Assets/Bunnies/Gooey.png":
            Gooey.texture = load("res://Assets/Bunnies/Skins/Void.png")
            Goo_Color = "Void_Goo"
        "res://Assets/Bunnies/Skins/Void.png":
            Gooey.texture = load("res://Assets/Bunnies/Gooey.png")
            Goo_Color = "Green_Goo"
        "res://Assets/Bunnies/Paths/Gooey01.png":
            Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
            Goo_Color = "Void_Goo"
        "res://Assets/Bunnies/Skins/Paths/Void01.png":
            Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
            Goo_Color = "Blue_Goo"
        "res://Assets/Bunnies/Paths/Gooey02.png":
            Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
            Goo_Color = "Void_Goo"
        "res://Assets/Bunnies/Skins/Paths/Void02.png":
            Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")
            Goo_Color = "Purple_Goo"

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        
        TimeSlimed_Total = TimeSlimed + TimeSlimed_buff
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = "+" + str(TimeSlimed_buff) + "s"
        
        if not SaveManager.VoidUnlocked:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        else:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Gooey.png")
        atualizar_valorTorre()
        
        if MysticalBuff:
            hud.get_node("HUD_Shop/BuffStatus").visible = true
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
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
                1: TimeSlimed = 3.5; valor_torre += 250
                2: TimeSlimed = 4.2; valor_torre += 600
                3: TimeSlimed = 5.0; valor_torre += 2800
                4: 
                    TimeSlimed = 8.0
                    valor_torre += 7000
                    auraMAISego()
                    if skin:
                        Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void01.png")
                        Goo_Color = "Void_Goo"
                    else:
                        Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey01.png")
                        Goo_Color = "Blue_Goo"
            
            TimeSlimed_Total = TimeSlimed + TimeSlimed_buff            
            P1status = "Stun Time: " + str(TimeSlimed_Total)
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: $Timer.wait_time = 2.1; valor_torre += 250
                2: $Timer.wait_time = 1.7; valor_torre += 600
                3: $Timer.wait_time = 1.3; valor_torre += 2800
                4: 
                    $Timer.wait_time = 0.5
                    valor_torre += 7000
                    auraMAISego()
                    if skin:
                        Gooey.texture = load("res://Assets/Bunnies/Skins/Paths/Void02.png")
                        Goo_Color = "Void_Goo"
                    else:
                        Gooey.texture = load("res://Assets/Bunnies/Paths/Gooey02.png")
                        Goo_Color = "Purple_Goo"
                        
            P2status = "ATK Speed: " + str($Timer.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            atualizar_valorTorre()
        return true
    return false

func auraMAISego():
    Gooey.modulate = Color(1, 1, 1)
    $AURA.play("default")
    var tween = create_tween()
    tween.tween_property(Gooey, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Gooey, "modulate", Color(1, 1, 1, 1), 0.4)

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
    queue_free()
