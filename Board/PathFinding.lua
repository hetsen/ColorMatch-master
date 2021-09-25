local P = {}
P.EndNodeID = 0
P.StartNodeID = 0
P.PerformeSearch = false
P.Core = {}
P.NodeList = {}
P.NodeListSize = 0
P.NumIterations = 0
P.NumNodes = 0
------------------------ värdesändrings var
P.PathLengthMod = 1		---- Modifies PathLength calculation then choosing which path to continue the search on, setting this to 0 results in a faster but sloppier search, the higher the value, the more precsice but slower search
P.GoalLengthMod = 1		---- Modifies the scaling of path to goal check, this counters the PathLengthMod-variable, 
P.PathSpeedInterval = 1 ---- Amount of ms between searches, lower value = faster search
P.LoopCount = 9999 		---- Amount of maximum pathspreadloops, higher the value the more loops in each searchupdate
	
	------------- Visual, set node colors
	function P:UpdateNodeColors(PathToSpread)
	end
	------------------------------------

	function P:GetNodeLength(NodeID1, NodeID2)   ---- Get the length  between 2 nodes
		local VecX = P.NodeList[NodeID1].PosX - P.NodeList[NodeID2].PosX
		local VecY = P.NodeList[NodeID1].PosY - P.NodeList[NodeID2].PosY
		return math.sqrt( (VecX * VecX) + (VecY * VecY) )
	end

	function P:CreatePath() ---- Create A path, A path is a list of node ID's that leads toward the EndNode from the StartNode
		local F = {}
		F.IDCount = 0
		F.GoalLength = 0
		F.PathLength = 0
		F.IDList = {}
		P.Core.PathCount = P.Core.PathCount + 1
		P.Core.Path[P.Core.PathCount] = F
	end

	function P:CopyPath(PathID) --- Create A new Path, and copy data from another path to it
		P:CreatePath()
		P.Core.Path[P.Core.PathCount].IDCount = P.Core.Path[PathID].IDCount
		P.Core.Path[P.Core.PathCount].GoalLength = P.Core.Path[PathID].GoalLength
		P.Core.Path[P.Core.PathCount].PathLength = P.Core.Path[PathID].PathLength
		for i=1, P.Core.Path[PathID].IDCount do
			P.Core.Path[P.Core.PathCount].IDList[i] = P.Core.Path[PathID].IDList[i]
		end
	end

	function P:AddNodeIDToPath(PathID, NodeID, NodeLength)	---- Extend The Path with a Node's ID
		P.Core.Path[PathID].IDCount = P.Core.Path[PathID].IDCount + 1
		P.Core.Path[PathID].IDList[P.Core.Path[PathID].IDCount] = NodeID
		P.Core.Path[PathID].PathLength = P.Core.Path[PathID].PathLength + (NodeLength * P.NodeList[NodeID].WeightMult) + P.NodeList[NodeID].WeightAdd 
		P.Core.Path[PathID].GoalLength = P:GetNodeLength(NodeID, P.EndNodeID)
	end

	function P:SpreadPath(PathID) ---- Spreading path by Using the Last Node in the assigned path, check its connectionlist, sort the connections via lengths from goal and if they have been used before, then, create a new path for every unused node, 
		local NodeID = P.Core.Path[PathID].IDList[P.Core.Path[PathID].IDCount]
		local SpreadIDList = {}
		local SpreadLengthList = {}
		local Count = 0
		P.NodeList[NodeID].Used = true

		--
		--renderer.makeadot(PathNodes:GetNodePos(NodeID))

		---- Go through connected nodes
		for i=1, P.NodeList[NodeID].ConListSize do
			local ConnID = P.NodeList[NodeID].ConList[i]
			if P.NodeList[ConnID].Searched == false and P.NodeList[ConnID].IsActive == true then
				P.NodeList[ConnID].Searched = true
				Count = Count + 1
				SpreadIDList[Count] = ConnID
				SpreadLengthList[Count] = P.NodeList[NodeID].ConListLenght[i]
			end
		end
		---- spread ---
		if Count > 0 then
			for i=1,Count do
				P:CopyPath(PathID)
				P:AddNodeIDToPath(P.Core.PathCount, SpreadIDList[i], SpreadLengthList[i])
			end
		end
		P:RemovePath(PathID)
	end

	function P:RemovePath(PathID) ----- Removes Old Paths, its every time the path spreads, new paths are creadtd and copied for every potential new paths, then the old is destroyd

		P.Core.Path[PathID] = P.Core.Path[P.Core.PathCount]
		P.Core.Path[P.Core.PathCount] = nil
		P.Core.PathCount = P.Core.PathCount - 1
	end

function P:FindPath()

	BreakLoop = false
	SafeCount = P.LoopCount
	while BreakLoop == false and P.PerformeSearch == true do   ---- PathfindingLoop, BreakLoop will be true then path from start to goal is created, or then loop reaches the safecount
		P.NumIterations = P.NumIterations + 1
		ShortestLength = math.huge
		PathToSpread = 0
		for i=1, P.Core.PathCount do  ---- Loop all Paths, and find the one nearest to goal
			local L = (P.Core.Path[i].GoalLength * P.GoalLengthMod ) + (P.Core.Path[i].PathLength * P.PathLengthMod);
			if L <= ShortestLength then
				ShortestLength = L
				PathToSpread = i
			end
		end

		if PathToSpread > 0 then
			local SpreadNodeID = P.Core.Path[PathToSpread].IDList[P.Core.Path[PathToSpread].IDCount]

			--- DEBUGG, show in the tree where the latest node in the path is
			local DPosX, DPosY = PathNodes:GetNodePos(SpreadNodeID)
			--------

			if SpreadNodeID == P.EndNodeID or SafeCount <= 0 then
				BreakLoop = true
				---- Update Visual-node representation
				P:UpdateNodeColors(PathToSpread)

				if SpreadNodeID == P.EndNodeID then
					P.PerformeSearch = false
					for i=1,P.Core.Path[PathToSpread].IDCount do
						P.NumNodes = P.NumNodes + 1
					end
				end

				return P.Core.Path[PathToSpread].IDList
			else
				P:SpreadPath(PathToSpread)  ---- Spread The path nearest to goal
				SafeCount = SafeCount - 1
			end
		else
			P:UpdateNodeColors(PathToSpread)
			P.PerformeSearch = false
			return nil
		end
	end

end

P.TimerCreated = false
function P:InitiatePathFinding(_NodeList, _NodeListSize, _StartNodeID, _EndNodeID) ----- Initialaze a new pathfinding, this resets the parameters and restart/start the pathfinding	
	P.NodeList = _NodeList
	P.NodeListSize = _NodeListSize
	P:ResetNodes()
	P.EndNodeID = _EndNodeID
	P.StartNodeID = _StartNodeID
	P:CreatePath()
	P:AddNodeIDToPath(P.Core.PathCount, P.StartNodeID, 0)
	ShortestLength = P.Core.Path[P.Core.PathCount].GoalLength
	PathToSpread = P.Core.PathCount
	P.PerformeSearch = true

	P.CorrectPath = {}
	P.CorrectPath = P:FindPath()

	return P.CorrectPath

	--if P.TimerCreated == false then
		--P.TimerCreated = true
		--timer.performWithDelay(P.PathSpeedInterval, function() P:FindPath() end, 0)
	--end
end

function P:CopyNodeList(_NodeList, _NodeListSize)	----- copy a nodelist, this is currently not in use, but is necessary if more then one AI should pathfind at the same time

local NodeList = {}

	for i=1,_NodeListSize do
		local Node = {}
		Node.ID = _NodeList[i].ID
		Node.ConList = {}
		Node.ConListLenght = {}
		Node.ConListSize = _NodeList[i].ConListSize
		Node.PosX = _NodeList[i].PosX
		Node.PosY = _NodeList[i].PosY
		Node.Searched = false
		Node.Used = false
		Node.Im = _NodeList[i].Im
		for j=1, Node.ConListSize do
			Node.ConList[j] = _NodeList[i].ConList[j]
			Node.ConListLenght[j] = _NodeList[i].ConListLenght[j]
		end
		NodeList[i] = Node
	end
	return NodeList, _NodeListSize
end

function P:ResetNodes() --- reset the Nodes so a new pathfinding can be initialized
	
	for i=1,P.NodeListSize  do
		P.NodeList[i].Searched = false
		P.NodeList[i].Used = false
	end
	if P.Core.PathCount then
		for i=P.Core.PathCount , 1, -1 do
			P.Core.Path[i] = nil
		end
	end
	P.Core.PathCount = 0
	P.NumNodes = 0
	P.NumIterations = 0
	P.Core.Path = {}
end

return P