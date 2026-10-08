extends Node2D

var posicionado = false
var mostrar_range = false

var valor_torre = 1400

var MysticalBuff = false

var focus = false
var skin = false

var path1 = 0
var path2 = 0
var preços_p1 = [650, 1400, 3500, 12000]
var preços_p2 = [650, 1400, 3500, 12000]

var buffs = 0

var P1status = "LV Buff: " + str(path1)
var P2status = "Range: 1"

var coelhos_no_raio: Array = []
var raio_base: float = 0.0

func _ready() -> void:
    posicionado = true
    
    # CRÍTICO: Duplica o Shape2D para evitar que o alcance afete TODAS as torres Mystical do jogo
    if $Range/CollisionRange.shape is CircleShape2D:
        $Range/CollisionRange.shape = $Range/CollisionRange.shape.duplicate()
        $Range/CollisionRange.shape.radius = 189.1
        raio_base = $Range/CollisionRange.shape.radius
    
    await get_tree().physics_frame
    _atualizar_buffs_iniciais()

func _atualizar_buffs_iniciais() -> void:
    var areas = $Range.get_overlapping_areas()
    for area in areas:
        if area.name == "HitBox":
            _aplicar_buff_a_area(area)

func _on_range_area_entered(area: Area2D) -> void:
    var temp_coelho = area.get_parent()
    if area.name == "HitBox":
        # Proteção contra crash caso o coelho seja vendido/apagado durante a espera
        while is_instance_valid(temp_coelho) and temp_coelho.posicionado == false:
            await get_tree().process_frame
        
        if is_instance_valid(temp_coelho):
            _aplicar_buff_a_area(area)

func _on_range_area_exited(area: Area2D) -> void:
    if area.name == "HitBox":
        _remover_buff_de_area(area)

# --- Funções Auxiliares de Buff ---

func _aplicar_buff_a_area(area: Area2D) -> void:
    var coelho = area.get_parent()
    if is_instance_valid(coelho) and coelho.is_in_group("Bunnies") and coelho != self:
        if not coelhos_no_raio.has(coelho):
            coelhos_no_raio.append(coelho)
        
        if coelho.has_method("receber_buff_mystical"):
            coelho.receber_buff_mystical(path1)

func _remover_buff_de_area(area: Area2D) -> void:
    var coelho = area.get_parent()
    if is_instance_valid(coelho) and coelho.is_in_group("Bunnies"):
        if coelhos_no_raio.has(coelho):
            coelhos_no_raio.erase(coelho)
        
        if coelho.has_method("remover_buff_mystical"):
            coelho.remover_buff_mystical()

func atualizar_nivel_do_buff() -> void:
    coelhos_no_raio = coelhos_no_raio.filter(func(c): return is_instance_valid(c))
    for coelho in coelhos_no_raio:
        if coelho.has_method("receber_buff_mystical"):
            coelho.receber_buff_mystical(path1)

func reset_focus():
    focus = false
    if has_node("ArrowSupport"):
        $ArrowSupport.visible = false

func _on_button_button_down() -> void:
    get_tree().call_group("Bunnies", "reset_focus")
    focus = true
    if has_node("ArrowSupport"):
        $ArrowSupport.visible = true

    var hud = get_tree().get_first_node_in_group("HUD")
    if hud:
        hud.get_node("HUD_Shop/BuffStatus").visible = false
        hud.abrir_menu_upgrade(self)
        
        hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
        hud.get_node("HUD_Shop/HudBgDown/BunnySel").texture = load("res://Assets/Bunnies/Mystical.png")
        atualizar_valorTorre()
        
        if not SaveManager.CatharsisUnlocked:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = true
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = true
        else:
            hud.get_node("HUD_Shop/HudBgDown/TextureButton").disabled = false
            hud.get_node("HUD_Shop/HudBgDown/TextureButton/lock").visible = false
        
        hud.get_node("HUD_Shop/HudBgDown/ExitShop").disabled = false
        hud.get_node("HUD_Shop/Shop_Appear").play("Shop_Appear")

func mudar_skin():
    skin = !skin
    $SkinChange.play("ChangeSkin")
    
    var texture = $Pega/Mystical.texture.resource_path
    match texture:
        "res://Assets/Bunnies/Mystical.png":
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Skins/Catharsis.png")
        "res://Assets/Bunnies/Skins/Catharsis.png":
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Mystical.png")
        "res://Assets/Bunnies/Paths/Mystical01.png":
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Skins/Paths/Catharsis01.png")
        "res://Assets/Bunnies/Skins/Paths/Catharsis01.png":
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Paths/Mystical01.png")
        "res://Assets/Bunnies/Paths/Mystical02.png":
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Skins/Paths/Catharsis02.png")
        "res://Assets/Bunnies/Skins/Paths/Catharsis02.png": # <--- Typo corrigido (Skins no plural)
            $Pega/Mystical.texture = load("res://Assets/Bunnies/Paths/Mystical02.png")

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
            P1status = "LV Buff: " + str(path1)
            atualizar_nivel_do_buff()
            
            match path1:
                1: valor_torre += 650
                2: valor_torre += 1400
                3: valor_torre += 3500
                4: 
                    valor_torre += 12000
                    if skin: 
                        $Pega/Mystical.texture = load("res://Assets/Bunnies/Skins/Paths/Catharsis01.png")
                    else: 
                        $Pega/Mystical.texture = load("res://Assets/Bunnies/Paths/Mystical01.png")
                    auraMAISego()
            hud.get_node("HUD_Shop/HudBgDown/Status1").text = str(P1status)
        else:
            path2 += 1
            var multiplicador_range = 1.0
            match path2:
                1: multiplicador_range = 1.2
                2: multiplicador_range = 1.5
                3: multiplicador_range = 1.7
                4: 
                    multiplicador_range = 2.0
                    if skin: $Pega/Mystical.texture = load("res://Assets/Bunnies/Skins/Paths/Catharsis02.png")
                    else: $Pega/Mystical.texture = load("res://Assets/Bunnies/Paths/Mystical02.png")
                    auraMAISego()
            
            if $Range/CollisionRange.shape is CircleShape2D and raio_base > 0:
                $Range/CollisionRange.shape.radius = raio_base * multiplicador_range
            
            valor_torre += custo
            P2status = "Range: " + str(multiplicador_range)
            hud.get_node("HUD_Shop/HudBgDown/Status2").text = str(P2status)
            
            _atualizar_buffs_iniciais()
            atualizar_nivel_do_buff()
            
        atualizar_valorTorre()         
        return true
    return false

func auraMAISego():
    $Pega/Mystical.modulate = Color(1, 1, 1)
    $AURA.play("default")
    var tween = create_tween()
    tween.tween_property($Pega/Mystical, "modulate", Color(2, 2, 2, 1), 0.3)
    tween.tween_property($Pega/Mystical, "modulate", Color(1, 1, 1, 1), 0.4)

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
    
    desativar_buff()
    queue_free()

func desativar_buff():
    for coelho in coelhos_no_raio:
        if is_instance_valid(coelho):
            if coelho.has_method("remover_buff_mystical"):
                coelho.remover_buff_mystical()
    coelhos_no_raio.clear()

func receber_buff_mystical(_nivel_mystical):
    pass
