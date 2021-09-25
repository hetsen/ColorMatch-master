f--function print() end

display.setStatusBar(display.HiddenStatusBar)
local composer 	= require "composer"
	  store 		= require("store")
local aud 			= require "audioo"
local tenflib 		= require "tenfLib"
local json 			= require "json"
local dd 			= require "devicedetector"
	  gameNetwork	= require "gameNetwork"
	  ach 			= require "modules.ach"
	  social		= require "modules.socialModule"
   _G.createButton	= require "modules.buttonModule"

gcIsActive = false
replaymode = false

if gcIsActive then
	gameNetwork.init( "gamecenter", initCallback )
else
	print("GameCenter Disabled.")
end

isSave = tenflib.jsonLoad("gcSaves")
if isSave then

else
	local gcSaves = tenflib.jsonSave("gcSaves",
	{
		fortyTwo=0,
		colorsPicked=0,
		redColorsPicked=0,
		greenColorsPicked=0,
		blueColorsPicked=0, 
		levelsPlayed=0,
		levelsFailed=0,
		restarts=0,
		stars=0,
		started=0,
	})
	isThereAsave = true
end
achSaves = tenflib.jsonLoad("gcSaves")
local model = dd.get()

sounds = aud.loadsounds()
ads = require("ads")

local music = tenflib.jsonLoad("music.txt")
local sound = tenflib.jsonLoad("sound.txt")

if music then 
	aud.setmusicvolume(music.music)
	globalmusicvolume = music.music
else 
	globalmusicvolume = 1
	aud.setmusicvolume(1)
end 

if sound then
	aud.setsoundvolume(sound.sound)
	globalsoundvolume = sound.sound
else 
	globalsoundvolume = 1
	aud.setsoundvolume(1)
end

_G.inAppPurchaseProcessing = require 'inAppPurchaseProcessing'

print("Function store callback: ", _G.inAppPurchaseProcessing.transactionCallback)

if store.availableStores.apple then
	print("Apple store is available on device. Trying to init...")
	store.init("apple", _G.inAppPurchaseProcessing.transactionCallback)
else
	print("Apple store not available...")
end

_W = display.contentWidth
_H = display.contentHeight

globalresolution = {_W,_H}

--local gamelogic 	= require "gamelogic"
--local renderer		= require "Renderer"

--debug

_G.worldListOrder = {
	'Find the Cure',
	'Glistening Tides',
	'Moving Destiny',
	'Drowning Sorrows',
}


_G.appleProductList = {
	"se.10fingers.findthecure.levelpack0",
	"se.10fingers.findthecure.levelpackA",
	"se.10fingers.findthecure.allLevelsTest",
	"SE.10fingers.findthecure.noAdsTest",
}


local loadedWorldList = tenflib.jsonLoad('worldList') or {}

local loadedPurchases = tenflib.jsonLoad('purchases') or {}

for k,v in pairs(loadedWorldList) do
	if loadedPurchases[v.productIdentifier] then
		_G.inAppPurchaseProcessing.updateIAPSettings(v)
	end
end

local loadedIAPSettings = tenflib.jsonLoad('IAPSettings') or {}

_G.lockdown = true
_G.lockdownlimit = 65
_G.lockdownWorldLimit = {
	['Find the Cure'] = 65,
	--['Glistening Tides'] = 65,
}

local worlds = {
	['Find the Cure'] = "FindtheCure",
	--['Glistening Tides'] = "GlisteningTides",
}
print(worlds[1])
_G.debugmode = false 

_G.model = model
_G.appVersion = '1.0.0'
_G.adsEnabled = loadedIAPSettings.adsEnabled or false
_G.customLevelsEnabled = true
_G.shareEnabled = true
_G.worldsUnlocked = loadedIAPSettings.worldsUnlocked or {
	['Find the Cure'] = true,

	-- Ska vara false när patchen släpps!
	--['Glistening Tides'] = false,
}

_G.adSpace = 0

if not _G.adsEnabled then
	if model == 'iPad' or model == "iPad Retina" then
		_G.adSpace = 33 -- 66*0.5
	else
		_G.adSpace = 25 -- 50*0.5
	

 
function adListener(event)
    local msg = event.response
    if event.isError then
        -- Failed to receive an ad, we print the error message returned from the library.
        print(msg)
    end
end
 




	end
end

--ads.init( "iads", "se.10fingers.findthecure", adListener )

_G.tinyFontSize 		= 6
_G.smallFontSize		= 10
_G.mediumSmallFontSize	= 15
_G.mediumFontSize		= 20
_G.mediumLargeFontSize	= 30
_G.largeFontSize		= 40
_G.hugeFontSize 		= 60

_G.levelSelectColor 	= {128,0,255} -- För level select och level editor
_G.replayColor 			= {0,128,255} -- För replay
_G.continueColor 		= {255,255,0} -- För user levels, continue och back
_G.playColor 			= {0,255,0}   -- För play och story mode
_G.mainMenuColor 		= {255,128,0} -- för main menu och options

print ("Device : ".._G.model)

systemfont = "Averia-Bold"

-- function onLoading()

-- 	_G.loadingScreen:toFront()

-- 	if _G.loadingScreen.dir == 1 then
-- 		_G.loadingScreen.fg.alpha = _G.loadingScreen.fg.alpha + 0.05
-- 	elseif _G.loadingScreen.dir == -1 then
-- 		_G.loadingScreen.fg.alpha = _G.loadingScreen.fg.alpha - 0.05
-- 	else
-- 		_G.loadingScreen.dir = -1
-- 		_G.loadingScreen.fg.alpha = 1
-- 	end

-- 	if _G.loadingScreen.fg.alpha >= 1 then
-- 		_G.loadingScreen.dir = -1
-- 	elseif _G.loadingScreen.fg.alpha <= 0 then
-- 		_G.loadingScreen.dir = 1
-- 	end
-- end

_G.loadingScreen = display.newGroup()

local fullBg = display.newRect(loadingScreen, 0, 0, _W, _H)
fullBg.x, fullBg.y = 0, 0
fullBg:setFillColor(0)

-- local loadingText = display.newText(loadingScreen, 'Loading', 0, 0, systemfont, _G.largeFontSize)
-- loadingText.x, loadingText.y = 0, - _H*0.2

local bg = display.newImageRect(loadingScreen, 'Graphics/UI/loading_vial.png', 290, 365)
bg.x, bg.y = 0, 0

local fg = display.newImageRect(loadingScreen, 'Graphics/UI/loading_glow.png', 290, 365)
fg.x, fg.y = 0, 0
fg.alpha = 0.75

_G.loadingScreen.bg = bg
_G.loadingScreen.fg = fg
--_G.loadingScreen.onLoading = onLoading
_G.loadingScreen.x, _G.loadingScreen.y = _W*0.5, _H*0.5
_G.loadingScreen.alpha = 0

-- composer.gotoScene("modules.autoLAN.sendObject", {
-- 	params = {
-- 		mapToSend = {
-- 			fileName = "levels/level 1-01",
-- 			fileDir = system.ResourceDirectory,
-- 		}
-- 	}
-- })
--composer.gotoScene("modules.autoLAN.receiveObject")

--composer.gotoScene('trailercode')

local ratingData = tenflib.jsonLoad('ratingData') or {count = 5}
ratingData.count = ratingData.count - 1
tenflib.jsonSave('ratingData', ratingData)

if ratingData.count <= 0 and not ratingData.neverAsk then
	ratingData.count = 5

	local function rateResponse(e)
		if e.index == 1 or e.index == 2 then
			ratingData.neverAsk = true
		end

		tenflib.jsonSave('ratingData', ratingData)

		if e.index == 1 then
			local rateit = require("modules.rateit")
			rateit.setiTunesURL(661706323)
			rateit.openURL()
		end
	end

	native.showAlert('Rate and Review', 'We would very much appreciate it if you would take a minute to rate and review our app.', {'Rate it', 'Never ask me again', 'Not now'}, rateResponse)
end


composer.gotoScene('startscreen')





--composer.gotoScene("tutorial", {params = {tutorial = 'tutorial1'}})
--


