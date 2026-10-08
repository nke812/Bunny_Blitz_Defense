extends Node2D

@onready var Ghostling = load("res://Scenes/Enemies/Ghostling/ghostling.tscn")
@onready var Ghazt = load("res://Scenes/Enemies/Ghostling/ghazt.tscn")
@onready var Ghoul = load("res://Scenes/Enemies/Ghostling/ghoul.tscn")
@onready var Ghaztling = load("res://Scenes/Enemies/Ghostling/ghaztling.tscn")
@onready var Ghazely = load("res://Scenes/Enemies/Ghostling/ghazely.tscn")

@onready var Enhanced_Ghaztling = load("res://Scenes/Enemies/Ghostling/enhanced_ghaztling.tscn")
@onready var Enhanced_Ghoul = load("res://Scenes/Enemies/Ghostling/enhanced_ghoul.tscn")
@onready var Unholy_Phantasm = load("res://Scenes/Enemies/Ghostling/unholy_phantasm.tscn")
@onready var Brute = load("res://Scenes/Enemies/Ghostling/brute.tscn")

@onready var Leviathan = load("res://Scenes/Enemies/Bosses/Leviathan.tscn")
@onready var Azazel = load("res://Scenes/Enemies/Bosses/Azazel.tscn")
@onready var Belzebu = load("res://Scenes/Enemies/Bosses/Belzebu.tscn")
@onready var Fenrir = load("res://Scenes/Enemies/Bosses/Fenrir.tscn")
@onready var Lucifer = load("res://Scenes/Enemies/Bosses/Lucifer.tscn")

@onready var Undead_Ghostling = load("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn")

var rodada_atual = 1
var inimigos_vivos = 0
var vaga_atual = []
var ronda_a_decorrer = false

var moedas_fim_ronda = 115
var moedas_fim_ronda_bonus = 0
var moedas_fim_ronda_total = moedas_fim_ronda + moedas_fim_ronda_bonus

func _ready() -> void:
    atualizar_contador_rondas()

func _process(_delta):
    var botao_start = get_tree().get_first_node_in_group("start_button")
    if botao_start and has_node("Timer"):
        if inimigos_vivos > 0 or not $Timer.is_stopped():
            botao_start.disabled = true
        else:
            botao_start.disabled = false


func clonar(inimigo, quantidade: int) -> Array:
    var arr = []
    for i in range(quantidade):
        arr.append(inimigo)
    return arr

func animar_placa_boss(imagem_path: String = "", texto: String = ""):
    var hud = get_tree().get_first_node_in_group("HUD")
    if not hud or not hud.has_node("HUD_Shop/EventSign/Placa"): 
        return
        
    var event_sign = hud.get_node("HUD_Shop/EventSign")
    
    if imagem_path != "":
        event_sign.get_node("Sprite2D").texture = load(imagem_path)
    if texto != "":
        event_sign.get_node("Label").text = texto
        
    var placa = event_sign.get_node("Placa")
    placa.play("Placa")
    await placa.animation_finished
    placa.play_backwards("Placa")

func iniciar_vaga():
    var hud = get_tree().get_first_node_in_group("HUD")
    ronda_a_decorrer = true
    
    match rodada_atual:
        # Fase 1: Introdução Básica
        1: 
            vaga_atual = clonar(Ghostling, 12)
            if has_node("../StarRound"):
                $"../StarRound".play()
        2: vaga_atual = clonar(Ghostling, 6) + clonar(Ghazt, 4) + clonar(Ghostling, 6)
        3: vaga_atual = clonar(Ghazt, 8) + clonar(Ghostling, 4) + clonar(Ghazt, 4)
        4: vaga_atual = clonar(Ghostling, 5) + clonar(Ghoul, 5) + clonar(Ghostling, 5) + clonar(Ghoul, 3)
        5: vaga_atual = clonar(Ghazt, 6) + clonar(Ghoul, 4) + clonar(Ghostling, 8) + clonar(Ghazt, 4)
        6: vaga_atual = clonar(Ghazt, 6) + clonar(Ghaztling, 4) + clonar(Ghazt, 6) + clonar(Ghaztling, 2)
        7: vaga_atual = clonar(Ghostling, 20) # Swarm puro
        8: vaga_atual = clonar(Ghaztling, 6) + clonar(Ghazt, 6) + clonar(Ghaztling, 6) + clonar(Ghoul, 4)
        9: vaga_atual = clonar(Ghoul, 8) + clonar(Ghostling, 10) + clonar(Ghoul, 6) + clonar(Ghazt, 4)
        10: vaga_atual = clonar(Ghaztling, 15) + clonar(Ghostling, 5)

        # Fase 2: Primeiros Desafios Mistos
        11: vaga_atual = clonar(Ghostling, 8) + clonar(Ghazt, 6) + clonar(Ghoul, 6) + clonar(Ghaztling, 4)
        12: vaga_atual = clonar(Ghazt, 10) + clonar(Ghaztling, 8) + clonar(Ghoul, 4)
        13: vaga_atual = clonar(Ghoul, 10) + clonar(Ghostling, 10) + clonar(Ghaztling, 6)
        14: vaga_atual = clonar(Ghazt, 8) + clonar(Ghoul, 8) + clonar(Ghaztling, 8) + clonar(Ghostling, 6)
        15: vaga_atual = clonar(Ghaztling, 20) + clonar(Ghazt, 5)
        16: vaga_atual = clonar(Ghoul, 12) + clonar(Ghazt, 8) + clonar(Ghostling, 10)
        17: vaga_atual = clonar(Ghostling, 10) + clonar(Ghaztling, 10) + clonar(Ghoul, 8)
        18: vaga_atual = clonar(Ghazt, 10) + clonar(Ghoul, 10) + clonar(Ghaztling, 8)
        19: vaga_atual = clonar(Ghaztling, 12) + clonar(Ghoul, 12) + clonar(Ghazt, 6)
        20: vaga_atual = clonar(Ghoul, 25) # Grande barreira de Ghouls

        # Fase 3: Introdução Ghazely
        21: vaga_atual = clonar(Ghoul, 10) + clonar(Ghazely, 4) + clonar(Ghostling, 8)
        22: vaga_atual = clonar(Ghazt, 8) + clonar(Ghazely, 5) + clonar(Ghostling, 12)
        23: vaga_atual = clonar(Ghaztling, 10) + clonar(Ghazely, 6) + clonar(Ghoul, 6)
        24: vaga_atual = clonar(Ghoul, 12) + clonar(Ghazely, 6) + clonar(Ghazt, 8)
        25: vaga_atual = clonar(Ghazely, 12) + clonar(Ghostling, 10)
        26: vaga_atual = clonar(Ghazt, 10) + clonar(Ghoul, 10) + clonar(Ghazely, 6) + clonar(Ghaztling, 6)
        27: vaga_atual = clonar(Ghaztling, 15) + clonar(Ghazely, 8) + clonar(Ghoul, 5)
        28: vaga_atual = clonar(Ghoul, 15) + clonar(Ghazely, 8) + clonar(Ghazt, 10)
        29: vaga_atual = clonar(Ghazt, 12) + clonar(Ghazely, 10) + clonar(Ghaztling, 8)
        30: vaga_atual = clonar(Ghazely, 20) + clonar(Ghoul, 10)

        # Fase 4: Versões Enhanced
        31: vaga_atual = clonar(Ghazely, 10) + clonar(Enhanced_Ghaztling, 6) + clonar(Ghostling, 10)
        32: vaga_atual = clonar(Ghoul, 15) + clonar(Enhanced_Ghaztling, 8) + clonar(Ghazt, 5)
        33: vaga_atual = clonar(Ghaztling, 15) + clonar(Enhanced_Ghaztling, 10) + clonar(Ghazely, 8)
        34: vaga_atual = clonar(Enhanced_Ghoul, 6) + clonar(Ghoul, 15) + clonar(Ghazely, 5)
        35: vaga_atual = clonar(Enhanced_Ghoul, 8) + clonar(Enhanced_Ghaztling, 8) + clonar(Ghoul, 10)
        36: vaga_atual = clonar(Ghazely, 12) + clonar(Enhanced_Ghoul, 8) + clonar(Ghazt, 10)
        37: vaga_atual = clonar(Enhanced_Ghaztling, 15) + clonar(Ghaztling, 10) + clonar(Ghazely, 5)
        38: vaga_atual = clonar(Enhanced_Ghoul, 12) + clonar(Ghoul, 15) + clonar(Ghazely, 8)
        39: vaga_atual = clonar(Ghazely, 10) + clonar(Enhanced_Ghaztling, 10) + clonar(Enhanced_Ghoul, 8)
        40: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Ghazely, 10)
        41: vaga_atual = clonar(Enhanced_Ghaztling, 12) + clonar(Enhanced_Ghoul, 12) + clonar(Ghazt, 10)
        42: vaga_atual = clonar(Ghazely, 15) + clonar(Enhanced_Ghoul, 15) + clonar(Ghoul, 10)
        43: vaga_atual = clonar(Enhanced_Ghaztling, 15) + clonar(Enhanced_Ghoul, 12) + clonar(Ghazely, 10)
        44: vaga_atual = clonar(Enhanced_Ghoul, 25) + clonar(Enhanced_Ghaztling, 10)
        
        # Fase 5: Primeiro Mini-Boss (Aviso + Execução)
        45: 
            vaga_atual = clonar(Ghazely, 10) + clonar(Enhanced_Ghaztling, 12) + clonar(Enhanced_Ghoul, 8)
            animar_placa_boss()
        46: vaga_atual = clonar(Enhanced_Ghoul, 15) + clonar(Enhanced_Ghaztling, 15) + clonar(Ghazely, 5)
        47: vaga_atual = clonar(Enhanced_Ghoul, 25) + clonar(Ghoul, 15)
        48: vaga_atual = clonar(Enhanced_Ghaztling, 30) # Swarm rápido
        49: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Enhanced_Ghaztling, 20)
        50: vaga_atual = [Leviathan] + clonar(Enhanced_Ghoul, 10) + clonar(Ghazely, 10) # Leviathan e minions

        # Fase 6: Brutes e Força Bruta
        51: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Ghazely, 15)
        52: vaga_atual = clonar(Brute, 3) + clonar(Enhanced_Ghaztling, 15) + clonar(Ghazely, 10)
        53: vaga_atual = clonar(Brute, 4) + clonar(Enhanced_Ghoul, 15) + clonar(Enhanced_Ghaztling, 10)
        54: vaga_atual = clonar(Enhanced_Ghaztling, 12) + [Leviathan] + clonar(Enhanced_Ghaztling, 12) + clonar(Brute, 2)
        55: vaga_atual = clonar(Brute, 8) + clonar(Enhanced_Ghoul, 10)
        56: vaga_atual = clonar(Enhanced_Ghoul, 15) + clonar(Brute, 5) + clonar(Enhanced_Ghoul, 15)
        57: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Brute, 8) + clonar(Enhanced_Ghaztling, 10)
        58: vaga_atual = clonar(Brute, 6) + clonar(Enhanced_Ghaztling, 25)
        59: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Brute, 6) + clonar(Unholy_Phantasm, 4)
        60: vaga_atual = clonar(Brute, 15) + clonar(Enhanced_Ghoul, 15)
        61: vaga_atual = clonar(Brute, 8) + [Leviathan] + clonar(Brute, 4) + clonar(Enhanced_Ghaztling, 15)
        62: vaga_atual = clonar(Enhanced_Ghaztling, 20) + clonar(Brute, 10) + clonar(Unholy_Phantasm, 5)
        63: vaga_atual = clonar(Enhanced_Ghoul, 25) + clonar(Brute, 8) + clonar(Ghazely, 15)
        64: vaga_atual = [Leviathan] + clonar(Brute, 10) + [Leviathan] + clonar(Enhanced_Ghoul, 15)
        
        # Fase 7: Boss Azazel
        65: 
            vaga_atual = clonar(Brute, 12) + clonar(Enhanced_Ghaztling, 20) + clonar(Unholy_Phantasm, 5)
            animar_placa_boss("res://Assets/Enemies/Bosses/Azazel.png", "Ronda 70:")
        66: vaga_atual = clonar(Enhanced_Ghoul, 20) + clonar(Brute, 12) + clonar(Enhanced_Ghaztling, 15)
        67: vaga_atual = clonar(Leviathan, 3) + clonar(Brute, 10) + clonar(Enhanced_Ghoul, 15)
        68: vaga_atual = clonar(Brute, 25) # Muralha de Brutes
        69: vaga_atual = clonar(Brute, 10) + clonar(Leviathan, 2) + clonar(Enhanced_Ghoul, 20)
        70: vaga_atual = [Azazel] + clonar(Brute, 8) + clonar(Unholy_Phantasm, 8) # Azazel não vem sozinho

        # Fase 8: Azazel como Inimigo Comum / Elites
        71: vaga_atual = clonar(Brute, 15) + [Azazel] + clonar(Enhanced_Ghoul, 15)
        72: vaga_atual = clonar(Leviathan, 3) + [Azazel] + clonar(Enhanced_Ghaztling, 20)
        73: vaga_atual = clonar(Brute, 20) + clonar(Leviathan, 4) + clonar(Unholy_Phantasm, 10)
        74: vaga_atual = clonar(Enhanced_Ghoul, 20) + [Azazel] + clonar(Enhanced_Ghoul, 20)
        75: vaga_atual = clonar(Brute, 25) + [Azazel] + clonar(Leviathan, 2)
        76: vaga_atual = [Leviathan, Azazel, Leviathan] + clonar(Enhanced_Ghaztling, 25)
        77: vaga_atual = clonar(Enhanced_Ghaztling, 30) + [Azazel] + clonar(Brute, 15)
        78: vaga_atual = [Azazel, Azazel] + clonar(Unholy_Phantasm, 15)
        79: vaga_atual = clonar(Brute, 25) + clonar(Leviathan, 3) + clonar(Enhanced_Ghoul, 20)
        
        # Fase 9: Boss Belzebu
        80: 
            vaga_atual = [Azazel] + clonar(Brute, 15) + clonar(Leviathan, 2) + clonar(Enhanced_Ghoul, 20)
            animar_placa_boss("res://Assets/Enemies/Bosses/Belzebu.png", "Ronda 85:")
        81: vaga_atual = clonar(Brute, 30) + clonar(Unholy_Phantasm, 10)
        82: vaga_atual = [Azazel, Leviathan, Azazel] + clonar(Enhanced_Ghaztling, 25)
        83: vaga_atual = clonar(Brute, 35)
        84: vaga_atual = [Azazel, Azazel] + clonar(Brute, 20) + clonar(Unholy_Phantasm, 15)
        85: vaga_atual = [Belzebu] + clonar(Unholy_Phantasm, 15) + clonar(Brute, 10)

        # Fase 10: Caos Unholy
        86: vaga_atual = clonar(Brute, 20) + clonar(Unholy_Phantasm, 10) + clonar(Enhanced_Ghoul, 20)
        87: vaga_atual = clonar(Unholy_Phantasm, 25)
        88: vaga_atual = [Belzebu] + clonar(Unholy_Phantasm, 20) + clonar(Leviathan, 2)
        89: vaga_atual = clonar(Brute, 25) + clonar(Unholy_Phantasm, 15) + [Azazel]
        90: vaga_atual = clonar(Unholy_Phantasm, 30) + clonar(Enhanced_Ghaztling, 20)
        91: vaga_atual = [Azazel, Belzebu] + clonar(Brute, 20)
        92: vaga_atual = clonar(Unholy_Phantasm, 15) + clonar(Brute, 20) + clonar(Unholy_Phantasm, 15)
        93: vaga_atual = [Belzebu] + clonar(Leviathan, 5) + clonar(Enhanced_Ghoul, 30)
        94: vaga_atual = clonar(Unholy_Phantasm, 25) + clonar(Brute, 25)
        95: vaga_atual = [Belzebu, Belzebu] + clonar(Unholy_Phantasm, 20)
        96: vaga_atual = clonar(Unholy_Phantasm, 40) # Barreira de Phantasms
        97: vaga_atual = clonar(Brute, 30) + [Belzebu] + clonar(Leviathan, 3)
        98: vaga_atual = clonar(Unholy_Phantasm, 20) + [Belzebu] + clonar(Unholy_Phantasm, 20) + [Azazel]
        99: vaga_atual = [Belzebu, Azazel] + clonar(Leviathan, 4) + clonar(Brute, 20)
        100: vaga_atual = clonar(Brute, 45) + clonar(Unholy_Phantasm, 15)
        101: vaga_atual = clonar(Unholy_Phantasm, 35) + [Belzebu]
        102: vaga_atual = [Belzebu, Belzebu] + clonar(Brute, 30)
        103: vaga_atual = clonar(Unholy_Phantasm, 45)
        104: vaga_atual = [Azazel, Azazel, Belzebu] + clonar(Enhanced_Ghoul, 30)
        
        # Fase 11: Boss Fenrir
        105: 
            vaga_atual = clonar(Brute, 25) + clonar(Unholy_Phantasm, 25) + clonar(Leviathan, 5)
            animar_placa_boss("res://Assets/Enemies/Bosses/Fenrir.png", "Ronda 110:")
        106: vaga_atual = clonar(Belzebu, 3) + clonar(Brute, 20)
        107: vaga_atual = clonar(Unholy_Phantasm, 50)
        108: vaga_atual = clonar(Brute, 35) + [Belzebu, Belzebu]
        109: vaga_atual = [Belzebu, Azazel, Belzebu, Azazel] + clonar(Unholy_Phantasm, 20)
        110: vaga_atual = clonar(Fenrir, 3) + clonar(Brute, 20) + clonar(Unholy_Phantasm, 20)

        # Fase 12: Apocalipse / Multi-Bosses
        111: vaga_atual = clonar(Unholy_Phantasm, 30) + clonar(Fenrir, 3) + clonar(Leviathan, 5)
        112: vaga_atual = clonar(Brute, 40) + clonar(Fenrir, 4)
        113: vaga_atual = [Belzebu] + clonar(Fenrir, 3) + clonar(Unholy_Phantasm, 30)
        114: vaga_atual = clonar(Fenrir, 5) + clonar(Brute, 30)
        115: vaga_atual = clonar(Unholy_Phantasm, 40) + clonar(Fenrir, 3) + [Azazel, Azazel]
        116: vaga_atual = [Belzebu, Belzebu] + clonar(Fenrir, 3) + clonar(Enhanced_Ghoul, 40)
        117: vaga_atual = clonar(Fenrir, 6) + clonar(Leviathan, 6)
        118: vaga_atual = clonar(Brute, 50) + clonar(Fenrir, 3)
        119: vaga_atual = clonar(Fenrir, 7) + clonar(Unholy_Phantasm, 30)
        120: vaga_atual = [Azazel, Azazel] + clonar(Fenrir, 4) + clonar(Brute, 35)
        121: vaga_atual = clonar(Unholy_Phantasm, 45) + clonar(Fenrir, 5)
        122: vaga_atual = [Belzebu] + clonar(Fenrir, 6) + clonar(Enhanced_Ghaztling, 50)
        123: vaga_atual = clonar(Fenrir, 8) + clonar(Leviathan, 5)
        124: vaga_atual = clonar(Brute, 45) + clonar(Fenrir, 6)
        125: vaga_atual = clonar(Fenrir, 10) + clonar(Unholy_Phantasm, 30)
        
        # Fase 13: Pesadelo Final
        126: vaga_atual = [Leviathan, Azazel, Belzebu] + clonar(Fenrir, 4) + clonar(Brute, 30)
        127: vaga_atual = clonar(Unholy_Phantasm, 50) + clonar(Fenrir, 5) + [Azazel, Azazel]
        128: vaga_atual = [Belzebu, Belzebu] + clonar(Fenrir, 6) + clonar(Enhanced_Ghoul, 40)
        129: vaga_atual = [Azazel, Belzebu] + clonar(Fenrir, 5) + clonar(Leviathan, 8)
        130: vaga_atual = clonar(Leviathan, 10) + clonar(Brute, 40)
        131: vaga_atual = clonar(Unholy_Phantasm, 60) + clonar(Fenrir, 4)
        132: vaga_atual = clonar(Azazel, 5) + clonar(Enhanced_Ghaztling, 50)
        133: vaga_atual = clonar(Brute, 60) + [Belzebu, Belzebu]
        134: vaga_atual = clonar(Belzebu, 5) + clonar(Unholy_Phantasm, 40)
        135: vaga_atual = clonar(Fenrir, 12) + clonar(Brute, 30)
        136: vaga_atual = [Leviathan, Azazel, Belzebu] + clonar(Fenrir, 5) + clonar(Unholy_Phantasm, 35)
        137: vaga_atual = clonar(Belzebu, 4) + clonar(Fenrir, 8) + clonar(Brute, 40)
        138: vaga_atual = clonar(Azazel, 4) + clonar(Belzebu, 4) + clonar(Fenrir, 6)
        139: vaga_atual = clonar(Unholy_Phantasm, 55) + clonar(Belzebu, 3) + clonar(Fenrir, 6)
        140: vaga_atual = clonar(Belzebu, 8) + clonar(Leviathan, 10)
        141: vaga_atual = clonar(Fenrir, 15) + clonar(Enhanced_Ghoul, 50)
        142: vaga_atual = clonar(Unholy_Phantasm, 70) + clonar(Azazel, 5)
        143: vaga_atual = clonar(Brute, 70) + clonar(Belzebu, 4)
        144: vaga_atual = clonar(Azazel, 10) + clonar(Fenrir, 10)
        
        # Fase 14: Boss Lúcifer
        145: 
            vaga_atual = clonar(Belzebu, 5) + clonar(Fenrir, 12) + clonar(Unholy_Phantasm, 40)
            animar_placa_boss("res://Assets/Enemies/Bosses/Lucifer.png", "Ronda 150:")
        146: vaga_atual = clonar(Leviathan, 5) + clonar(Azazel, 4) + clonar(Belzebu, 4) + clonar(Fenrir, 8) + clonar(Brute, 40)
        147: vaga_atual = clonar(Unholy_Phantasm, 60) + clonar(Brute, 30) + clonar(Fenrir, 10)
        148: vaga_atual = clonar(Belzebu, 6) + clonar(Fenrir, 12) + clonar(Enhanced_Ghaztling, 60)
        149: vaga_atual = clonar(Azazel, 6) + clonar(Belzebu, 5) + clonar(Fenrir, 15) + clonar(Unholy_Phantasm, 50)

        150: vaga_atual = [Lucifer] + clonar(Fenrir, 5) + clonar(Belzebu, 3) + clonar(Azazel, 3) + clonar(Brute, 30) + clonar(Unholy_Phantasm, 30)

    if has_node("Timer"):
        $Timer.start()

func _on_timer_timeout():
    if vaga_atual.size() > 0:
        var cena_do_inimigo = vaga_atual.pop_front()
        var novo_fantasma = cena_do_inimigo.instantiate()
        var path = get_node_or_null("../Path2D")
        if path:
            path.add_child(novo_fantasma)
            inimigos_vivos += 1
    else:
        $Timer.stop()

func inimigo_morreu(PassPortal: bool = false):
    var hud = get_tree().get_first_node_in_group("HUD")
    
    var gacha = randi_range(1, 25)
    var AmountCoins = randi_range(25, 70)
    
    if gacha == 1 and PassPortal == false:
        hud.EarnBunnyCoins(AmountCoins)
        
    
    inimigos_vivos -= 1
    if inimigos_vivos < 0:
        inimigos_vivos = 0

    if vaga_atual.size() == 0 and inimigos_vivos == 0 and ronda_a_decorrer and hud.GameOver == false:
        ronda_a_decorrer = false
        
        if rodada_atual == 150:
            if hud and hud.has_method("victory"):
                hud.victory()
            return
        
        var moedas_no = get_tree().current_scene.find_child("Moedas")
        if moedas_no:
            moedas_no.text = str(int(moedas_no.text) + int(rodada_atual * 10) + moedas_fim_ronda_total)
        
        rodada_atual += 1
        atualizar_contador_rondas()
        
        if SaveManager.autoplay == true and hud.GameOver == false:
            iniciar_vaga()

func atualizar_contador_rondas() -> void:
    var contador_no = get_tree().get_first_node_in_group("Round_Counter")
    if contador_no:
        contador_no.text = str(rodada_atual)

func atualizar_moedas_buff() -> void:
    moedas_fim_ronda_total = moedas_fim_ronda + moedas_fim_ronda_bonus
