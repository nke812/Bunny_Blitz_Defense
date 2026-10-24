extends Node

const SAVE_PATH = "user://achievements.cfg"

var DailyBudy = 0
var DailyBudyPROGRESS = 0

var FancyBunnies = 0

var IWantThatOne = 0
var IWantThatOnePROGRESS = 0

var IAmRichAsBunny = 0
var IAmRichAsBunnyPROGRESS = 0

var ALittleTinyBunny = 0

var KillThemAll = 0
var KillThemAllPROGRESS = 0

var WinGrassLands = 0

var WinShimmerRoads = 0

var WinSandStreets = 0

func _ready() -> void:
    carregar_dados()

func carregar_dados() -> void:
    var config = ConfigFile.new()
    var erro = config.load(SAVE_PATH)

    if erro != OK:
        guardar_dados()
        return
        
    DailyBudy = config.get_value("achievements", "DailyBudy", 0)
    DailyBudyPROGRESS = config.get_value("progress", "DailyBudyPROGRESS", 0)
    
    FancyBunnies = config.get_value("achievements", "FancyBunnies", 0)
    
    IWantThatOne = config.get_value("achievements", "IWantThatOne", 0)
    IWantThatOnePROGRESS = config.get_value("progress", "IWantThatOnePROGRESS", 0)
    
    IAmRichAsBunny = config.get_value("achievements", "IAmRichAsBunny", 0)
    IAmRichAsBunnyPROGRESS = config.get_value("progress", "IAmRichAsBunnyPROGRESS", 0)
    
    ALittleTinyBunny = config.get_value("achievements", "ALittleTinyBunny", 0)
    
    KillThemAll = config.get_value("achievements", "KillThemAll", 0)
    KillThemAllPROGRESS = config.get_value("progress", "KillThemAllPROGRESS", 0)
    
    WinGrassLands = config.get_value("achievements", "WinGrassLands", 0)
    WinShimmerRoads = config.get_value("achievements", "WinShimmerRoads", 0)
    WinSandStreets = config.get_value("achievements", "WinSandStreets", 0)

func guardar_dados() -> void:
    var config = ConfigFile.new()
    
    config.set_value("achievements", "DailyBudy", DailyBudy)
    config.set_value("progress", "DailyBudyPROGRESS", DailyBudyPROGRESS)
    
    config.set_value("achievements", "FancyBunnies", FancyBunnies)
    
    config.set_value("achievements", "IWantThatOne", IWantThatOne)
    config.set_value("progress", "IWantThatOnePROGRESS", IWantThatOnePROGRESS)
    
    config.set_value("achievements", "IAmRichAsBunny", IAmRichAsBunny)
    config.set_value("progress", "IAmRichAsBunnyPROGRESS", IAmRichAsBunnyPROGRESS)
    
    config.set_value("achievements", "ALittleTinyBunny", ALittleTinyBunny)
    
    config.set_value("achievements", "KillThemAll", KillThemAll)
    config.set_value("progress", "KillThemAllPROGRESS", KillThemAllPROGRESS)
    
    config.set_value("achievements", "WinGrassLands", WinGrassLands)
    config.set_value("achievements", "WinShimmerRoads", WinShimmerRoads)
    config.set_value("achievements", "WinSandStreets", WinSandStreets)
    
    config.save(SAVE_PATH)
