extends Node2D

# Pre-carregar apenas as texturas leves da interface
var tex_price_enabled = preload("res://Assets/Others/HUD_Assets/PriceTag.png")
var tex_price_disabled = preload("res://Assets/Others/HUD_Assets/PriceTagDisabled.png")

@onready var moedas_label = $"../../Moedas"
@onready var moedas_barra = $"../../PGB_M"
@onready var moedas_atuais = int(moedas_label.text)

var tipo_torre_atual = ""
var temp_tower = null
var local_proibido = false
var custo_da_torre_atual = 0
var ultima_posicao_rato: Vector2 = Vector2.ZERO
var mola_rotacao: float = 0.0
var mola_velocidade: float = 0.0

var torres_paths = {
    "rookie": "res://Scenes/Towers/rookie.tscn",
    "lucky": "res://Scenes/Towers/lucky.tscn",
    "slasher": "res://Scenes/Towers/slasher.tscn",
    "gooey": "res://Scenes/Towers/gooey.tscn",
    "anarchist": "res://Scenes/Towers/anarchist.tscn",
    "scrappy": "res://Scenes/Towers/scrappy.tscn",
    "mystical": "res://Scenes/Towers/mystical.tscn",
    "ghoulish": "res://Scenes/Towers/ghoulish.tscn",
    "corrupted": "res://Scenes/Towers/corrupted.tscn",
    "molten": "res://Scenes/Towers/molten.tscn",
    "doll": "res://Scenes/Towers/doll.tscn"
}

# Dicionário para guardar as cenas pré-carregadas em memória
var torres_carregadas = {}

func _ready() -> void:
    SaveManager.carregar_dados()
    
    # Inicia o carregamento assíncrono em background sem congelar o jogo
    for chave in torres_paths:
        ResourceLoader.load_threaded_request(torres_paths[chave])

    $ScrollContainer/GridContainer/Corrupted_BG_stun.visible = SaveManager.CorruptedUnlocked
    $ScrollContainer/GridContainer/Scrappy_BG_stun.visible = SaveManager.ScrappyUnlocked
    $ScrollContainer/GridContainer/Ghoulish_BG_stun.visible = SaveManager.GhoulishUnlocked
    $ScrollContainer/GridContainer/Mystical_BG_support.visible = SaveManager.MysticalUnlocked
    $ScrollContainer/GridContainer/Alien_BG_dps.visible = SaveManager.AlienUnlocked
    $ScrollContainer/GridContainer/Toasty_BG_dps.visible = SaveManager.ToastyUnlocked
    $ScrollContainer/GridContainer/Voodo_BG_stun.visible = SaveManager.VoodoUnlocked
    $ScrollContainer/GridContainer/Molten_BG_dps.visible = SaveManager.MoltenUnlocked
    $ScrollContainer/GridContainer/Doll_BG_dps.visible = SaveManager.DollUnlocked
    
    atualizar_loja_botoes()

func _comprar_torre(chave: String, custo: int):
    if temp_tower != null or moedas_atuais < custo:
        return
        
    var path = torres_paths[chave]
    
    # Se a cena ainda não foi guardada no dicionário local, recupera do ResourceLoader
    if not torres_carregadas.has(chave):
        if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
            torres_carregadas[chave] = ResourceLoader.load_threaded_get(path)
        else:
            # Fallback síncrono de segurança caso o jogador clique instantaneamente ao abrir a cena
            torres_carregadas[chave] = load(path)
            
    var cena = torres_carregadas[chave]
    if cena:
        tipo_torre_atual = chave
        temp_tower = cena.instantiate()
        custo_da_torre_atual = custo
        configurar_torre_temp()

func _process(delta: float) -> void:
    var moedas_atuais_nova = int(moedas_label.text)
    if moedas_atuais_nova != moedas_atuais:
        moedas_atuais = moedas_atuais_nova
        atualizar_loja_botoes()

    if temp_tower != null:
        var BlackHolePos = get_global_mouse_position()
        if temp_tower.has_node("Pega"):
            var pega_pos_local = temp_tower.get_node("Pega").position
            temp_tower.global_position = BlackHolePos - pega_pos_local
        else:
            temp_tower.global_position = BlackHolePos

        var vetor_movimento = BlackHolePos - ultima_posicao_rato
        ultima_posicao_rato = BlackHolePos
        
        var forca_arrasto = vetor_movimento.x * 0.30
        var forca_retorno = -30.0 * mola_rotacao
        var amortecimento = -4.0 * mola_velocidade
        var aceleracao = forca_arrasto + forca_retorno + amortecimento
        
        mola_velocidade += aceleracao * delta
        mola_rotacao += mola_velocidade * delta
        mola_rotacao = clamp(mola_rotacao, -0.9, 0.9)
        
        if temp_tower.has_node("Pega"):
            temp_tower.get_node("Pega").rotation = mola_rotacao

        var detector = temp_tower.get_node("HitBox")
        var areas_em_cima = detector.get_overlapping_areas()

        local_proibido = false
        for area in areas_em_cima:
            if area.is_in_group("no_place"):
                local_proibido = true
                break

        if local_proibido:
            temp_tower.modulate = Color(1, 0.2, 0.2, 0.5)
        else:
            temp_tower.modulate = Color(1, 1, 1, 0.5)

        if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
            if not local_proibido:
                largar_torre()
                mola_rotacao = 0.0
                mola_velocidade = 0.0
            else:
                temp_tower.queue_free()
                temp_tower = null
                custo_da_torre_atual = 0
                mola_rotacao = 0.0
                mola_velocidade = 0.0

func atualizar_loja_botoes() -> void:
    # Usa as variáveis carregadas uma única vez em vez de fazer preload no loop
    _atualizar_botao_preco($ScrollContainer/GridContainer/Rookie_BG_dps, $ScrollContainer/GridContainer/Rookie_BG_dps/Rookie, 115)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Lucky_BG_support, $ScrollContainer/GridContainer/Lucky_BG_support/Lucky, 750)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Slasher_BG_dps, $ScrollContainer/GridContainer/Slasher_BG_dps/Slasher, 250)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Gooey_BG_stun, $ScrollContainer/GridContainer/Gooey_BG_stun/Gooey, 225)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Anarchist_BG_dps, $ScrollContainer/GridContainer/Anarchist_BG_dps/Anarchist, 500)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Scrappy_BG_stun, $ScrollContainer/GridContainer/Scrappy_BG_stun/Scrappy, 330)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Mystical_BG_support, $ScrollContainer/GridContainer/Mystical_BG_support/Mystical, 1400)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Ghoulish_BG_stun, $ScrollContainer/GridContainer/Ghoulish_BG_stun/Ghoulish, 700)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Molten_BG_dps, $ScrollContainer/GridContainer/Molten_BG_dps/Molten, 1270)
    _atualizar_botao_preco($ScrollContainer/GridContainer/Doll_BG_dps, $ScrollContainer/GridContainer/Doll_BG_dps/Doll, 680)

func _atualizar_botao_preco(container, btn_child, custo: int):
    var esta_desativado = (moedas_atuais < custo)
    container.disabled = esta_desativado
    if btn_child:
        btn_child.disabled = esta_desativado
    
    var label_preco = container.get_node("Preço")
    var sprite_tag = container.get_node("Sprite2D")
    
    if esta_desativado:
        label_preco.add_theme_color_override("font_color", Color.from_string("afafaf", Color.WHITE))
        label_preco.add_theme_color_override("font_shadow_color", Color.from_string("7c7c7c", Color.BLACK))
        sprite_tag.texture = tex_price_disabled
    else:
        label_preco.add_theme_color_override("font_color", Color.from_string("ffc74d", Color.WHITE))
        label_preco.add_theme_color_override("font_shadow_color", Color.from_string("d1a000df", Color.BLACK))
        sprite_tag.texture = tex_price_enabled


func _on_rookie_button_down() -> void:
    _comprar_torre("rookie", 115)

func _on_slasher_button_down() -> void:
    _comprar_torre("slasher", 250)

func _on_lucky_button_down() -> void:
    _comprar_torre("lucky", 750)

func _on_gooey_button_down() -> void:
    _comprar_torre("gooey", 225)

func _on_anarchist_button_down() -> void:
    _comprar_torre("anarchist", 500)

func _on_scrappy_button_down() -> void:
    _comprar_torre("scrappy", 330)

func _on_mystical_button_down() -> void:
    _comprar_torre("mystical", 1400)

func _on_ghoulish_button_down() -> void:
    _comprar_torre("ghoulish", 700)
    
func _on_corrupted_button_down() -> void:
    _comprar_torre("corrupted", 970)
    
func _on_molten_button_down() -> void:
    _comprar_torre("molten", 1270)
    
func _on_doll_button_down() -> void:
    _comprar_torre("doll", 680)

func configurar_torre_temp():
    temp_tower.modulate.a = 0.5
    temp_tower.process_mode = Node.PROCESS_MODE_ALWAYS
    
    var range_node = temp_tower.get_node("Range")
    range_node.monitoring = false
    range_node.monitorable = true

    get_tree().current_scene.add_child(temp_tower)

func largar_torre():
    $TowerPlace.play()
    if "posicionado" in temp_tower:
        temp_tower.posicionado = true

    if temp_tower:
        if moedas_atuais >= custo_da_torre_atual:
            if temp_tower.has_node("Pega"):
                temp_tower.get_node("Pega").rotation = 0.0
            
            temp_tower.get_node("Shadow").visible = true
            if temp_tower.has_node("SkinChange"):
                temp_tower.get_node("SkinChange").play("ChangeSkin")
            temp_tower.modulate.a = 1.0
            temp_tower.process_mode = Node.PROCESS_MODE_INHERIT
            
            if temp_tower.has_node("Place"):
                temp_tower.get_node("Place").play()
            
            if temp_tower.has_node("Idle"):
                temp_tower.get_node("Idle").play("Idle animation")

            var range_node = temp_tower.get_node("Range")
            range_node.monitoring = true
            range_node.monitorable = true

            var novas_moedas = moedas_atuais - custo_da_torre_atual
            moedas_label.text = str(novas_moedas)
            moedas_barra.value = novas_moedas

            range_node.get_node("CollisionRange").visible = true

            temp_tower = null
            custo_da_torre_atual = 0
        else:
            temp_tower.queue_free()
            temp_tower = null
            custo_da_torre_atual = 0
