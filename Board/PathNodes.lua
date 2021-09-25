local N = {}
N.NodeCount = 0
N.NodeList = {}
------------------------ värdesändrings var
N.ShowTreeStruct = false

------ Initialization Settings ------
function N:InitializeBasicSettings(TreeDepth, MapMaxX, MapMaxY, MapMinX, MapMinY) ---- Initializing the nodetree structure, its used to sort node ID via Position, and results in faster looping then a node needs to be found. The first variable "TreeDepth" decides how deep the tre goes, rekomendet do set "ShowTreeStruct" to true, and then changing that number to get a visual representation on how it works. the rest of the variables is setting the whole tree,s max and min Pos, one thing to remember is to never create a node outside the max en min pos, for that, you need a more dynamic tree

	local F = {}

	 function F:AssignProperties (CurrentDepth, MaxX, MaxY, MinX, MinY) ---- Gives Properties to a treebranch
		local TreeStruct = {}	
		TreeStruct.MaxX = MaxX
		TreeStruct.MaxY = MaxY
		TreeStruct.MinX = MinX
		TreeStruct.MinY = MinY
		TreeStruct.TreeDepth = CurrentDepth
		TreeStruct.Branch = {}
		return TreeStruct;
	end

	 function F:SplitMaxMin(Max, Min, Part, MaxParts)	---- splitting a min and max position in parts 
		local Vec = (Max - Min)/MaxParts
		local NewMax = Min + (Vec * Part)
		local NewMin = Min + (Vec * (Part - 1))
		return NewMax, NewMin
	end

	 function F:BranchLoop(TreeStruct, CurrentDepth, MaxX ,MaxY, MinX, MinY) ---- Create new sub-branches from a "larger" branch, amount of branches = "N.TreeBranches"^2

		for i = 1, N.TreeBranches do 
			local NewMaxX, NewMinX = F:SplitMaxMin(MaxX, MinX, i, N.TreeBranches)
			local Sub = {}
			Sub.SubBranch = {}
			TreeStruct.Branch[i] = Sub
			for j = 1, N.TreeBranches do
				local NewMaxY, NewMinY = F:SplitMaxMin(MaxY, MinY, j, N.TreeBranches)
				TreeStruct.Branch[i].SubBranch[j] = F:DepthIterate( CurrentDepth, NewMaxX, NewMaxY, NewMinX, NewMinY)
			end
		end
		return TreeStruct
	end

	 function F:DepthIterate( Depths, MaxX, MaxY, MinX, MinY) ---- this function checks the depths and runs deeper branchloops if the dephts is not enougth, otherwise, create a ID list for the nodes that has its Position between the branch max and min pos

		---- debugg sphere
		if N.ShowTreeStruct == true then
			local Size = 20/Depths
			local C1 = display.newCircle(MaxX, MaxY, Size)
			local C2 = display.newCircle(MinX, MinY, Size)
			local C3 = display.newCircle(MinX, MaxY, Size)
			local C4 = display.newCircle(MaxX, MinY, Size)
			C1.alpha = (1/Depths) * 0.7
			C2.alpha = (1/Depths) * 0.7
			C3.alpha = (1/Depths) * 0.7
			C4.alpha = (1/Depths) * 0.7
		end
		--------

		local TreeStruct = {}

		if Depths < N.TreeDepth then
			Depths = Depths + 1
			TreeStruct = F:AssignProperties(Depths, MaxX, MaxY, MinX, MinY)
			TreeStruct = F:BranchLoop(TreeStruct, TreeStruct.TreeDepth, MaxX, MaxY, MinX, MinY)
		else
			TreeStruct.NodeList = {}
			TreeStruct.ListCount = 0
			TreeStruct.MaxX = MaxX
			TreeStruct.MaxY = MaxY
			TreeStruct.MinX = MinX
			TreeStruct.MinY = MinY
		end
		return TreeStruct
	end

	N.TreeDepth = TreeDepth
	N.TreeBranches = 2;
	N.TreeStruct = {}
	N.TreeStruct = F:AssignProperties(1, MapMaxX, MapMaxY, MapMinX, MapMinY)
	N.TreeStruct = F:BranchLoop(N.TreeStruct, N.TreeStruct.TreeDepth, MapMaxX, MapMaxY, MapMinX, MapMinY)
end

function N:GetList(TreeStruct, CurrentDepth, PosX, PosY) ---- loop throught the tree and get the branch that has its Max and Min Pos between around the assigned pos 
		
	local Branch = {}
	for i = 1, N.TreeBranches do
		for j = 1, N.TreeBranches do
			if PosX < TreeStruct.Branch[i].SubBranch[j].MaxX then
				if PosY < TreeStruct.Branch[i].SubBranch[j].MaxY then
					if CurrentDepth == N.TreeDepth then
						Branch = TreeStruct.Branch[i].SubBranch[j]
					else
						Branch =  N:GetList(TreeStruct.Branch[i].SubBranch[j], TreeStruct.Branch[i].SubBranch[j].TreeDepth, PosX, PosY)
					end
					return Branch
				end
			else
				break
			end
		end
	end
		
end

function N:GetIDListFromTree(PosX, PosY)  --- this gets a NodeID list from the tree, 
	
	if PosX < N.TreeStruct.MaxX and PosX >= N.TreeStruct.MinX and PosY < N.TreeStruct.MaxY and PosY >= N.TreeStruct.MinY then
		local Branch = {}
		Branch =  N:GetList(N.TreeStruct, N.TreeStruct.TreeDepth, PosX, PosY)
			---- debugg spheres
			local H = {}
			function H:Rem(Var)
				if Var then
					Var:removeSelf()
					Var = nil
				end
				return Var
			end
			function H:Add(Var, PosX, PosY, Size, R, G, B, A)
				Var = H:Rem(Var)
				Var = display.newCircle(PosX, PosY, Size)
				Var:setFillColor(R, G, B)
				Var.alpha = 0;
				return Var
			end

			if N.ShowTreeStruct == true then
				local MaxX = Branch.MaxX
				local MinX = Branch.MinX
				local MaxY = Branch.MaxY
				local MinY = Branch.MinY
				local Size = 10

				C1 =  H:Add(C1, MaxX, MaxY, Size, 0, 200, 0, 0.5)
				C2 =  H:Add(C2, MinX, MinY, Size, 0, 200, 0, 0.5)
				C3 =  H:Add(C3, MinX, MaxY, Size, 0, 200, 0, 0.5)
				C4 =  H:Add(C4, MaxX, MinY, Size, 0, 200, 0, 0.5)
				C5 =  H:Add(C5, PosX, PosY, Size, 255, 0, 0, 0.5)
			end

			return Branch.NodeList, Branch.ListCount
		else
			return nil, 0
		end
		--------
		return Branch.NodeList, Branch.ListCount
end

function N:AddNodeIDToTree(NodeID) --- this Adds the node ID to the tree, the place in the tree is dependent on the nodes position

	local PosX, PosY = N:GetNodePos(NodeID)
	local Branch = {}
	Branch =  N:GetList(N.TreeStruct, N.TreeStruct.TreeDepth, PosX, PosY)
	Branch.ListCount = Branch.ListCount + 1
	Branch.NodeList[Branch.ListCount] = NodeID
end

function N:DeleteNodeIDToTree(NodeID) 

	local PosX, PosY = N:GetNodePos(NodeID)
	local Branch = {}
	Branch =  N:GetList(N.TreeStruct, N.TreeStruct.TreeDepth, PosX, PosY)
	for i = Branch.ListCount, 1, -1 do
		if Branch.NodeList[i] == NodeID then
			Branch.NodeList[i] = Branch.NodeList[Branch.ListCount]
			Branch.NodeList[Branch.ListCount] = nil
			Branch.ListCount = Branch.ListCount - 1
		end
	end
end

function N:ReplaceNodeIDToTree(PrevID, NewID, OriginalIDChanged)
	local PosX, PosY = 0, 0
	if OriginalIDChanged == true then
		PosX, PosY = N:GetNodePos(NewID)
	else
		PosX, PosY = N:GetNodePos(PrevID)
	end
	local Branch = {}
	Branch =  N:GetList(N.TreeStruct, N.TreeStruct.TreeDepth, PosX, PosY)
	for i = Branch.ListCount, 1, -1 do
		if Branch.NodeList[i] == PrevID then
			Branch.NodeList[i] = NewID
		end
	end
end

--- End of Tree Struction




------ Basic Node Functions ------

function N:CreateNode(PosX, PosY)--- Create the node used for pathfinding

	N.NodeCount = N.NodeCount + 1
	local Node = {}
	Node.ID = N.NodeCount
	Node.ConList = {}
	Node.ConListLenght = {}
	Node.ConLine = {}
	Node.ConListSize = 0
	Node.PosX = PosX
	Node.PosY = PosY
	Node.WeightAdd = 0
	Node.WeightMult = 1
	Node.Searched = false
	Node.Used = false
	Node.IsActive = true
	Node.Im = display.newCircle(PosX, PosY, 5)
	--Node.Im:setFillColor(255,0,0)
	Node.Im.alpha = 0

	--print("Node", Node.PosY)

	N.NodeList[N.NodeCount] = Node

	N:AddNodeIDToTree(Node.ID)

	return ID
end

function N:SetWeightAdd(NodeID, Weight)
	N.NodeList[NodeID].WeightAdd = Weight
end

function N:SetWeightMult(NodeID, Weight)
	N.NodeList[NodeID].WeightMult = Weight
end

function N:ConnectNodes(ID1, ID2, Length) ---- Connect one node to another so they know they are neighbours, ID2 is Connected to ID1's "conList" (ConnectionList)

		N.NodeList[ID1].ConListSize = N.NodeList[ID1].ConListSize + 1
		N.NodeList[ID1].ConList[N.NodeList[ID1].ConListSize] = N.NodeList[ID2].ID
		N.NodeList[ID1].ConListLenght[N.NodeList[ID1].ConListSize] = Length
		N.NodeList[ID1].ConLine[N.NodeList[ID1].ConListSize] = display.newLine(N.NodeList[ID1].PosX, N.NodeList[ID1].PosY ,N.NodeList[ID2].PosX, N.NodeList[ID2].PosY)
		N.NodeList[ID1].ConLine[N.NodeList[ID1].ConListSize].alpha = 0

end

function N:GetNearestNode(PosX, PosY) --- Give Pos and get the ID from the Node nearest thouse pos
	local NodeIDList = {}
	local NodeCount = 0
	NodeIDList, NodeCount = N:GetIDListFromTree(PosX, PosY)
	local Dot1 = math.huge
	local NearesNodeID = nil
	for i=1, NodeCount do
		local NPosX, NPosY = N:GetNodePos(NodeIDList[i])
		local VecX = NPosX - PosX
		local VecY = NPosY - PosY
		local Dot2 = (VecX * VecX) + (VecY * VecY)
		if Dot2 < Dot1 then
			Dot1 = Dot2
			NearesNodeID = NodeIDList[i]
		end
	end
	return NearesNodeID
end

function N:GetNodePos(NodeID) ---- Give Nodes ID and get its Position
	return N.NodeList[NodeID].PosX, N.NodeList[NodeID].PosY
end

function N:SetNodeActivation(NodeID, IsActive) ---- Set Node Activation, if "IsActive" is false, Node will not be used
	N.NodeList[NodeID].IsActive = IsActive
end

function N:GetNodeConList(NodeID) --- Get a Nodes neighgbours/connection list, Lists the ID of the nodes connected, alse, get the list size
	return N.NodeList[NodeID].ConList, N.NodeList[NodeID].ConListSize
end

function N:GetNodeLength(NodeID1, NodeID2)  ---- Get the length  between 2 nodes, the removel is done by replacing the node with the last node, and then remove the last node, this is to prevent any empty space in the nodelist
	local VecX = N.NodeList[NodeID1].PosX - N.NodeList[NodeID2].PosX
	local VecY = N.NodeList[NodeID1].PosY - N.NodeList[NodeID2].PosY
	return math.sqrt( (VecX * VecX) + (VecY * VecY) )
end

function N:DestroyNode(NodeID) ---- Destroy A Node
	for i=1, N.NodeList[NodeID].ConListSize do   ---- first unconnect the connected nodes
		local ConNodeID = N.NodeList[NodeID].ConList[i]
		N:UnConnectNode(ConNodeID, NodeID)

		N.NodeList[NodeID].ConList[i] = nil
		N.NodeList[NodeID].ConListLenght[i] = nil
		N.NodeList[NodeID].ConLine[i]:removeSelf()
		N.NodeList[NodeID].ConLine[i] = nil
	end
	---- remove node from tree
	N:DeleteNodeIDToTree(NodeID)	
	N.NodeList[NodeID].ConList = nil
	N.NodeList[NodeID].ConListLenght = nil
	N.NodeList[NodeID].ConLine = nil	
	N.NodeList[NodeID].Im:removeSelf()

	if NodeID ~= N.NodeCount then
		N.NodeList[NodeID] = N.NodeList[N.NodeCount]
		N.NodeList[NodeID].ID = NodeID

		for i=1, N.NodeList[NodeID].ConListSize do ---- replace connection ID's on the Node, its done becuase the last node is now the removed node, so the change in ID must reach the connected nodes
			local ConNodeID = N.NodeList[NodeID].ConList[i]
			N:ReplaceConnectNodeID(ConNodeID, N.NodeCount, NodeID)
		end
	end
	N:ReplaceNodeIDToTree(N.NodeCount, NodeID, true)

	N.NodeList[N.NodeCount] = nil
	N.NodeCount = N.NodeCount - 1
end

function N:UnConnectNode(NodeID, UnNodeID)	--- Remove a Node's ID from the connected nodes list
	local Size = N.NodeList[NodeID].ConListSize
	for i=Size, 1, -1 do
		if UnNodeID == N.NodeList[NodeID].ConList[i] then
			N.NodeList[NodeID].ConList[i] = N.NodeList[NodeID].ConList[Size]
			N.NodeList[NodeID].ConListLenght[i] = N.NodeList[NodeID].ConListLenght[Size]
			N.NodeList[NodeID].ConLine[i]:removeSelf()
			N.NodeList[NodeID].ConLine[i] = N.NodeList[NodeID].ConLine[Size]
			N.NodeList[NodeID].ConLine[Size] = nil
			N.NodeList[NodeID].ConList[Size] = nil
			N.NodeList[NodeID].ConListLenght[Size] = nil
			N.NodeList[NodeID].ConListSize = N.NodeList[NodeID].ConListSize - 1
		end
	end	
end

function N:ReplaceConnectNodeID(NodeID, PrevID, NewID)	--- replace a ID in the Connected nodes list
	local Size = N.NodeList[NodeID].ConListSize
	for i=1, Size do
		if PrevID == N.NodeList[NodeID].ConList[i] then
			N.NodeList[NodeID].ConList[i] = NewID
		end
	end	
end

------ Specialized Functions ------

function N:AutoConnectAllNodesViaLength(MaxLength)   ----- Automatic Node4 Connection, this function uses a maximum length that desicdes if the nodes should connect, if node - node length is less then "MaxLength", they connect, in a real game, there are often more, or other parameters that decides if nodes should connect, (ex: collision and line of sight)
	for i=1,N.NodeCount do
		for j=1,N.NodeCount do
			if N.NodeList[i].ID ~= N.NodeList[j].ID then
				local Length = N:GetNodeLength(i,j)
				if Length <= MaxLength then
					N:ConnectNodes(i,j, Length)				--- I have This in 2 separat because their mey be a moment then their is only a one way connection
					--print("Con")
				end
			end
		end		
	end
end

return N



