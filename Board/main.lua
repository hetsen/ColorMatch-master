--function print() end
local t = {"level 1-01","level 1-02","level 1-03","level 1-04","level 1-05","level 1-06","level 1-07","level 1-08","level 1-09","level 1-10","level 1-11","level 1-12","level 1-13","level 1-14","level 1-15","level 1-16","level 2-01","level 2-02","level 2-03","level 2-04","level 2-05","level 2-06","level 2-07","level 2-08","level 2-09","level 2-10","level 2-11","level 2-12","level 2-13","level 2-14","level 2-15","level 2-16","level 3-01","level 3-02","level 3-03","level 3-04","level 3-05","level 3-06","level 3-07","level 3-08","level 3-09","level 3-10","level 3-11","level 3-12","level 3-13","level 3-14","level 3-15","level 3-16","level 4-01","level 4-02","level 4-03","level 4-04","level 4-05","level 4-06","level 4-07","level 4-08","level 4-09","level 4-10","level 4-11","level 4-12","level 4-13","level 4-14","level 4-15","level 4-16","level 5-01","level 5-02","level 5-03","level 5-04","level 5-05","level 5-06","level 5-07","level 5-08","level 5-09","level 5-10","level 5-11","level 5-12","level 5-13","level 5-14","level 5-15","level 5-16","level 6-01","level 6-02","level 6-03","level 6-04","level 6-05","level 6-06","level 6-07","level 6-08","level 6-09","level 6-10","level 6-11","level 6-12","level 6-13","level 6-14","level 6-15","level 6-16","level 7-01","level 7-02","level 7-03","level 7-04","level 7-05","level 7-06","level 7-07","level 7-08","level 7-09","level 7-10","level 7-11","level 7-12","level 7-13","level 7-14","level 7-15","level 7-16","level 8-01","level 8-02","level 8-03","level 8-04","level 8-05","level 8-06"}

--[[
function downloadLevels(levelName)
    local function networkListener( event )
        if ( event.isError ) then
            print( "Network error - download failed: ", event.response )
        elseif ( event.phase == "began" ) then
            print( "Downloading" )
        elseif ( event.phase == "ended" ) then
            print( "Done" )
        end
    end

    local params = {}
    params.progress = true
 
    network.download(
        "https://creftan.com/idiot/levels/"..levelName,
        "GET",
        networkListener,
        params,
        levelName,
        system.DocumentsDirectory
    )
end

for i=1,#t do
    downloadLevels(tostring(t[i]))
end
]]--

--[[ Filthy damn anodrid level fix ]]
local lfs = require( "lfs" )
path = system.pathForFile( nil, system.DocumentsDirectory )
checkDir = lfs.chdir(system.pathForFile("levels", system.DocumentsDirectory))
if checkDir then
    
else
    success = lfs.chdir( path )
    if success then 
        lfs.mkdir( "levels" )
    end
end

t =  {"level 1-01","level 1-02","level 1-03","level 1-04","level 1-05","level 1-06","level 1-07","level 1-08","level 1-09","level 1-10","level 1-11","level 1-12","level 1-13","level 1-14","level 1-15","level 1-16","level 2-01","level 2-02","level 2-03","level 2-04","level 2-05","level 2-06","level 2-07","level 2-08","level 2-09","level 2-10","level 2-11","level 2-12","level 2-13","level 2-14","level 2-15","level 2-16","level 3-01","level 3-02","level 3-03","level 3-04","level 3-05","level 3-06","level 3-07","level 3-08","level 3-09","level 3-10","level 3-11","level 3-12","level 3-13","level 3-14","level 3-15","level 3-16","level 4-01","level 4-02","level 4-03","level 4-04","level 4-05","level 4-06","level 4-07","level 4-08","level 4-09","level 4-10","level 4-11","level 4-12","level 4-13","level 4-14","level 4-15","level 4-16","level 5-01","level 5-02","level 5-03","level 5-04","level 5-05","level 5-06","level 5-07","level 5-08","level 5-09","level 5-10","level 5-11","level 5-12","level 5-13","level 5-14","level 5-15","level 5-16","level 6-01","level 6-02","level 6-03","level 6-04","level 6-05","level 6-06","level 6-07","level 6-08","level 6-09","level 6-10","level 6-11","level 6-12","level 6-13","level 6-14","level 6-15","level 6-16","level 7-01","level 7-02","level 7-03","level 7-04","level 7-05","level 7-06","level 7-07","level 7-08","level 7-09","level 7-10","level 7-11","level 7-12","level 7-13","level 7-14","level 7-15","level 7-16","level 8-01","level 8-02","level 8-03","level 8-04","level 8-05","level 8-06","level 8-07","level 8-08","level 8-09","level 8-10","level 8-11","level 8-12","level 8-13","level 8-14","level 8-15","level 8-16"}

function networkListener( event )
    if ( event.isError ) then
        print( "Network error: ", event.response )
        elseif ( event.phase == "began" ) then
            if ( event.bytesEstimated <= 0 ) then
                print( "Download starting, size unknown" )
            else
                print( "Download starting, estimated size: " .. event.bytesEstimated )
            end
         
        elseif ( event.phase == "progress" ) then
            if ( event.bytesEstimated <= 0 ) then
                print( "Download progress: " .. event.bytesTransferred )
            else
                print( "Download progress: " .. event.bytesTransferred .. " of estimated: " .. event.bytesEstimated )
            end
         
        elseif ( event.phase == "ended" ) then
            print( "Download complete, total bytes transferred: " .. event.bytesTransferred )
    end
end

for i=1,#t do
    levelFile = system.pathForFile( "levels/"..t[i], system.DocumentsDirectory )
    fh, reason = io.open( levelFile, "r" )
    if fh then
        io.close( fh )
        print( levelFile.." exists!" )
    else
        local params = {}
        params.progress = "download"
        params.response = {
            filename = "levels/"..t[i],
            baseDirectory = system.DocumentsDirectory
        }
        network.request( "https://creftan.com/idiot/levels/"..t[i], "GET", networkListener,  params )
    end
end
--[[ END  Filthy damn anodrid level fix ]]


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


