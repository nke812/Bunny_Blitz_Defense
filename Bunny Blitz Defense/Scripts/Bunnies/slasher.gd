extends Node2D

@onready var Slasher = $Pega/Node2D/Slasher
@onready var SlasherHand = $Pega/Node2D/SlasherAttack

@onready var Ult = $Pega/Node2D/Slasher/Ult
@onready var UltAppear = $Pega/Node2D/Slasher/AppearUlt

var pronto_para_atacar = false
var mostrar_range = false

var posicionado = false
var valor_torre = 250

var contagem_ult = 0

var range_base = Vector2(1.0, 1.0)

var MysticalBuff = false
var dmg_Mystical = 0
var dmg_Slasher = 3

var dmg_total = dmg_Slasher + dmg_Mystical

var focus = false
var skin = false 

var path1 = 0
var path2 = 0
var preços_p1 = [400, 1500, 3500, 7500]
var preços_p2 = [400, 1500, 3500, 7500]


var P1status = "ATK Speed: 3s"
var P2status = "Range: 1"
var BuffStatus1 = "DMG: " + "+" + str(dmg_Mystical)
var BuffStatus2 = "Range: 0" + "+"


func _ready() -> void:
    verificar_posicao_skin()


func _process(delta: float) -> void :
    
    if $Timer.is_stopped():
        pronto_para_atacar = true

    if pronto_para_atacar == true:
        verificar_e_atacar()
        
    if focus == true:
        $ArrowDps.visible = true
    else:
        $ArrowDps.visible = false

func verificar_e_atacar():
    var corpos = $Range.get_overlapping_bodies()
    
    if contagem_ult >= 20:
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
                break         
    else:
        for corpo in corpos:
            if corpo.is_in_group("Ghostlings"):
                atacar(corpo)
                break

func receber_buff_mystical(nivel_mystical):
    var dmg_buff = 0
    var range_buff = Vector2(0.0, 0.0) 
    
    if posicionado and MysticalBuff == true:
        match nivel_mystical:
            0: 
                dmg_buff = 1
            1: 
                dmg_buff = 2
            2: 
                dmg_buff = 3
                range_buff = Vector2(0.2, 0.2)
            3: 
                dmg_buff = 4
            4: 
                dmg_buff = 5
                range_buff = Vector2(0.3, 0.3)
    else:
        dmg_buff = 0
        range_buff = Vector2(0.0, 0.0)
    

    dmg_Mystical = dmg_buff
    
    $Range/CollisionRange.scale = range_base + range_buff
    
    atualizar_dmg()
    P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        BuffStatus1 = "Dmg: +" + str(dmg_Mystical) 
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            
        BuffStatus2 = "Range: +" + str(snapped(range_buff.x, 0.1))
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)

        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)


func atacar(alvo):
    if alvo.has_method("DMGED"):
        $Pega/Node2D/Slasher/AnimationPlayer.play("animAttack")
        $SlasherAttackEffect.play()
        
        SlasherHand.play()
        contagem_ult += 5
            
        if contagem_ult >= 20: 
            alvo.DMGED(dmg_total * 2)
            $Slash_Ult.play()
            
        else:
            alvo.DMGED(dmg_total)
            $Slash.play()

        verificar_ult()

        pronto_para_atacar = false
        $Timer.start()

func verificar_ult():
    if contagem_ult >= 55:
        Ult.visible = false
        UltAppear.play_backwards()
        contagem_ult = 0
        

    elif contagem_ult >= 20:
        if not Ult.visible and not UltAppear.is_playing():
            UltAppear.play()
            await UltAppear.animation_finished
            Ult.visible = true
            Ult.play()


func _draw() -> void :
    if mostrar_range:
        var shape = $Range/CollisionRange.shape
        if shape is CircleShape2D:
            var raio_final = shape.radius * $Range/CollisionRange.scale.x
            draw_circle(Vector2.ZERO, raio_final, Color(0.46, 0.46, 0.46, 0.443))

func _on_insp_mouse_entered() -> void :
    mostrar_range = true
    queue_redraw()

func _on_insp_mouse_exited() -> void :
    mostrar_range = false
    queue_redraw()

func reset_focus():
    focus = false



func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    verificar_posicao_skin()
    
    
    
    
    var texture = Slasher.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Animations/SlasherAttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/Skins/CanelaAttackIdle.png")
            SlasherHand.animation = "SlasherSkin"
            
            
        "res://Assets/Bunnies/Animations/Skins/CanelaAttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/SlasherAttackIdle.png")
            SlasherHand.animation = "Slasher"
            
        "res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png")
            SlasherHand.animation = "SlasherSkin01"
            
        "res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png")
            SlasherHand.animation = "Slasher01"
            
        "res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png")
            SlasherHand.animation = "SlasherSkin02"
            
        "res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png":
            Slasher.texture = load("res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png")
            SlasherHand.animation = "Slasher02"

func _on_insp_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    hud.get_node("HUD_Shop/BuffStatus").visible = false
    if hud:
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        
        if !SaveManager.CanelaUnlocked:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        else:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
        
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Slasher.png")
        atualizar_valorTorre()
        
        if MysticalBuff == true:
           hud.get_node("HUD_Shop/BuffStatus").visible = true
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
                    $Timer.wait_time = 2.7
                    valor_torre += 400
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                2: 
                    $Timer.wait_time = 2.3
                    valor_torre += 1500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                
                3: 
                    $Timer.wait_time = 1.5
                    valor_torre += 3500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    
                4: 
                    $Timer.wait_time = 0.5
                    valor_torre += 7500
                    P1status = "Speed ATK: " + str($Timer.wait_time) + "s"
                    hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
                    Ult.animation = "Ult01"
                    UltAppear.animation = "UltAppear01"
                    verificar_posicao_skin()
                    auraMAISego()
                    
                    if skin:
                        Slasher.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/Canela01AttackIdle.png")
                        SlasherHand.animation = "SlasherSkin01"
                    else:
                        Slasher.texture = load("res://Assets/Bunnies/Animations/Paths/Slasher01AttackIdle.png")
                        SlasherHand.animation = "Slasher01"
                        
            atualizar_valorTorre()
        else:
            path2 += 1
            match path2:
                1: 
                    range_base = Vector2(1.3, 1.3)
                    valor_torre += 400
                2: 
                    range_base = Vector2(1.5, 1.5)
                    valor_torre += 1500
                3: 
                    range_base = Vector2(1.7, 1.7)
                    valor_torre += 3500
                4: 
                    range_base = Vector2(2.0, 2.0)
                    valor_torre += 7500
                    Ult.animation = "Ult02"
                    UltAppear.animation = "UltAppear02"
                    verificar_posicao_skin()
                    auraMAISego()
                    
                    if skin:
                        Slasher.texture = load("res://Assets/Bunnies/Animations/Skins/Paths/Canela02AttackIdle.png")
                        SlasherHand.animation = "SlasherSkin02"
                    else:
                        Slasher.texture = load("res://Assets/Bunnies/Animations/Paths/Slasher02AttackIdle.png")
                        SlasherHand.animation = "Slasher02"


            $Range/CollisionRange.scale = range_base * (Vector2(1.1, 1.1) if MysticalBuff else Vector2(1.0, 1.0))
            
            P2status = "Range: " + str(snapped($Range/CollisionRange.scale.x, 0.1))
            
            
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            atualizar_valorTorre()
        return true
    return false
    
func verificar_posicao_skin():
    
    if skin:
        SlasherHand.position = Vector2(-84.0, -92.0)
        Ult.position = Vector2(141, -283)
        UltAppear.position = Vector2(141, -283)
        
        UltAppear.scale = Vector2(1.791, 1.791)
        Ult.scale = Vector2(1.791, 1.791)
        
        $Shadow.position = Vector2(-22, -25)
        
    elif skin == false:
        SlasherHand.position = Vector2(-16.0, -101.0)
        UltAppear.position = Vector2(-37, -292)
        Ult.position = Vector2(-37, -292)
        
        UltAppear.scale = Vector2(2.647, 2.647)
        Ult.scale = Vector2(2.647, 2.647)
        
        $Shadow.position = Vector2(2, -29)
        
func auraMAISego():
    Slasher.modulate = Color(1, 1, 1)
    SlasherHand.modulate = Color(1, 1, 1)
    $AURA.play("default")
    
    var tween = create_tween()


    tween.tween_property(Slasher, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.parallel().tween_property(SlasherHand, "modulate", Color(2, 2, 2, 1), 0.3)
 
    tween.tween_property(Slasher, "modulate", Color(1, 1, 1, 1), 0.4)
    tween.parallel().tween_property(SlasherHand, "modulate", Color(1, 1, 1, 1), 0.4)

func atualizar_dmg():
    dmg_total = dmg_Slasher + dmg_Mystical

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
