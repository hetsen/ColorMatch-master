local composer 	= require "composer"
local scene 		= composer.newScene()
local physics = require "physics"
physics.start()


local blinkSong = audio.loadStream("Sound/blinksSong.mp3")
local startpos = {}
startpos.x = {}
startpos.y = {}
local flash 
local titles
local names
local doTransitions
local globalIteration = 1
local blinking = false
local arm
local hand
local finger1
local finger2
local finger3
local eyeLeft
local eyeRight
local rect
local titles
local blinky
local doTransitions
local headGroup = display.newGroup()
local eyeGroup = display.newGroup()
local armGroup = display.newGroup() --Who dis?
armGroup.alpha = 0.01
local displayGroup	= display.newGroup()
local stopIt
local gotoStart
local onFrame
local bloblist = 30
local marker = {}
local Sblob = {}
local hasLeftScene = false
local lotsablobs
local gcounter = 0 
function scene:create(e)
	system.setIdleTimer( false )

	local group = self.view
	local background = display.newImageRect (group,"Graphics/Backgrounds/dancefloor01.png",_W,_H)
	background.x = _W*.5
	background.y = _H*.5
	background:setFillColor(200/255)
	background:toBack()
	hasLeftScene = false
	audio.setVolume(globalmusicvolume, {channel = 2})

	group:insert(headGroup)
	group:insert(eyeGroup)
	group:insert(armGroup)
	group:insert(displayGroup)
	



	
	arm = display.newRect(armGroup,0,0,15,900)
	hand = display.newRect(armGroup,0,0,25,20)
	finger1 = display.newRect(armGroup,0,0,8,25)
	finger2 = display.newRect(armGroup,0,0,7,10)
	finger3 = display.newRect(armGroup,0,0,7,10)
	finger3.y=-2
	finger3.x=15
	finger2.y=-2
	finger2.x=7
	finger1.y=-10
	finger1.x=-1
	hand.x=7
	--armGroup:setReferencePoint(display.TopCenterReferencePoint)
	armGroup.anchorX = .5
	armGroup.anchorY = 0
	armGroup.y=_H
	armGroup.x=150
	rect = display.newRect(headGroup,0,0,50,50)
	rect.y = 0
	rect.x = rect.x + 20
	eyeLeft = display.newRect(eyeGroup,0,0,10,15)
	eyeLeft.x, eyeLeft.y = rect.x, rect.y
	eyeLeft.x, eyeLeft.y = eyeLeft.x-10, eyeLeft.y-10
	eyeRight = display.newRect(eyeGroup,0,0,10,15)
	eyeRight.x, eyeRight.y = rect.x, rect.y
	eyeRight.x, eyeRight.y = eyeLeft.x+20, eyeLeft.y
	eyeLeft:setFillColor(0)
	eyeRight:setFillColor(0)
	headGroup.y = _H+rect.height*.5
	headGroup:insert(eyeGroup)
	eyeGroup.anchorX = .5
	eyeGroup.anchorY = .5
	--eyeGroup:setReferencePoint(display.CenterReferencePoint)
	group:toFront()
	--</dude>
	-- Name
	titleList = {
		{title = 'Developers', 			names = {'Mikael Isaksson', 'Stian Saunes', 'Emil Karlsson'}},
		{title = 'Project Manager', 	names = {'Jens Tornberg'}},
		{title = 'Art Director', 		names = {'Joachim Carlsson'}},
		{title = 'Level Design', 		names = {'Emil Karlsson'}},
		{title = 'Sound Design', 		names = {'Stian Saunes'}},
		{title = 'Music', 				names = {'Stian Saunes','Mikael Isaksson'}},
		{title = 'Game Concept', 		names = {'Jens Tornberg'}},
		{title = 'Technical Advisors', 	names = {'Oskar Andersson','Tommy Lindh','Marcus Thunström'}},
		{title = 'Testers', 			names = {'Joel Carlsson', 'Marcus Thunström', 'Kevin Sund'}},
		--{title = 'Produced by', 		names = {'10FINGERS AB'}},
		{title = 'Produced by', 		names = {'ONEFINGERS'}},
		{title = 'Special thanks to', 	names = {'Fredrik Zetterstrand', 'Caleb Place'}},
	}


	--<dude>

	local function movegiant()
		transition.to (giant, {time = 300, rotation = giant.rotation + 30, x = giant.x + 32})
	end 
	
	local function moveblob(blob,x)
		transition.to (blob, {time = 100, xScale=1.8, yScale = .8})
		transition.to (blob, {delay = 100, time = 100, xScale=1, yScale = 1, onComplete = function () done = true end })
		transition.to (blob, {time = 100, x = x})
		for i = 1,10 do  
			transition.to (blobgirl[i], {delay = 100,time = 200, x = blobgirl[i].x + 32+math.random(15)})
		end 
	end 

		local function makegiantblobgirl()
			giant = display.newGroup()
			giant.blob = display.newImageRect(giant, "pics/marker.png",120,120 )
			giant.blob:setFillColor (255/255,100/255,200/255)
			giant.blob.alpha = .8
			giant.eye = {}
			giant.x = -600
			giant.y = _H/2 + 40
			
			for j = 1,2 do 
				giant.eye[j] = display.newImageRect(giant,"Graphics/Objects/eye_sclera.png" ,180,180)
				giant.eye[j].dot = display.newCircle(giant, 0,0,1)
				
				giant.eye[j].yScale = .18
				giant.eye[j].xScale = .2
				
				giant.eye[j]:setFillColor(255/255,255/255,255/255)
				giant.eye[j].dot:setFillColor(0,0,0)

				--blobgirl[i].eye[j]:setStrokeColor(0,0,0)
				--blobgirl[i].eye[j].strokeWidth = 3
				giant.eye[j].y = -3
				giant.eye[j].dot.y = -3 

				giant.eye[j].dot.xScale = 2 
				giant.eye[j].dot.yScale = 2 
				

				giant.eye[j]:toFront()
				giant.eye[j].dot:toFront()
				
			end
			giant.eye[1].yScale = .15
			giant.eye[2].yScale = .15
			giant.eye[1].x = 18.6
			giant.eye[2].x = 18.6
			giant.eye[1].y = -10
			giant.eye[2].y = -10
			giant.eye[1].dot.y = -10
			giant.eye[2].dot.y = -10

			giant.eye[1].dot.x = 30
			giant.eye[2].dot.x = 30
			giant:toFront()	
			


		end 

		makegiantblobgirl()

		local function makeblobgirls()
		blobgirl = {}
		for i = 1, 10 do 
			blobgirl[i] = display.newGroup()

			blobgirl[i].blob = display.newImageRect(blobgirl[i], "pics/marker.png",40,40 )
			blobgirl[i].blob:setFillColor (255/255,100/255,200/255)

			blobgirl[i].blob.alpha = .8
			blobgirl[i].eye={}
			blobgirl[i].offset = math.random (360)
			blobgirl[i].heart = display.newImageRect(blobgirl[i],"Graphics/Objects/heart.png",10,10)
			blobgirl[i].heart.y = -30
			blobgirl[i].heart.alpha = .8
			
			
			for j = 1,2 do 
				blobgirl[i].eye[j] = display.newImageRect(blobgirl[i],"Graphics/Objects/eye_sclera.png" ,60,60)
				blobgirl[i].eye[j].dot = display.newCircle(blobgirl[i], 0,0,1)
				
				blobgirl[i].eye[j].yScale = .18
				blobgirl[i].eye[j].xScale = .2
				
				blobgirl[i].eye[j]:setFillColor(255/255,255/255,255/255)
				blobgirl[i].eye[j].dot:setFillColor(0,0,0)

				--blobgirl[i].eye[j]:setStrokeColor(0,0,0)
				--blobgirl[i].eye[j].strokeWidth = 3
				blobgirl[i].eye[j].y = -3
				blobgirl[i].eye[j].dot.y = -3 

				blobgirl[i].eye[j].dot.xScale = 2 
				blobgirl[i].eye[j].dot.yScale = 2 
				

				blobgirl[i].eye[j]:toFront()
				blobgirl[i].eye[j].dot:toFront()
				
			end
			blobgirl[i].eye[1].yScale = .15
			blobgirl[i].eye[2].yScale = .15
			blobgirl[i].eye[1].x = 3.6
			blobgirl[i].eye[2].x = 3.6
			blobgirl[i].eye[1].dot.x = 5.6
			blobgirl[i].eye[2].dot.x = 5.6
			blobgirl[i]:toFront()	
			end 

		end
		makeblobgirls()
		for i = 1,10 do
			
			blobgirl[i].x = -300 + math.random(80)
			blobgirl[i].y = _H * .5 + 60
		end 

		local function jumpgirls()
			gcounter = gcounter + .1
			for i = 1,10 do 
				blobgirl[i].y = (_H*.5+60) -math.abs(math.sin(gcounter+blobgirl[i].offset)*30)
				blobgirl[i].heart.y = -20 - math.abs(math.sin(gcounter+blobgirl[i].offset-90)*20)
				
			end 
		end 
			Runtime:addEventListener("enterFrame",jumpgirls)

	local function walktheblob()
		



		local function makesingleblob()

			Sblob = display.newGroup()
			Sblob.blob = display.newImageRect(Sblob, "pics/marker.png",40,40 )


			Sblob.blob.alpha = .8
			Sblob.eye={}
		

			for j = 1,2 do 
				Sblob.eye[j] = display.newCircle(Sblob, 0,0,30)
				Sblob.eye[j].dot = display.newCircle(Sblob, 0,0,1)
				
				Sblob.eye[j].yScale = .18
				Sblob.eye[j].xScale = .2
				
				Sblob.eye[j]:setFillColor(255/255,255/255,255/255)
				Sblob.eye[j].dot:setFillColor(0,0,0)

				Sblob.eye[j]:setStrokeColor(0,0,0)
				Sblob.eye[j].strokeWidth = 3
				Sblob.eye[j].y = -3
				Sblob.eye[j].dot.y = -3 

				Sblob.eye[j].dot.xScale = 2 
				Sblob.eye[j].dot.yScale = 2 
				

				Sblob.eye[j]:toFront()
				Sblob.eye[j].dot:toFront()
			
			end
			
			Sblob.eye[1].x = 3.6
			Sblob.eye[2].x = 3.6
			Sblob.eye[1].dot.x = 3.6
			Sblob.eye[2].dot.x = 3.6
		
		end 

		makesingleblob()
		
		


		Sblob.x =  - 50
		Sblob.y = _H * .5 + 60
		
		local x = Sblob.x
		
		local function addtoX()
			x=x+32
			moveblob(Sblob,x)
			movegiant()
			if x>_W+800 then 
				timer.cancel(mt)
			end 
		end


		mt = timer.performWithDelay(300,addtoX,0)
	end 




	local function nextTitle(iteration)
		titles = display.newText(group,titleList[iteration].title,0,0,systemfont,36)
		titles.x,titles.y = _W*.5,_H*.20
		titles.alpha = 0

		names = {}

		for i = 1,#titleList[iteration].names do
			local name = display.newText(group,"",0,0,systemfont,28)
			name.text = titleList[iteration].names[i]
			name.x = _W*.5
			name.alpha = 0
			name.y = titles.y + titles.height*.5 + i*name.height
			names[#names+1] = name
		end
	end

	local function blink(i)
	
		transition.to (marker[i].eye[1],{time = 50, yScale = .01, onComplete = 
		function ()
			transition.to (marker[i].eye[1],{time = 70, yScale = .1})
		end})
		transition.to (marker[i].eye[2],{time = 70, yScale = .01, onComplete = 
		function ()
			transition.to (marker[i].eye[2],{time = 70, yScale = .1})
		end})
		


	end 

	local function dotheflash()
		flash:setFillColor(math.random(255)/255,math.random(255)/255,math.random(255)/255)
		flash.alpha = 1

		flash2:setFillColor(math.random(255)/255,math.random(255)/255,math.random(255)/255)
		flash2.alpha = 1

		background.y = _H*.5 + 50
		transition.to (background, {time = 200, y = _H*.5, transition = easing.outQuad})
		lotsablobs.y = -5 
		transition.to (lotsablobs, {delay = 10 ,time = 200, y = 0, transition = easing.outQuad})

		transition.to (flash, {delay = 20,time = 150,alpha = 0})
		transition.to (flash2, {time = 50,alpha = 0})
	end 

	local function createblobs()
	local blobcounter = 0 
	local blobcol = 0 
	lotsablobs = display.newGroup()


	for i = 1,bloblist do 
		blobcounter = blobcounter + 1; 
		if blobcounter > 5 then 
			blobcounter = 1 
			blobcol = blobcol + 1
		end 
		
		marker[i] = display.newGroup()
		marker[i].counter = math.random(360)
		marker[i].jcounter = math.random(360)
		marker[i].movementpattern = math.random (4)
		marker[i].blob = display.newImageRect(marker[i], "pics/marker.png",25,25 )
		marker[i].x = _W/6 * (blobcounter) + math.random (10)-5
		marker[i].y = (_H*.5 + blobcol * (_H/(20)) + math.random (10)-5) + _H/10
		marker[i].xpos = marker[i].x
		marker[i].ypos = marker[i].y

		marker[i].blob.alpha = .8
		marker[i].eye={}
		marker[i].blob:setFillColor (math.random(255)/255,math.random(255)/255,math.random(255)/255)

		for j = 1,2 do 
			marker[i].eye[j] = display.newCircle(marker[i], 0,0,30)
			marker[i].eye[j].dot = display.newCircle(marker[i], 0,0,1)
			
			marker[i].eye[j].yScale = .1
			marker[i].eye[j].xScale = .1
			
			marker[i].eye[j]:setFillColor(255/255,255/255,255/255)
			marker[i].eye[j].dot:setFillColor(0,0,0)

			marker[i].eye[j]:setStrokeColor(0,0,0)
			marker[i].eye[j].strokeWidth = 3
			marker[i].eye[j].y = -1
			marker[i].eye[j].dot.y = -1 
			marker[i].eye[j]:toFront()
			marker[i].eye[j].dot:toFront()
		
		end
		
		marker[i].eye[1].x = -3.6
		marker[i].eye[2].x = 3.6
		marker[i].eye[1].dot.x = -3.6
		marker[i].eye[2].dot.x = 3.6

		local scaling = blobcol+1 * 5
		marker[i].xScale = scaling /3
		marker[i].yScale = scaling /3
		lotsablobs:insert(marker[i])
	end

	lotsablobs.y = _H * 2

	z = timer.performWithDelay(14298,function()
		--dotheflash()
		t=timer.performWithDelay(462,dotheflash,0)
		transition.to (lotsablobs,{time = 462, y = 0, transition = easing.inOutQuad})
		end )
	p = timer.performWithDelay(29530,function()
		walktheblob()
		timer.cancel(t)
		t=nil 
		transition.to (lotsablobs,{time = 462, y = _H*2, transition = easing.inOutQuad})
		end )
	q = timer.performWithDelay(43990,function()
		for i = 1,#marker do 
					marker[i].movementpattern = 2
					marker[i].jcounter = math.random (10)
					marker[i].counter = math.random (10)
					
				end 

		t=timer.performWithDelay(462,dotheflash,0)
		transition.to (lotsablobs,{time = 462, y = 0, transition = easing.inOutQuad})
		end )

end 


	local doTransitions
	local function delete()
		if hasLeftScene then return end
		display.remove(titles)

		if names then
			for i = 1, #names do
				display.remove(names[i])
			end
		end

		globalIteration = globalIteration + 1
		if globalIteration <= #titleList then
			doTransitions(globalIteration)
		else
			-- Fade music + gotoscene
			audio.fadeOut({channel=2, time=2000})
			timer.performWithDelay(2000, function()
				gotoStart()
			end)
		end
	end

	function doTransitions(iteration)
		nextTitle(iteration)
		transition.to(titles, {time = 300, alpha = 1})

		for j = 1, #names do
			transition.to(names[j], {delay=300,time = 300, alpha = 1})
		end

		timer1 = timer.performWithDelay(5699, function()
			if hasLeftScene then return end
			transition.to(titles, {time = 300, alpha = 0})

			for j = 1, #names do
				transition.to(names[j], {delay=300,time = 300, alpha = 0})
			end

			timer2 = timer.performWithDelay(600, function()
				if hasLeftScene then return end
				delete()
			end)
		end)
	end

	doTransitions(1)



	function onFrame(e)
		for i = 1,#marker do 
			marker[i].counter = marker[i].counter + math.sin(i)*.5
			marker[i].jcounter = marker[i].jcounter + .3
			
			if marker[i].counter > 360 then marker[i].counter = 0 
				
				print ("blink "..i)
			
			end 

			if marker[i].movementpattern == 1 then 
				marker[i].x = marker[i].xpos + math.sin(marker[i].counter)*5

			end

			if marker[i].movementpattern == 2 then 
				local jump = math.sin(marker[i].jcounter)*30
				if jump > 0 then jump = 0 end 
				marker[i].x = marker[i].xpos + math.cos(marker[i].counter)*10
				marker[i].y = marker[i].ypos+ jump  
			end

			if marker[i].movementpattern == 3 then 
				marker[i].rotation = math.sin(marker[i].counter)*8

			end

			if marker[i].movementpattern == 4 then 
				marker[i].x = marker[i].xpos + math.cos(marker[i].counter)*10
				marker[i].rotation = math.sin(marker[i].counter)*6
			end

		end 

	end


	function gotoStart()
	
	Runtime:removeEventListener('enterFrame', onFrame)
	Runtime:removeEventListener('enterFrame', jumpgirls)
	Runtime:removeEventListener("touch",gotoStart)
	print "going to start, mofakka!"
	audio.stop(music)
	for i = 1,bloblist do 
		display.remove(marker[i])
	end 
	for i = 1,10 do 
		display.remove(blobgirl[i])
	end 
	if t then 
	timer.cancel(t)
	end 
	timer.cancel(z)
	timer.cancel(p)
	timer.cancel(q)
	display.remove(flash)
	display.remove(flash2)
	display.remove(background)
	timer.performWithDelay (20,function ()
		hasLeftScene = true
		composer.gotoScene("startscreen")
		end)
	end


	headGroup:addEventListener( "touch", headGroup )

	flash = display.newImageRect ("Graphics/Backgrounds/dancefloor_light.png",_W,_H)
		flash.x = _W*.5 
		flash.y = _H*.5
		flash.alpha = 0 
		flash.blendMode = "add"
	
	createblobs()
	
	flash2 = display.newImageRect ("Graphics/Backgrounds/dancefloor_light.png",_W,_H)
		flash2.x = _W*.5 
		flash2.y = _H*.5
		flash2.alpha = 0 
		flash2.blendMode = "add"


	-- movingHead()
	music = audio.play( blinkSong, { channel=2, fadein=5000 }  )
	Runtime:addEventListener('enterFrame', onFrame)
	Runtime:addEventListener("touch",gotoStart)

end



function scene:show(e)
end 

function scene:hide(e)
	local group = self.view
	system.setIdleTimer( true )
end 

function scene:destroy(e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
