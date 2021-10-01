local lfs 		= require("lfs")
local tenfLib	= require("tenfLib")
local json 		= require("json")

levelNameList = {}
num = 0
newNum = 0
local doc_path = system.pathForFile( "levels/", system.ResourceDirectory )
function getAmountOfFiles()
		for file in lfs.dir( doc_path ) do
		num = num +1
		print(file)
	end
end
getAmountOfFiles()

for file in lfs.dir( doc_path ) do
	if file == "." or file == ".." then 

	else 
		table.insert(levelNameList, {""..file..""})
	end
	newNum = newNum + 1
	if newNum == num then 
		for i=1,#levelNameList do
			local path = system.pathForFile( "levels/"..levelNameList[i][1], system.ResourceDirectory )
			local file, errorString = io.open( path, "r" )
			if not file then
			    print( "File error: " .. errorString )
			else
			    local contents = file:read( "*a" )
			    print(json.encode(contents))
			    table.insert(levelNameList[i],contents)
			    io.close( file )
			    if i == #levelNameList then 
			    	tenfLib.jsonSave("levels.file",levelNameList)
			    end
			end
			file = nil
		end
	end
end



