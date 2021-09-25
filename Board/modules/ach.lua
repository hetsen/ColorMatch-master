--[ Achievementsmodule for ColorMatch ]--



ach = {}


local tenflib 	= require "tenfLib"

function ach.unlockAchievement( achievementToUnlock )
	gameNetwork.request( "unlockAchievement", { achievement = { identifier=achievementToUnlock, percentComplete=100, showsCompletionBanner=true, }, listener=requestCallback})
end

function ach.postHighscore(scoreCategory, nameOfWorld)
	local highScore = tenflib.jsonLoad("state"..nameOfWorld..".txt")

	local totalSum = 0
	
	for i=1,#highScore do
		totalSum = totalSum+highScore[i].points
	end

	local highScoreTimer = timer.performWithDelay(100,function()
		gameNetwork.request( "setHighScore", { localPlayerScore = { category=scoreCategory, value=totalSum },})
		highScoreTimer = nil
	end)
end

function ach.saveColorsAch (colors)
	if gcIsActive == true and not replaymode then 
		print("Save picked colors")

		achSaves 			= tenflib.jsonLoad("gcSaves")
		saveColors 			= achSaves.redColorsPicked+achSaves.greenColorsPicked+achSaves.blueColorsPicked
		saveRed 			= achSaves.redColorsPicked+colors[1]
		saveGreen 			= achSaves.greenColorsPicked+colors[2]
		saveBlue 			= achSaves.blueColorsPicked+colors[3]
		savelevelsPlayed	= achSaves.levelsPlayed
		savelevelsFailed	= achSaves.levelsFailed
		saveStars 			= achSaves.stars


		local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=achSaves.stars,
				started=achSaves.started,
			})

		local newAch = tenflib.jsonLoad("gcSaves")

		--[ Picked colors ]--
		if newAch.colorsPicked == 10 then 
			ach.unlockAchievement("se.10fingers.findthecure.10ColorsPicked")
			print("10 colors picked")
		elseif newAch.colorsPicked == 20 then
			ach.unlockAchievement("se.10fingers.findthecure.20ColorsPicked")
			print("20 colors picked")
		end

		--[ Picked colors (red) ]--
		if newAch.redColorsPicked == 25 then
			print("25 Red colors picked")
		elseif newAch.redColorsPicked == 40 then
			print("40 Red colors picked")
		end

		--[ Picked colors (green) ]--
		if newAch.greenColorsPicked == 25 then
			print("25 Green colors picked")
		elseif newAch.greenColorsPicked == 40 then
			print("40 Green colors picked")
		end

		--[ Picked colors (blue) ]--
		if newAch.blueColorsPicked == 25 then
			print("25 Blue colors picked")
		elseif newAch.blueColorsPicked == 40 then
			print("40 Blue colors picked")
		end
	else
		print("gc is offline or replaying")
	end
end 

function ach.savelevelsPlayed( played )
	if gcIsActive == true and not replaymode then
		print("Save played levels")

		achSaves 	= tenflib.jsonLoad("gcSaves")
		savePlayed	= achSaves.levelsPlayed+achSaves.levelsFailed+played

			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=savePlayed or achSaves.levelsPlayed,
				levelsFailed=achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=achSaves.stars,
				started=achSaves.started,
			})

		local newAch = tenflib.jsonLoad("gcSaves")

		if newAch.levelsPlayed == 10 then
			print("You have played 10 levels.")
		end
	else
		print("gc is offline or replaying")
	end
end

function ach.savelevelsFailed( failed )
	if gcIsActive == true and not replaymode then
		print("Save failed levels")

		achSaves 	= tenflib.jsonLoad("gcSaves")
		saveFailed 	= achSaves.levelsFailed+failed

			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=saveFailed or achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=achSaves.stars,
				started=achSaves.started,
			})

		local newAch = tenflib.jsonLoad("gcSaves")

		if newAch.levelsFailed == 10 then
			print("You have failed 10 levels...")
		end

	else
		print("gc is offline or replaying")
	end
end

function ach.saveRestartsAch( restartLevel )
	if gcIsActive == true and not replaymode then
		achSaves 		= tenflib.jsonLoad("gcSaves")
		saveRestarts	= achSaves.restarts+restartLevel

			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=achSaves.levelsFailed,
				restarts=saveRestarts or achSaves.restarts,
				stars=achSaves.stars,
				started=achSaves.started,
			})

		local newAch = tenflib.jsonLoad("gcSaves")

		if achSaves.restarts == 5 then
			print("The restarter")
		end
	else
		print("gc is offline or replaying")
	end
end

function ach.saveStars( stars )
	if gcIsActive == true and not replaymode then

		achSaves 	= tenflib.jsonLoad("gcSaves")
		saveStarsa 	= achSaves.stars+stars

			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=saveStarsa or achSaves.stars,
				started=achSaves.started,
			})

			local newAch = tenflib.jsonLoad("gcSaves")
			
			if newAch.stars == 20 then
				print("Achievement Starstruck!")
			end
	else
		print("gc is offline or replaying")
	end
end

function ach.saveStarted( startlevel )
	if gcIsActive == true and not replaymode then
		print("Save started game")

		achSaves 	 = tenflib.jsonLoad("gcSaves")
		saveStarteda = achSaves.restarts+startlevel

			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=savefourTwo or achSaves.fortyTwo,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=achSaves.stars,
				started=saveStarteda or achSaves.started,
			})

			local newAch = tenflib.jsonLoad("gcSaves")

			if newAch.started == 10 then
				print("You have started a level 10 times.")
			end


	else
		print("gc is offline or replaying")
	end
end

function ach.savefourTwo( fortyTwos )
	if gcIsActive == true and not replaymode then
		print("Save failed levels")

		achSaves 		= tenflib.jsonLoad("gcSaves")
		fourtwo		 	= achSaves.fortyTwo+fortyTwos
		
		print("fortyTwos "..fortyTwos)
			local gcSaves = tenflib.jsonSave("gcSaves",
			{
				fortyTwo=achSaves.fortyTwo+fortyTwos,
				colorsPicked=saveColors or achSaves.colorsPicked,
				redColorsPicked=saveRed or achSaves.redColorsPicked,
				greenColorsPicked=saveGreen or achSaves.greenColorsPicked,
				blueColorsPicked=saveBlue or achSaves.blueColorsPicked, 
				levelsPlayed=achSaves.levelsPlayed,
				levelsFailed=saveFailed or achSaves.levelsFailed,
				restarts=achSaves.restarts,
				stars=achSaves.stars,
				started=achSaves.started,
			})
	else
		print("gc is offline or replaying")
	end
end

return ach

