
local tenflib = require( "modules.tenfLib" )
local s = {}
local score = {}

function s.save(levelname, scorelist)


return true 
end 

function s.load(blob,gameboard)
	score = nil 
	score = {}
	--moves,pickedup,seconds

	local level = tenflib.jsonLoad( "state.txt", system.DocumentsDirectory)
	local moves
	local colors
	local time 

	for k,v in pairs(blob) do
		--print("blob  "..k,v)
	end



	score.firstObjective 	= false
	score.secondObjective 	= false
	score.thirdObjective 	= false

	score.percentage = (100/gameboard.nColorsOnBoard)*blob[2]

	if gameboard.nColorsOnBoard == 0 or gameboard.nColorsOnBoard == nil then
		score.percentage = 100
	end

	if blob[2]== gameboard.nColorsOnBoard then 
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

		first=score.firstObjective
		second=score.secondObjective
		third=score.thirdObjective

		score.numStars = {one = false, two = false, three=false}


		score.numStars.one = true
		if second then score.numStars.two =true end
		if third then score.numStars.three =true end 




	local base = math.round(score.percentage)*10
	score.totalscore = base  + ((score.movedifference*250)+(score.timedifference*60))


	return score
	
end 

function s.calculate()
end 

return s
