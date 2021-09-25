tenflib = require( "tenfLib" )



local LoadButton = display.newRect(0,0,50,30)
local doc_path 		= system.pathForFile("", system.DocumentsDirectory )
local selectFile = nil
local directionCount = 0
local marked = display.newRect(0,0,200,40)
marked:setFillColor(255,0,0,100)
marked:setReferencePoint(display.TopCenterReferencePoint)
marked.isVisible = false
function name(_callback)
     local defaultField, numberField -- forward reference (needed for Lua closure)
    -- TextField Listener
    local function fieldHandler( getObj )    
    -- Use Lua closure in order to access the TextField object
    return function( event )
            --print( "TextField Object is: " .. tostring( getObj() ) )
        texten = tostring( getObj().text ) 
        length_ = string.len(texten)
        if ( "began" == event.phase ) then
            -- This is the "keyboard has appeared" event
        elseif ( "ended" == event.phase ) then
            -- This event is called when the user stops editing a field:
            -- for example, when they touch a different field or keyboard focus goes away
        if length_ == 0 then 
			tenflib.jsonSave( "defaultReplay" )
        else
            print( "Text entered = " .. texten)        -- display the text entered
            tenflib.jsonSave(texten:sub(0, 10))
            length = texten
            print(length_)
            print( texten:sub(0, 10))
        end
        elseif ( "submitted" == event.phase ) then
                local platform = system.getInfo( "platformName" )
                    print(system.getInfo( "platformName"))
                    if platform == "Android" then
                        print( "Android it is!" )
                        getObj().text = string.reverse(texten:sub(0,10))  
                    else
                        getObj().text = texten:sub(0,10)
                    end    
                    --Submitting
            if _callback then
                _callback()
            end 
            native.setKeyboardFocus( nil )
            --defaultField.isVisible = false
        elseif event.phase == "editing" then
            getObj().text = texten:sub(0,10)
            print("startPos: "..event.startPosition)
        end
    end     -- "return function()"
end

defaultField = native.newTextField(50, 100, 100, 40,
fieldHandler( function() return defaultField end ) ) 
defaultField.size = 14

end

function findReplays()
		local levelList 	= {}
		local list = {}
		local lfs = require "lfs"
		num = 0
		success = true 
		local success = lfs.chdir( doc_path ) -- returns true on success
		local new_folder_path
		if success then
    		new_folder_path = lfs.currentdir()
		end
		for file in lfs.dir(new_folder_path) do
    		if file ~= "." then
        		if file ~= ".." then 
            		if file ~= ".DS_Store" then 
                		if file ~= "bg.png" then  
                    		num = num + 1
                    		levelList[num] = file
							table.insert(list, {text = file, path = file})	
                		end
            		end

        		end
    		end
    	end 
    		local function loadingFunction(e)
				selectFile = e.data.path 
				print(selectFile.." is selected.")
				marked.isVisible = true
				e.target:insert(marked)
				marked.x, marked.y = 0,0
			end
    	local listView = require("listView"):createListView(nil, list, {
										listener = loadingFunction,
										distBetween = 0,
										})
		local _W, _H = display.contentWidth, display.contentHeight
		listView.x = _W / 2
		listView.y = _H / 2-200
		function loadSelectedFile(e)
			if selectFile == nil then
			print"No file selected!"
			else
			tenflib.jsonLoad(selectFile)
			print(selectFile.." is loaded.")
			end
		end
		LoadButton:addEventListener("tap",loadSelectedFile)
    	return levelList
end 


	--local list = {}



	-- listView:setMask(masken!!)



findReplays()
name()
--directionPrinter()