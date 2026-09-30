extends Node

const SAVE_PATH = "user://player.cfg"

var BunnyCoins: int = 500

var LastDaily: int = 0
var LastAcessDaily: int = 0

var autoplay: bool = false
var CorruptedVisible: bool = false

var ScrappyUnlocked: bool = false
var GhoulishUnlocked: bool = false
var MysticalUnlocked: bool = false
var CorruptedUnlocked: bool = false
var AlienUnlocked: bool = false
var DollUnlocked: bool = false
var MoltenUnlocked: bool = false
var ToastyUnlocked: bool = false
var VoodoUnlocked: bool = false

var bunyUnlocked: bool = false
var CanelaUnlocked: bool = false
var CatharsisUnlocked: bool = false
var VoidUnlocked: bool = false
var ZeRonUnlocked: bool = false

func _ready() -> void:
    carregar_dados()

func carregar_dados() -> void:
    var config = ConfigFile.new()
    var erro = config.load(SAVE_PATH)

    if erro != OK:
        guardar_dados()
        return
        
    BunnyCoins = config.get_value("Player", "Bunny Coins", 500)
    
    autoplay = config.get_value("Jogo", "autoplay", false)
    CorruptedVisible = config.get_value("Segredos", "CorruptedVisible", false)
    
    ScrappyUnlocked = config.get_value("Bunnies", "Scrappy", false)
    GhoulishUnlocked = config.get_value("Bunnies", "Ghoulish", false)
    MysticalUnlocked = config.get_value("Bunnies", "Mystical", false)
    CorruptedUnlocked = config.get_value("Bunnies", "Corrupted", false)
    AlienUnlocked = config.get_value("Bunnies", "Alien", false)
    DollUnlocked = config.get_value("Bunnies", "Doll", false)
    MoltenUnlocked = config.get_value("Bunnies", "Molten", false)
    ToastyUnlocked = config.get_value("Bunnies", "Toasty", false)
    VoodoUnlocked = config.get_value("Bunnies", "Voodo", false)
    
    bunyUnlocked = config.get_value("Skins", "buny", false)
    CanelaUnlocked = config.get_value("Skins", "Canela", false)
    CatharsisUnlocked = config.get_value("Skins", "Catharsis", false)
    VoidUnlocked = config.get_value("Skins", "Void", false)
    ZeRonUnlocked = config.get_value("Skins", "Zé Ron", false)
    
    LastDaily = config.get_value("Daily", "LastDaily", 0)
    LastAcessDaily = config.get_value("Daily", "LastAcessDaily", 0)
    
func guardar_dados() -> void:
    var config = ConfigFile.new()
    
    config.set_value("Player", "Bunny Coins", BunnyCoins)
    
    config.set_value("Jogo", "autoplay", autoplay)
    config.set_value("Segredos", "CorruptedVisible", CorruptedVisible)
    
    config.set_value("Bunnies", "Scrappy", ScrappyUnlocked)
    config.set_value("Bunnies", "Ghoulish", GhoulishUnlocked)
    config.set_value("Bunnies", "Mystical", MysticalUnlocked)
    config.set_value("Bunnies", "Corrupted", CorruptedUnlocked)
    config.set_value("Bunnies", "Alien", AlienUnlocked)
    config.set_value("Bunnies", "Doll", DollUnlocked)
    config.set_value("Bunnies", "Molten", MoltenUnlocked)
    config.set_value("Bunnies", "Toasty", ToastyUnlocked)
    config.set_value("Bunnies", "Voodo", VoodoUnlocked)
    
    config.set_value("Skins", "buny", bunyUnlocked)
    config.set_value("Skins", "Canela", CanelaUnlocked)
    config.set_value("Skins", "Catharsis", CatharsisUnlocked)
    config.set_value("Skins", "Void", VoidUnlocked)
    config.set_value("Skins", "Zé Ron", ZeRonUnlocked)
    
    config.set_value("Daily", "LastDaily", LastDaily)
    config.set_value("Daily", "LastAcessDaily", LastAcessDaily)
    
    config.save(SAVE_PATH)

func unlock_corrupted() -> void:
    CorruptedVisible = true
    guardar_dados()


#-----   RESET   -----
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("Reset"):
        reset_save()
    
    if event.is_action_pressed("SaveLoad"):
        guardar_dados()
        carregar_dados()
        
    

func reset_save() -> void:
    BunnyCoins = 500
    autoplay = false
    CorruptedVisible = false
        
    ScrappyUnlocked = false
    GhoulishUnlocked = false
    MysticalUnlocked = false
    CorruptedUnlocked = false
    AlienUnlocked = false
    DollUnlocked = false
    MoltenUnlocked = false
    ToastyUnlocked = false
    VoodoUnlocked = false

    bunyUnlocked = false
    CanelaUnlocked = false
    CatharsisUnlocked = false
    VoidUnlocked = false
    ZeRonUnlocked = false
    
    LastDaily = 0
    LastAcessDaily = 0
      
    guardar_dados()
    get_tree().reload_current_scene()
