extends Node2D

@onready var Lucky = $Pega/Lucky

var font = load("res://FontText/Coiny-Regular.ttf")
var font_size = 40
var valor_lucky = 5
var posicionado = false

var valor_torre = 750

var MysticalBuff = false
var moedas_bonus = 0
var nivel_mystical_atual = 0

var focus = false
var skin = false

var path1 = 0
var path2 = 0
var preços_p1 = [650, 1400, 3500, 12000]
var preços_p2 = [650, 1400, 3500, 12000]

var P1status = "Profit " + str(valor_lucky) + "$:"
var P2status = "Farm Speed: 3.5s"

var BuffStatus1 = "Bonus por"
var BuffStatus2 = "ronda: 0"

func _ready() -> void:
    posicionado = true

func _physics_process(_delta):
    if focus:
        if has_node("ArrowSupport"): $ArrowSupport.visible = true
    else:
        if has_node("ArrowSupport"): $ArrowSupport.visible = false
    
    if has_node("ProgressBar") and has_node("Timer"):
        $ProgressBar.max_value = $Timer.wait_time
        $ProgressBar.value = $Timer.wait_time - $Timer.time_left

    var spawner = get_tree().get_first_node_in_group("spawner")

    if not spawner or not spawner.ronda_a_decorrer or not posicionado:
        $Timer.paused = true
    else:
        $Timer.paused = false
        if $Timer.is_stopped():
            $Timer.start()

func _on_timer_timeout() -> void:
    var moedas = get_tree().current_scene.find_child("Moedas")
    if moedas:
        var valor_atual = int(moedas.text)
        moedas.text = str(valor_atual + valor_lucky)
    
    if has_node("Pega/Lucky/AnimationPlayer"):
        $Pega/Lucky/AnimationPlayer.play("LuckyAction")
    label_money()
    
    if has_node("Money"):
        $Money.pitch_scale = randf_range(0.9, 1.1) 
        $Money.play()

func label_money():
    if not has_node("Panel"): return
    
    var label_M = Label.new()
    $Panel.add_child(label_M)

    label_M.text = "+" + str(valor_lucky) + "$"
    
    if Lucky and Lucky.texture:
        var resource_path = Lucky.texture.resource_path
        match resource_path:
            "res://Assets/Bunnies/Lucky.png": label_M.modulate = Color(1.0, 0.902, 0.392, 1.0)
            "res://Assets/Bunnies/Skins/ZeRon.png": label_M.modulate = Color(0.957, 0.478, 0.965, 1.0)
            "res://Assets/Bunnies/Paths/Lucky01.png": label_M.modulate = Color("143978ff")
            "res://Assets/Bunnies/Skins/Lucky02.png": label_M.modulate = Color(0.51, 0.54, 0.0, 1.0)
            "res://Assets/Bunnies/Skins/Paths/ZeRon01.png": label_M.modulate = Color(0.811, 0.556, 0.866, 1.0)
            "res://Assets/Bunnies/Skins/Paths/ZeRon02.png": label_M.modulate = Color(0.849, 0.262, 0.36, 1.0)

    if font:
        label_M.add_theme_font_override("font", font)
    label_M.add_theme_font_size_override("font_size", 40)

    label_M.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.341))
    label_M.add_theme_constant_override("shadow_offset_x", 3)
    label_M.add_theme_constant_override("shadow_offset_y", 3)
    label_M.add_theme_constant_override("shadow_outline_size", 9)

    var x_aleatorio = randf_range(0, 200)
    var y_aleatorio = randf_range(0, 150)
    label_M.position = Vector2(x_aleatorio, y_aleatorio)

    var tween = create_tween()
    tween.tween_property(label_M, "modulate:a", 0.0, 1.0)
    tween.parallel().tween_property(label_M, "position:y", label_M.position.y - 20, 1.0)
    tween.finished.connect(label_M.queue_free)

func reset_focus():
    focus = false
    if has_node("ArrowSupport"):
        $ArrowSupport.visible = false

func mudar_skin():
    skin = !skin
    if has_node("SkinChange"):
        $SkinChange.play("ChangeSkin")
    
    if not Lucky or not Lucky.texture: return
    
    var path = Lucky.texture.resource_path
    match path:
        "res://Assets/Bunnies/Lucky.png": Lucky.texture = load("res://Assets/Bunnies/Skins/ZeRon.png")
        "res://Assets/Bunnies/Skins/ZeRon.png": Lucky.texture = load("res://Assets/Bunnies/Lucky.png")
        "res://Assets/Bunnies/Paths/Lucky01.png": Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon01.png")
        "res://Assets/Bunnies/Skins/Paths/ZeRon01.png": Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky01.png")
        "res://Assets/Bunnies/Paths/Lucky02.png": Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon02.png")
        "res://Assets/Bunnies/Skins/Paths/ZeRon02.png": Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky02.png")

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Lucky.png")
        atualizar_valorTorre()
        
        if not SaveManager.ZeRonUnlocked:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        else:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
        
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")
        
        if MysticalBuff:
            hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
            hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
            hud.get_node("HUD_Shop/BuffStatus").visible = true

# --- Comunicação com Mystical ---

func receber_buff_mystical(mystical: int):
    MysticalBuff = true
    nivel_mystical_atual = mystical
    
    var spawner = get_tree().get_first_node_in_group("spawner")
    
    var bonus_base = 0
    match mystical:
        0: bonus_base = 70
        1: bonus_base = 100
        2: bonus_base = 160
        3: bonus_base = 240
        4: bonus_base = 320
        _: bonus_base = 70
    
    var maior_upgrade = max(path1, path2)
    moedas_bonus = bonus_base + (maior_upgrade * 30)
    
    if spawner and "moedas_fim_ronda_bonus" in spawner:
        spawner.moedas_fim_ronda_bonus = moedas_bonus
        if spawner.has_method("atualizar_moedas_buff"):
            spawner.atualizar_moedas_buff()
            
    BuffStatus2 = "ronda: " + str(moedas_bonus)

    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/BuffStatus/Buff3").text = str(BuffStatus1)
        hud.get_node("HUD_Shop/BuffStatus/Buff4").text = str(BuffStatus2)
        hud.get_node("HUD_Shop/BuffStatus").visible = true

func remover_buff_mystical():
    MysticalBuff = false
    moedas_bonus = 0
    BuffStatus2 = "ronda: 0"
    
    var spawner = get_tree().get_first_node_in_group("spawner")
    if spawner and "moedas_fim_ronda_bonus" in spawner:
        spawner.moedas_fim_ronda_bonus = 0
        if spawner.has_method("atualizar_moedas_buff"):
            spawner.atualizar_moedas_buff()
            
    var hud = get_tree().get_first_node_in_group("HUD")
    if hud and focus:
        hud.get_node("HUD_Shop/BuffStatus").visible = false

# --- Upgrades e Venda ---

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
                1: valor_lucky = 15; valor_torre += 650
                2: valor_lucky = 50; valor_torre += 1400
                3: valor_lucky = 80; valor_torre += 3500
                4: 
                    valor_lucky = 120
                    valor_torre += 12000
                    auraMAISego()
                    if skin: Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon01.png")
                    else: Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky01.png")
            
            P1status = "Money " + str(valor_lucky) + "$:"
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        else:
            path2 += 1
            match path2:
                1: $Timer.wait_time = 3.0; valor_torre += 650
                2: $Timer.wait_time = 2.6; valor_torre += 1400
                3: $Timer.wait_time = 2.0; valor_torre += 3500
                4: 
                    $Timer.wait_time = 1.3
                    valor_torre += 12000
                    auraMAISego()
                    if skin: Lucky.texture = load("res://Assets/Bunnies/Skins/Paths/ZeRon02.png")
                    else: Lucky.texture = load("res://Assets/Bunnies/Paths/Lucky02.png")
                    
            P2status = "Farm speed: " + str($Timer.wait_time) + "s"
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
        atualizar_valorTorre()
        
        if MysticalBuff:
            receber_buff_mystical(nivel_mystical_atual)
            
        return true
    return false

func auraMAISego():
    Lucky.modulate = Color(1, 1, 1)
    if has_node("AURA"): $AURA.play("default")
    var tween = create_tween()
    tween.tween_property(Lucky, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property(Lucky, "modulate", Color(1, 1, 1, 1), 0.4)

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
