local tenflib = require( "modules.tenfLib" )
local s = {}

function s.save(levelname, scorelist)
	return true
end 

function s.load(blob,gameboard)
	local level = tenflib.jsonLoad( "state.txt", system.DocumentsDirectory)
	local base_score
	local score = {}

	score.firstObjective 	= false
	score.secondObjective 	= false
	score.thirdObjective 	= false
	score.percentage		= 100

	if gameboard.nColorsOnBoard ~= 0 and gameboard.nColorsOnBoard ~= nil then
		score.percentage = (100/gameboard.nColorsOnBoard)*blob[2]
	end

	base_score = math.round(score.percentage)*10

	if blob[2] == gameboard.nColorsOnBoard then 
		score.firstObjective = true
	end 

	if blob[1] < gameboard.maxMoves then
		score.secondObjective = true
		score.movedifference = gameboard.maxMoves - blob[1]
	end

	if gameboard.maximumTime > blob[3] then
		score.thirdObjective = true
		score.timedifference = gameboard.maximumTime - blob[3]
	end 
	
	score.movedifference = score.movedifference or 0
	score.timedifference = score.timedifference or 0

	-- For some reason, score.firstObjective is not used
	score.numStars = {one = true, two = score.secondObjective, three = score.thirdObjective}
	score.totalscore = base_score + ((score.movedifference * 250) + (score.timedifference * 60))

	return score
end 

function s.calculate()
end 

return s
