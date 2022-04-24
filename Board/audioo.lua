local aud = {}

local basedir = "Sound/"
local music 
local sounds = {}
local count = 3 
local isplaying
local soundplayed 

function aud.playmusic(track)
	if isplaying then 
		print ("track playing "..isplaying.." track loading "..track)
	end 

	if isplaying then 
		if isplaying ~= track then -- om ulik låt
			print ("changing"..track)
			audio.stop(1)
			audio.dispose(isplaying)
			music = audio.loadStream( basedir..track)
			audio.play(music, {channel = 1, loops = -1, fadein = 5000})

		end 
	else --om ingen låt
		print ("starting"..track)
		music = audio.loadStream( basedir..track)
		audio.play(music, {channel = 1, loops = -1, fadein = 5000})
	end 
		isplaying = track
end 

function aud.stopmusic(track)
	audio.stop(1)
	isplaying = nil 
end

function aud.disposemusic()
	audio.dispose (music)
end 

function aud.loadsounds(soundtable)
	if not soundtable then 
		soundtable = {click = {"menuclick.mp3"}, move = {"move1.mp3", "move2.mp3", "move3.mp3", "move4.mp3"}, get = {"catchcolor.mp3"}, drop = {"removecolor.mp3"}, sweep = {"sweep.mp3"}, nope = {"nope.mp3"}, star1 = {"star1.mp3"}, star2 = {"star2.mp3"}, star3 = {"star3.mp3"}, opengoal = {"open_goal.mp3"}, closegoal = {"close_goal.mp3"}, falling = {"falling.mp3"}, highscore = {"highscore.mp3"}, countup1 = {"countup.wav"}
	, fail = {"fail.mp3"}}
	end 

	for k,v in pairs(soundtable) do
		print (k,v)
		sounds[k] = {}
		for a = 1,#v do 
			sounds[k][a] = audio.loadSound (basedir..v[a])
			
		end 
	end
	
	for k,v in pairs(sounds) do
		print(k,v)
	end
	return sounds
end 



function aud.play(sound, wait)

	local function done(e)
		if e.completed then 
			soundplayed = false
		end 
	end 
	--[[ <FUGLY FIX, I DONT KNOW WHAT THE PURPOSE OF DIS WAS. AND IM TOO LAZY TO FIGURE OUT /MICKE>]]--
	if #sound then
		random = math.random(#sound)
	else
		random = 1 --not so random, eh?
	end
	--[[ </FUGLY FIX, I DONT KNOW WHAT THE PURPOSE OF DIS WAS. AND IM TOO LAZY TO FIGURE OUT /MICKE>]]--

	count = count + 1; if count > 31 then count = 3;end 
	print ("channel "..count) 

	if wait then 
		print "waiting"
		print (soundplayed)
		if not soundplayed then 
			soundplayed = true  
			audio.play (sound[random], {channel = count,  onComplete=done})
		end 
	else
		audio.play (sound[random], {channel = count})
	end 
end 

function aud.halfvolume(bool)
local volume1
local volume2



if bool then 
	print "Halfvolume set"
	volume1 = globalmusicvolume / 3
else 
	print "Halfvolume released"
	volume1 = globalmusicvolume 
end 
	audio.setVolume(volume1, {channel = 1})
end 


function aud.setmusicvolume(volume)
	audio.setVolume(volume, {channel = 1})
	print ("set music volume to "..volume)
end 


function aud.setsoundvolume(volume)
	for i = 3,31 do 
		audio.setVolume(volume, {channel = i})
	end 
	print ("set sound volume to "..volume)
end 
return aud

