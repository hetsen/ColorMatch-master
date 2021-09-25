local composer 	= require "composer"
local scene 		= composer.newScene()


function scene:create(e)

local blob = {}
local background = display.newImageRect ("Graphics/Backgrounds/dancefloor01.png",_W,_H)
local kingblob 
local mrblob
background.x = _W/2
background.y = _H/2
x = -10 
local positionlist
local function kingblink()
	transition.to (kingblob.eye[1], {time = 50, yScale = .01})
	transition.to (kingblob.eye[2], {delay = 10, time = 50, yScale = .01, onComplete = function ()
		transition.to (kingblob.eye[1], {time = 50, yScale = 1})
		transition.to (kingblob.eye[2], {delay = 10, time = 50, yScale = 1})
		end })
	
	transition.to (kingblob.eye[1].p, {time = 50, yScale = .01})
	transition.to (kingblob.eye[2].p, {delay = 10, time = 50, yScale = .01, onComplete = function ()
		transition.to (kingblob.eye[1].p, {time = 50, yScale = 1})
		transition.to (kingblob.eye[2].p, {delay = 10, time = 50, yScale = 1})

		end })
end 

local function createking()
	kingbubble = display.newImageRect("Graphics/Objects/textbubble_1200x600.png", 240,120)
	kingbubble.x = _W/2 - 25
	kingbubble.y = 50
	kingbubble.alpha = 0 

	blobbubble = display.newImageRect("Graphics/Objects/textbubble_1200x600.png", 120,60)
	blobbubble.x = _W/2 - 60
	blobbubble.y = 180
	--blobbubble.xScale = -1
	blobbubble.alpha = 0 


	kingspeak = display.newText ("", 0,0,systemfont, 30)
	kingspeak.x = _W/2 - 25
	kingspeak.y = 50
	kingspeak:setTextColor (0,0,0)
	blobspeak = display.newText ("", 0,0,systemfont, 30)
	blobspeak.x = _W/2 - 60 
	blobspeak.y = 180
	blobspeak:setTextColor (0,0,0)

	kingblob = display.newGroup()
	kingblob.blob = display.newImageRect (kingblob, "pics/marker.png", 150, 150)
	kingblob.blob.xScale = .8
	kingblob.eye = {}
	kingblob.eye.p = {}
	kingblob.blob:setFillColor (140,180,255)
	kingblob.blob.alpha = .8

	for i = 1,2 do 
		kingblob.eye[i] = display.newImageRect (kingblob,"Graphics/Objects/eye_sclera.png",25,25)
		kingblob.eye[i].y = -10
		kingblob.eye.p[i] = display.newImageRect (kingblob,"Graphics/Objects/eye_pupil.png",25,25)
		kingblob.eye.p[i].y = -10
	
	end 
	
	kingblob.eye[1].x = -15
	kingblob.eye[2].x = 15
	kingblob.eye.p[1].x = -15
	kingblob.eye.p[2].x = 15

	kingblob.beard = display.newImageRect (kingblob,"Graphics/Objects/beard.png",50,25)
	kingblob.beard.y = 28

	kingblob.stash = display.newImageRect (kingblob,"Graphics/Objects/mustasch.png",40,15)
	kingblob.stash.y = 20

	kingblob.crown = display.newImageRect (kingblob,"Graphics/Objects/crown.png",40,15)
	kingblob.crown.y = -60
	kingblob.crown.x = 8
	kingblob.crown.rotation = 15
	
	
	kingblob.x = _W/2 + 30 
	kingblob.y = _H/2 + _H/10
end

local function blinkblobs()
	z = math.random (3)
	if z == 2 then 
	blink = math.random (#positionlist.x)
	transition.to (blob[blink].eye[1], {time = 50, yScale = .01})
	transition.to (blob[blink].eye[2], {delay = 10, time = 50, yScale = .01, onComplete = function ()
		transition.to (blob[blink].eye[1], {time = 50, yScale = 1})
		transition.to (blob[blink].eye[2], {delay = 10, time = 50, yScale = 1})
		end })
end 
end 

counter = 0 

local function moveblobs()
	counter = counter + .1
	for i = 1,#positionlist.x do 
		blob[i].xScale = math.sin(counter+ blob[i].offset)*.01 + 1
		blob[i].yScale = math.cos(counter+ blob[i].offset)*.01 + .8
	end 
end 

local function createblobs()

positionlist = {x = {-120		,-100	,100	,-37	, 130 }, 
					  y = {0		,20		,0		,10 	, 10}, 
					  z = {.8 		,1.1 	,1 		,1 		, 1.2 }}

	for i = 1, #positionlist.x do 
		blob[i] = display.newGroup()
		blob[i].blob =  display.newImageRect (blob[i], "pics/marker.png", 60, 60)
		blob[i].blob.xScale = .8
		blob[i].blob.alpha  = .8
		blob[i].offset = math.random(360)
		blob[i].eye = {}
		for j =  1,2 do 
			blob[i].eye[j] = display.newImageRect (blob[i],"Graphics/Objects/eye_sclera.png",15,15)
			blob[i].eye[j].y = -6
			
			blob[i].eye[j].p = display.newImageRect (blob[i],"Graphics/Objects/eye_pupil.png",15,15)
			blob[i].eye[j].p.y = -6
		end 

			blob[i].eye[1].x = -8
			blob[i].eye[2].x = 8
			blob[i].eye[1].p.x = -8
			blob[i].eye[2].p.x = 8


		blob[i].x = _W/2 + positionlist.x[i]
		blob[i].y = _H/2 + _H/10 + positionlist.y[i]
		blob[i].xScale, blob[i].yScale = positionlist.z[i],positionlist.z[i]
		blob[i].blob:setFillColor(156,176,113)
	end

runtime = timer.performWithDelay(400,blinkblobs,0)

end

local function movemouth()
	transition.to (kingblob.stash, {time = 100, rotation  = math.random (-10,10), onComplete = function ()
		transition.to (kingblob.stash, {time = 100, rotation  = math.random (-10,10)})
		end 
		})
	transition.to (kingblob.beard, {time = 100, rotation  = math.random (-10,10), onComplete = function ()
		transition.to (kingblob.beard, {time = 100, rotation  = math.random (-10,10)})
		end 
		})
end  

local function moveblob(blob,x)
		transition.to (mrblob, {time = 100, xScale=1.8, yScale = .8})
		transition.to (mrblob, {delay = 100, time = 100, xScale=1, yScale = 1, onComplete = function () done = true end })
		transition.to (mrblob, {time = 100, x = x})
end 

local function moveblobout()
			x=x+32
			print (x)
			moveblob(Sblob,x)
			
			if x>_W + 100 then 
				timer.cancel(mm)
				
			end 
		end

local function kingspeakr()
timer.performWithDelay (100, function () kingspeak.text = "We're Sick!"; kingblink() kingbubble.alpha = 1 end)
timer.performWithDelay (1000, function () kingspeak.text = "We're Oval!!"; kingblink() end)
timer.performWithDelay (1500, function () kingspeak.text = "You're Round!!!"; kingblink()end)
timer.performWithDelay (2300, function () kingspeak.text = "FIX US!" ; kingblink() end)
timer.performWithDelay (3000, function () kingspeak.text = "" ; kingblink() timer.cancel(tt) kingbubble.alpha = 0 end)
timer.performWithDelay (3500, function () blobspeak.text = "OK!" ; kingblink() blobbubble.alpha = 1 end)
timer.performWithDelay (4000, function () blobspeak.text = "" ; kingblink() blobbubble.alpha = 0 mm = timer.performWithDelay(300,moveblobout,0) end)








end 


local function createmrblob()
	mrblob = display.newGroup()
	mrblob.blob =  display.newImageRect (mrblob, "pics/marker.png", 60, 60)
	mrblob.eye = {}

		for j =  1,2 do 
			mrblob.eye[j] = display.newImageRect (mrblob,"Graphics/Objects/eye_sclera.png",15,15)
			mrblob.eye[j].y = -6
			
			mrblob.eye[j].p = display.newImageRect (mrblob,"Graphics/Objects/eye_pupil.png",15,15)
			mrblob.eye[j].p.y = -6
		end 
			mrblob.eye[1].x = 15
			mrblob.eye[2].x = 10
			mrblob.eye[1].p.x = 19
			mrblob.eye[2].p.x = 13
			mrblob.eye[1].p.y = -7
			mrblob.eye[2].p.y = -6


mrblob.x = -100
mrblob.y = _H/2 + _H/4

end 







local function addtoX()
			x=x+32
			print (x)
			moveblob(Sblob,x)
			
			if x>_W/2 - 50 then 
				timer.cancel(mt)
				kingblink()
				kingspeakr()
				tt = timer.performWithDelay(300,movemouth,0)
			end 
		end


		

createking()
createblobs()
createmrblob()
blobbubble:toFront()
blobspeak:toFront()

mt = timer.performWithDelay(300,addtoX,0)

Runtime:addEventListener("enterFrame", moveblobs)

end 

function scene:show(e)
end 

function scene:hide(e)
end 

function scene:destroy(e)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
