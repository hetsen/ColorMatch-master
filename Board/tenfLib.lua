-----------------------------------------------------------------------------------------
--
-- Samling av återanvändbara funktioner
-- tenfLib.lua
-- 10Fingers
--
-- Uppdatering #8: 2012-09-07 Marcus Thunström
-- Uppdatering #7: 2012-08-30 Tommy Lindh
-- Uppdatering #6: 2012-08-29 Marcus Thunström
-- Uppdatering #5: 2012-08-14 Tommy Lindh
-- Uppdatering #4: 2012-08-02 Tommy Lindh
-- Uppdatering #3: 2012-08-01 Marcus Thunström
-- Uppdatering #2: 2012-07-24 Alexander Alesand
-- Uppdatering #1: 2012-07-?? Marcus Thunström
--
-----------------------------------------------------------------------------------------
--
-- Om du vill lägga till en funktion:
--  1. Deklarera funktionen som local högst upp på sidan
--  2. Definiera funktionen bland de andra funktionerna
--  3. Lägg till din funktions namn i tabellen som returneras längst ner på sidan
--  4. Lägg till datum och ditt namn i uppdateringslistan här ovan
--  5. Commita till alla sprintar
--
-----------------------------------------------------------------------------------------






local addSelfRemovingEventListener
local calculate, executeMathStatement
local changeGroup
local clamp
local copyFile
local extractRandom
local fileExists
local fitObjectInArea
local fitTextInArea
local foreach
local getCsvTable
local getKeys, getValues
local getLetterOffset
local gotoCurrentScene
local indexOf, indexOfChild, indexWith, indicesWith
local isVowel, isConsonant
local jsonLoad, jsonSave
local latLonDist
local loadSounds, unloadSounds
local localToLocal
local midPoint
local moduleCreate, moduleExists, moduleUnload
local newGroup
local newLetterSequence
local newOutlineLetterSequence
local newOutlineText
local newSpriteMultiImageSet
local numberSequence
local pointDist
local pointInRect, rectIntersection
local predefArgsFunc
local printObj
local randomize
local randomWithSparsity
local removeAllChildren
local removeTableItem
local runTimeSequence
local setAttr
local shuffleList
local splitEquation
local sqlBool, sqlInt, sqlStr
local stopPropagation
local stringCount
local stringPad
local stringSplit
local stringToLower, stringToUpper
local tableCopy
local tableGetAttr
local tableInsertUnique
local tableMerge
local tableSum
local toFileName
local wordwrap
local xmlGetChild







-- Lägger till en eventlistener som bara exekveras högst en gång
function addSelfRemovingEventListener(object, eventName, handler)
	local function localHandler(e)
		object:removeEventListener(eventName, localHandler)
		handler(e)
	end
	object:addEventListener(eventName, localHandler)
end







-- Utför en simpel uträkning och returnerar resultatet
-- Exempel:
--   print(calculate(4, "+", 3)) -- 7
--   print(calculate(9, "/", 2)) -- 4.5
--   print(calculate(11, "foo", 14)) -- nil
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function calculate(nr1, op, nr2)
	if op == '+' then return nr1+nr2
	elseif op == '-' then return nr1-nr2
	elseif op == '*' then return nr1*nr2
	elseif op == '/' then return nr1/nr2
	elseif op == '%' then return nr1%nr2
	elseif op == '^' then return nr1^nr2
	else return nil end -- error
end



-- Returnerar värdet av ett matematiskt påstående
-- Variabler och funktioner kan användas i påståendet (Se exempel)
--[[
	Exempel:

		executeMathStatement("1+2")  -- 3
		executeMathStatement("1+x*y", {x=2, y=3})  -- (1+2)*3  = 9

		local funcs = {}
		funcs.randOne = function(currentNumber, operator)
			return false, math.random(3, 5) -- returnerat värde läggs på det gamla värdet
		end
		executeMathStatement("5+randOne", funcs)  -- 5+math.random(3,5)  = [8..10]

		funcs.randTwo = function(currentNumber, operator)
			return true, math.random(3, 5) -- returnerat värde ersätter det gamla värdet
		end
		executeMathStatement("5+randTwo", funcs)  -- math.random(3,5)  = [3..5]

		funcs.mod = function(currentNumber, operator)
			return nil, nil, "%" -- returnera ny operator (men inget nytt värde)
		end
		executeMathStatement("5mod3", funcs)  -- 5%3  = 2

]]
-- Uppdaterad: 2012-09-05 18:05 av Marcus Thunström
function executeMathStatement(eq, funcs)
	local nr, op, funcs = 0, '+', funcs or {}
	for _, part in ipairs(splitEquation(eq)) do
		local func = funcs[part]
		if part == ' ' then
			--void
		elseif func then
			if type(func) == 'function' then
				local absolute, newNr, newOp = funcs[part](nr, op)
				if newOp then op = newOp end
				if absolute then nr = newNr elseif newNr then nr = calculate(nr, op, newNr) end
			else
				nr = calculate(nr, op, func)
			end
		elseif part=='+' or part=='-' or part=='*' or part=='/' or part=='%' or part=='^' then
			op = part
		elseif funcs._nr then
			nr = calculate(nr, op, funcs._nr(tonumber(part)))
		else
			nr = calculate(nr, op, tonumber(part))
		end
	end
	return nr
end







--Flyttar ett object från en grupp till en annan.
--Objektet behåller sin plats på skärmen.

-- Uppdaterad: 2012-08-01 19:50 av Marcus Thunström
function changeGroup(object, group)
	local x, y = localToLocal(object, 0, 0, group)
	group:insert(object)
	object.xOrigin, object.yOrigin = x, y
end







-- Begränsar ett värde inom ett intervall
function clamp(value, min, max)
	if value <= min then
		return min
	elseif value >= max then
		return max
	else 
		return value
	end
end







-- Kopierar en fil till en annan fil
function copyFile( copyFromPath, pasteToPath )
	local reader = io.open( copyFromPath, "r" )
	if not reader then
		print ("WARNING: copyFromPath är inte korrekt")
		return false
	end
	local contents = reader:read( "*a" )
	io.close( reader )

	local writer = io.open( pasteToPath, "w" )
	if not writer then
		print ("WARNING: pasteToPath är inte korrekt")
		return false
	end
	writer:write( contents )
	io.close( writer )
	return true
end





-- Tar bort 'amount' stycken objekt ur en array och returnerar de borttagna objekten
-- Exempel:
--   local allNumbers = {1, 2, 3, 5, 8}
--   local extractedNumbers = extractRandom(allNumbers, 2)
--   -- Om nu extractedNumbers={3,8} så är allNumbers={1,2,5}
--   -- Om istället extractedNumbers={5,1} så är allNumbers={2,3,8}
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function extractRandom(t, amount)
	local randT = {}
	for i = 1, amount do
		table.insert(randT, table.remove(t, math.random(1, #t)))
	end
	return randT
end







-- Kollar om en fil existerar i ett directory
-- Exempel:
--   print(fileExists("filSomInteFinns.png", system.TemporaryDirectory))  -- false
-- Uppdaterad: 2012-04-23 16:45 av Marcus Thunström
function fileExists(file, dir)
	local path = system.pathForFile(file, dir or system.DocumentsDirectory)
	if not path then return false end
	local handle = io.open(path, 'r')
	if handle then
		handle:close()
		return true
	else
		return false
	end
end







-- Skalar ner ett displayobjekt så det passar i en ruta om objektet är för stort
-- Kan även skala upp för små objekt om 'alwaysScale' är satt
-- Uppdaterad: 2012-07-23 16:35 av Marcus Thunström
function fitObjectInArea(obj, width, height, alwaysScale)
	local objW, objH = obj.width, obj.height
	if alwaysScale or objW > width or objH > height then
		local scale = math.min(width/objW, height/objH)
		obj.xScale, obj.yScale = scale, scale
	end
	return obj
end







-- Förminskar textstorleken tills textobjektet får plats inom en viss bredd
-- Uppdaterad: 2012-05-09 13:45 av Marcus Thunström
function fitTextInArea(txtObj, maxWidth)
	while txtObj.contentWidth > maxWidth do 
		txtObj.size = txtObj.size-2
	end
	return txtObj
end







-- Kör en funktion på alla objekt i en array eller grupp
-- Uppdaterad: 2012-07-13 17:15 av Marcus Thunström
function foreach(tableOrGroup, callback)
	for i = 1, tableOrGroup.numChildren or #tableOrGroup do
		if callback(tableOrGroup[i], i) then break end
	end
end







-- Konverterar en fil innehållande CSV-data till en array med tables
-- Första raden i CSV-filen används som kolumn/attributnamn
--   getCsvTable(fileName, [dir,] [colNames])
-- Uppdaterad: 2012-08-28 12:00 av Marcus Thunström
function getCsvTable(fileName, dir, colNames)
	if type(dir) ~= 'userdata' then dir, colNames = nil, dir end

	local path = system.pathForFile(fileName, dir or system.ResourceDirectory)
	if not path then return nil end
	local file = io.open(path, 'r')

	local contents = file:read('*a')
	io.close(file)

	local lines = {}

	local values = {}
	local valueStart = 1
	local isInQuote = false
	local isQuote = false
	local lastChar = nil
	for i = 1, #contents+1 do
		local char = contents:sub(i, i)
		isQuote = (char == '"')
		if isInQuote then

			if isQuote then
				isInQuote = false
				isQuote = true
			elseif char == '' then
				error('EOF reached - missing a quote sign in '..fileName, 2)
			end

		else--if not isInQuote then

			if isQuote then
				isInQuote = true
			elseif (char == '\n' or char == '') and lastChar == '\n' then
				valueStart = i+1
			elseif char == ',' or char == '\n' or char == '' then
				local valueEnd = i-1
				if lastChar == '"' then valueStart = valueStart+1; valueEnd = valueEnd-1 end
				if valueEnd < valueStart then
					values[#values+1] = ''
				else
					values[#values+1] = contents:sub(valueStart, valueEnd):gsub('""', '"')
				end
				valueStart = i+1
				if char ~= ',' then
					lines[#lines+1] = values
					values = {}
				end
			end

		end
		lastChar = char
	end--for

	if #lines < 2 then
		return {}
	else
		local cols = lines[1]
		local t = {}
		for i = 2, #lines do
			local line = lines[i]
			local row = {}
			if colNames then
				for i, col in ipairs(cols) do
					local k = colNames[col]
					if k then row[k] = line[i] or '' end
				end
			else
				for i, col in ipairs(cols) do row[col] = line[i] or '' end
			end
			t[#t+1] = row
		end
		return t
	end

end







-- Listar alla keys som används i en table
-- Uppdaterad 2012-08-16 13:50 av Marcus Thunström
function getKeys(t)
	local keys = {}
	for k, _ in pairs(t) do keys[#keys+1] = k end
	return keys
end

-- Listar alla värden som finns i en table
-- Du kan specifiera vilka index/keys vars värde ska returneras
-- Uppdaterad 2012-09-05 11:25 av Marcus Thunström
function getValues(t, keys)
	local values = {}
	if keys then
		for i, k in ipairs(keys) do
			values[i] = t[k]
		end
	else
		for _, v in pairs(t) do values[#values+1] = v end
	end
	return values
end







-- Beräknar en bokstavs x-position i ett textobjekt
-- Uppdaterad 2012-07-23 19:15 av Marcus Thunström
function getLetterOffset(textObject, letter, fontName)
	local referenceText = textObject.text:sub(1, (textObject.text:find(letter))-1, 1, true)
	local referenceTextObject = display.newText(referenceText, 0, 0, fontName, textObject.size)
	local width1 = referenceTextObject.width
	referenceTextObject.text = referenceTextObject.text..letter
	local width2 = referenceTextObject.width
	local offset = (width1+width2)/2
	referenceTextObject:removeSelf()
	return offset
end







-- Uppdaterad: innan 2012-07-16 av Marcus Thunström
function gotoCurrentScene(options)

	local composer = require('composer')
	--local curSceneName = composer.getCurrentSceneName()
	local curSceneName = composer.getSceneName("current")

	local overlay = display.captureScreen()

	local tmpSceneName = 'temp'..math.random(10000, 99999)
	local tmpScene = composer.newScene(tmpSceneName)

	function tmpScene:create()
		self.view:insert(overlay)
		overlay.x, overlay.y = display.contentWidth/2, display.contentHeight/2
	end
	function tmpScene:show()
		composer.gotoScene(curSceneName, options)
	end
	function tmpScene:didhide()
		composer.removeScene(tmpSceneName)
	end

	tmpScene:addEventListener('create', tmpScene)
	tmpScene:addEventListener('show', tmpScene)
	tmpScene:addEventListener('didhide', tmpScene)

	composer.gotoScene(tmpSceneName)

end







--[[ Notera: ej relevant längre!
-- Buggfix: delvis svart skärm när man går från en scen till samma scen
-- Uppdaterad: 2012-05-09 13:45 av Marcus Thunström
function gotoSceneSlideEffectFix(sceneToFollow, time, offsetX, offsetY)

	tabBar.isVisible = false
	local overlay = display.captureScreen()
	tabBar.isVisible = true

	if sceneToFollow then overlay:toBack() else overlay.isVisible = false end
	overlay:setReferencePoint(display.CenterReferencePoint)

	local handle = {}

	local function efHandle()
		if not sceneToFollow then return end
		overlay.x = sceneToFollow.view.x+(offsetX or 0)
		overlay.y = sceneToFollow.view.y+(offsetY or 0)
	end

	Runtime:addEventListener('enterFrame', efHandle)

	timer.performWithDelay(time, function()
		overlay:removeSelf()
		Runtime:removeEventListener('enterFrame', efHandle)
		handle.setScene = nil
	end)

	function handle:setScene(scene)
		sceneToFollow = scene
		overlay.isVisible = not not scene
		overlay:toBack()
	end

	return handle

end
--]]







-- Returnerar vilket index ett värde har i en array (precis som table.indexOf)
-- Funktionen fungerar även på displaygrupper
--[[
	Beskrivning:
		index = indexOf(table, value, returnLast)
			table: arrayen att söka igenom
			value: värdet att söka efter
			returnLast: om satt, returnerar sista förekomsten av värdet istället för första
	Exempel:
		t = {"A", "B", "C", "B"}
		indexOf(t, "B")  -- 2
		indexOf(t, "foo")  -- nil
		indexOf(t, "B", true)  -- 4
]]
-- Uppdaterad: 2012-08-16 08:50 av Marcus Thunström
function indexOf(t, obj, returnLast, startIndex)
	startIndex = startIndex or 1
	local from, to, step = startIndex, t.numChildren or #t, startIndex
	if returnLast then from, to, step = to, from, -1 end
	for i = from, to, step do
		if t[i] == obj then return i end
	end
	return nil
end



-- Returnerar vilken position 'child' har i en/sin parent
-- Ger tillbaks nil om 'child' inte finns i 'parent' (om 'parent' har angetts)
-- Uppdaterad: 2012-05-07 14:00 av Marcus Thunström
function indexOfChild(child, parent)
	parent = parent or child.parent
	for i = 1, parent.numChildren do
		if parent[i] == child then return i end
	end
	return nil
end



-- Kollar upp vilket objekt i en array vars specifierad attribut innehåller ett värde
-- Funktionen fungerar även på displaygrupper
--[[
	Beskrivning:
		index = indexOf(table, attr, value, returnLast, invert)
			table: arrayen att söka igenom
			attr: vilket attribut som ska kollas på objekten
			value: värdet att söka efter
			returnLast: om satt, returnerar sista förekomsten av värdet istället för första
			invert: om satt, returnerar alla förekomster som INTE innehåller värdet
	Exempel:
		t = {
			{name = "foo"},
			{name = "bar"},
			{name = "bat"}
			{name = "foo"},
		}
		indexWith(t, "name", "bar")  -- 2
		indexWith(t, "name", "foobar")  -- nil
		indexWith(t, "name", "foo", true)  -- 4
		indexWith(t, "name", "foo", false, true)  -- 2
]]
-- Uppdaterad: 2012-08-16 09:50 av Marcus Thunström
function indexWith(t, attr, obj, returnLast, invert, startIndex)
	invert = not invert
	local from, to, step
	if returnLast then
		from, to, step = startIndex or t.numChildren or #t, 1, -1
	else
		from, to, step = startIndex or 1, t.numChildren or #t, 1
	end
	if attr then
		for i = from, to, step do
			if (t[i][attr] == obj) == invert then return i, t[i] end
		end
	else -- obj = key/value pairs
		for i = from, to, step do
			local match = true
			for k, v in pairs(obj) do
				if t[i][k] ~= v then match=false; break end
			end
			if match == invert then return i, t[i] end
		end
	end
	return nil, nil
end



-- Kollar upp vilka objekt i arrayen 't' vars attribut 'attr' innehåller 'obj'
-- Sätt invert för 
-- Funktionen fungerar även på displaygrupper
-- Exempel:
--   t = {
--     {name = "foo"},
--     {name = "bar"},
--     {name = "foo"},
--     {name = "bat"}
--   }
--   indicesWith(t, "name", "foo")  -- {1, 3}
--   indicesWith(t, "name", "foobar")  -- {}
--   indicesWith(t, "name", "bat", true)  -- {1, 2, 3}
-- Uppdaterad: 2012-08-28 13:10 av Marcus Thunström
function indicesWith(t, attr, obj, invert)
	invert = not invert
	local indices, objects = {}, {}
	if attr then
		for i = 1, t.numChildren or #t do
			if (t[i][attr] == obj) == invert then indices[#indices+1]=i; objects[#objects+1]=t[i] end
		end
	else -- obj = key/value pairs
		for i = 1, t.numChildren or #t do
			local match = true
			for k, v in pairs(obj) do
				if t[i][k] ~= v then match=false; break end
			end
			if match == invert then indices[#indices+1]=i; objects[#objects+1]=t[i] end
		end
	end
	return indices, objects
end







do

	local vowels = {'a', 'o', 'u', 'å', 'e', 'i', 'y', 'ä', 'ö'}

	function isVowel(letter)
		return not isConsonant(letter)
	end

	function isConsonant(letter)
		return not table.indexOf(vowels, stringToLower(letter))
	end

end







-- Ladda data från en JSON-fil
-- jsonLoad(fileName, dir)
function jsonLoad(fileName, dir)
	local path = system.pathForFile(fileName, dir or system.DocumentsDirectory)
	if not path then return nil end
	local file = io.open(path, 'r')
	if not file then return nil end
	local data = require('json').decode(file:read('*a'))
	io.close(file)
	return data
end

-- Spara data till en JSON-fil
-- jsonSave(fileName, [dir,] data)
function jsonSave(fileName, dir, data)
	if type(dir) ~= 'userdata' then dir, data = nil, dir end
	local path = system.pathForFile(fileName, dir or system.DocumentsDirectory)
	local file = io.open(path, 'w+')
	file:write(require('json').encode(data))
	io.close(file)
end







-- Räknar ut avståndet mellan två latitud/longitud-koordinater
-- Källa: http://www.movable-type.co.uk/scripts/latlong.html
function latLonDist(lat1, lon1, lat2, lon2)

	local R = 6371 -- km
	local dLat = math.rad(lat2-lat1)
	local dLon = math.rad(lon2-lon1)
	local lat1 = math.rad(lat1)
	local lat2 = math.rad(lat2)

	local a = math.sin(dLat/2) * math.sin(dLat/2) +
		math.sin(dLon/2) * math.sin(dLon/2) * math.cos(lat1) * math.cos(lat2) 
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a)) 
	local d = R * c

	return d

end







-- Laddar flera ljud in i en tabell
--[[
	Beskrivning:
		soundTable = loadSounds(t, [pathPrefix, pathSuffix])
			t: tabell innehållande ljudfilsnamn (se exempel)
			pathPrefix: sträng som läggs till före ljudfilsnamnet när ljudet laddas
			pathSuffix: sträng som läggs till efter ljudfilsnamnet när ljudet laddas (Default = ".mp3")

	Exempel 1:
		local t = {
			["foo"] = 'audio/foo_music.mp3',
			["bar"] = 'audio/bar_sound.mp3',
		}
		local sounds = loadSounds(t)
		audio.play(sounds['foo'])  -- spelar upp 'audio/foo_music.mp3'

	Exempel 2:
		local t = {"foo", "bär"}
		local sounds = loadSounds(t, "audio/", ".mp3")
		audio.play(sounds["bär"])  -- spelar upp 'audio/baer.mp3'
]]
-- Uppdaterad: 2012-09-04 11:15 av Marcus Thunström
function loadSounds(t, pre, suf)
	pre, suf = pre or '', suf or '.mp3'
	local sounds = {}
	if type((pairs(t)(t))) == 'number' then
		for _, name in ipairs(t) do sounds[name] = audio.loadSound(pre..toFileName(name)..suf) end
	else
		for name, path in pairs(t) do sounds[name] = audio.loadSound(pre..toFileName(path)..suf) end
	end
	return sounds
end



-- Kör audio.dispose() på alla ljud i en array eller tabell
-- Uppdaterad: 2012-08-27 09:15 av Marcus Thunström
function unloadSounds(t)
	for _, h in pairs(t) do audio.dispose(h) end
end







-- Returnerar ett displayobjekts koordinater i ett annat objekts koordinatsystem
-- Uppdaterad: 2012-07-17 15:50 av Marcus Thunström
function localToLocal(obj, objX, objY, refSpace)
	local contentX, contentY = obj:localToContent(objX, objY)
	return refSpace:contentToLocal(contentX, contentY)
end







-- Returnerar coordinaten för punkten mitt mellan två punkter
-- Uppdaterad: 2012-08-16 13:20 av Marcus Thunström
function midPoint(x1, x2, y1, y2)
	x1, x2, y1, y2 = x1 or 0, x2 or 0, y1 or 0, y2 or 0
	return x1+(x2-x1)/2, y1+(y2-y1)/2
end







-- Skapar en modul (om den inte redan existerar)
-- Sätt 'overwrite' till true för att skriva över existerande modul
-- Uppdaterad: 2012-08-31 09:00 av Marcus Thunström
function moduleCreate(name, content, overwrite)
	if not (overwrite and package.loaded[name]) then package.loaded[name] = content end
end

-- Kollar om en modul existerar
-- Uppdaterad: 2012-08-31 09:00 av Marcus Thunström
function moduleExists(name)
	return not not package.loaded[name]
end

-- Tar bort en modul
-- Uppdaterad: 2012-08-31 09:00 av Marcus Thunström
function moduleUnload(name)
	package.loaded[name] = nil
end







-- Skapar en grupp direkt i en annan grupp
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function newGroup(parent)
	local group = display.newGroup()
	if parent then parent:insert(group) end
	return group
end







-- Skapar en grupp som innehåller alla individuella tecken i en sträng som individuella textobjekt
-- Uppdaterad: 2012-08-27 15:40 av Marcus Thunström
do
	local function setText(self, txt)
		for i = 1, self.numChildren do
			self[i].text = txt
		end
	end
	local function setTextColor(self, ...)
		for i = 1, self.numChildren do
			self[i]:setTextColor(...)
		end
	end
	function newLetterSequence(parent, str, ...)

		local charGroup = display.newGroup()
		if parent then parent:insert(charGroup) end

		local utf8 = require('modules.utf8')

		local refText = display.newText('', ...)
		for i = 1, utf8.len(str) do
			--
			local char = utf8.sub(str, i, i)
			local txtObj = display.newText(charGroup, char, ...)
			--
			local w = refText.width
			refText.text = refText.text..char
			txtObj.x = (w+refText.width)/2
			--
		end
		refText:removeSelf()

		--charGroup:setReferencePoint(display.CenterReferencePoint)
		charGroup.anchorX = .5
		charGroup.anchorY = .5
		charGroup.setText = setText
		charGroup.setTextColor = setTextColor

		return charGroup

	end
end







-- Kombinerar newLetterSequence() och newOutlineText()
-- Uppdaterad: 2012-08-27 15:35 av Marcus Thunström
do
	local function setText(self, txt)
		for i = 1, self.numChildren do
			self[i].text = txt
		end
	end
	local function setTextColor(self, ...)
		for i = 1, self.numChildren do
			self[i]:setTextColor(...)
		end
	end
	function newOutlineLetterSequence(txtColor, outlineColor, offset, quality, parent, str, ...)

		local charGroup = display.newGroup()
		if parent then parent:insert(charGroup) end

		local utf8 = require('modules.utf8')

		local refText = display.newText('', ...)
		for i = 1, utf8.len(str) do
			--
			local char = utf8.sub(str, i, i)
			local txtObj = newOutlineText(txtColor, outlineColor, offset, quality, charGroup, char, ...)
			--
			local w = refText.width
			refText.text = refText.text..char
			txtObj.x = (w+refText.width)/2
			--
		end
		refText:removeSelf()

		--charGroup:setReferencePoint(display.CenterReferencePoint)
		charGroup.anchorX = 0.5
		charGroup.anchorY = 0.5
		charGroup.setText = setText
		charGroup.setTextColor = setTextColor

		return charGroup

	end
end







-- Skapar en text med en färgad outline
--[[
	Beskrivning:
		displayGroup = newOutlineText(textColor, outlineColor, outlineThickness, quality, parent, string, left, top, [width, height,] font, size)
			textColor & outlineColor: RGBA-färg
			outlineThickness: ytterlinjens tjocklek
			quality: hur många textobjekt ytterlinjen ska bestå av
	Exempel:
		local niceText = newOutlineText({0,200,255}, {150,0,0}, 1, 3, nil, "Kalle", 80, 70, "aNiceFont", 32)
]]
-- Uppdaterad: 2012-07-27 14:50 av Marcus Thunström
do

	local function setOutlineColor(self, ...)
		for i = 1, self.numChildren-1 do self[i]:setTextColor(...) end
	end

	local function setText(self, txt)
		for i = 1, self.numChildren do self[i].text = txt end
	end

	local function setTextColor(self, ...)
		self[self.numChildren]:setTextColor(...)
	end

	local mt
	mt = {
		__index = function(self, k)
			if k == 'text' then
				return self[1].text
			else
				setmetatable(self, self.__coronaMt)
				local v = self[k]
				setmetatable(self, mt)
				return v
			end
		end,
		__newindex = function(self, k, v)
			if k == 'text' then
				for i = 1, self.numChildren do self[i].text = v end
			else
				setmetatable(self, self.__coronaMt)
				self[k] = v
				setmetatable(self, mt)
			end
		end,
	}



	function newOutlineText(txtColor, outlineColor, offset, quality, parent, ...)

		local txtGroup = display.newGroup()
		if parent then parent:insert(txtGroup) end

		if type(outlineColor) ~= 'table' then
			outlineColor = {outlineColor, outlineColor, outlineColor, 255}
		end
		local r, g, b, a = unpack(outlineColor)
		a = a or 255

		local ang = 0
		local stepAng = 2*math.pi/quality
		for outline = 1, quality do
			local txtObj = display.newText(txtGroup, ...)
			txtObj:setTextColor(r, g, b, a)
			txtObj.x, txtObj.y = offset*math.sin(ang), offset*math.cos(ang)
			ang = ang+stepAng
		end

		local txtObj = display.newText(txtGroup, ...)
		txtObj:setTextColor(unpack(type(txtColor) == 'table' and txtColor or {txtColor}))
		txtObj.x, txtObj.y = 0, 0

		txtGroup.setText = setText
		txtGroup.setTextColor = setTextColor
		txtGroup.setOutlineColor = setOutlineColor

		txtGroup.__coronaMt = getmetatable(txtGroup)
		setmetatable(txtGroup, mt)

		return txtGroup

	end

end







-- Skapar ett sprite sheet utifrån flera bildfiler med en frame i varje fil
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function newSpriteMultiImageSet(pathPrefix, pathSuffix, frames, w, h)
	local spriteSheets = {}
	for frame = 1, frames do
		local path = pathPrefix..stringPad(tostring(frame), '0', 3, 'L')..pathSuffix
		table.insert(spriteSheets, {
			sheet = sprite.newSpriteSheet(path, w, h),
			frames = {1}
		})
	end
	return sprite.newSpriteMultiSet(spriteSheets)
end







-- Skapar en array med 'amount' antal slumpmässigt unika nummer mellan 'min' och 'max'
-- Det går att ange nummer som alltid ska vara med med 'nrsToKeep'
-- Exempel:
--
--   local numbers = numberSequence(1, 10, 3)
--   -- numbers kan vara t.ex. {2,6,8} eller {1,8,10}
--
--   numbers = numberSequence(1, 10, 4, {1,2} )
--   -- numbers kan vara t.ex. {1,2,4,10} eller {1,2,7,9}
--   -- 1 & 2 är alltid med
--
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function numberSequence(min, max, amount, nrsToKeep)
	nrsToKeep = nrsToKeep or {}
	local nrs = {}
	for nr = min, max do table.insert(nrs, nr) end
	for i = min, max-amount do
		local loops, iToRemove = 0
		repeat
			loops = loops+1
			if loops > 10000 then return nrs end -- Error: kan inte ta bort till räckligt många nummer?
			iToRemove = math.random(1, #nrs)
		until table.indexOf(nrsToKeep, nrs[iToRemove]) == nil
		table.remove(nrs, iToRemove)
	end
	return nrs
end







-- Returnerar avståndet mellan två punkter
-- Uppdaterad: 2012-09-05 12:15 av Marcus Thunström
function pointDist(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2+(y1-y2)^2)
end







-- Kollar om en punkt är inom en rektangel
-- Det finns två sätt att kalla på funktionen:
--   pointInRect(pointX, pointY, rectX, rectY, rectWidth, rectHeight)
--   pointInRect(pointX, pointY, rectObject)
--     rectObject är ett ett objekt med ett x-, y-, width- och height-värde
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function pointInRect(pointX, pointY, rectX, rectY, w, h)
	if type(rectX) == 'table' then
		local rect = rectX
		rectX, rectY, w, h = rect.x, rect.y, rect.width, rect.height
	end
	return pointX >= rectX and pointY >= rectY and pointX < rectX+w and pointY < rectY+h
end


-- Kollar om två rektanglar överlappar varandra (fungerar med alla display objects)
-- rectIntersection(r1, r2)
-- r1 och r2 är displayobjects.
-- Uppdaterad: 2012-08-30 17:57 av Tommy Lindh
function rectIntersection(r1, r2)
	local bounds1 = r1.contentBounds
	local bounds2 = r2.contentBounds

    return not ( bounds2.xMin > bounds1.xMax
				or bounds2.xMax < bounds1.xMin
				or bounds2.yMin > bounds1.yMax
				or bounds2.yMax < bounds1.yMin
			)
end




-- "Predefined arguments function"
-- Returnerar en funktion som kallar på speciferad function med en uppsättning av fördefinerade argument
-- Exempel:
--   function printString(str)
--     print(str)
--   end
--   printHello = predefArgsFunc(printString, "Hello!")
--   printHello()  -- Hello!
--   printWorld = predefArgsFunc(printString, "world")
--   printWorld()  -- world
-- Uppdaterad: 2012-05-09 16:20 av Marcus Thunström
function predefArgsFunc(func, ...)
	local args = {...}
	return function() return func(unpack(args)) end
end







-- Printar ut objekt på ett bättre sätt
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function printObj(...)
	local function printObj(o, indent, name)
		if indent > 100 then return end
		if name then
			name = name..' = '
		else
			name = ''
		end
		if type(o) == 'table' then
			print(string.rep('\t', indent)..name..'{')
			for i, v in pairs(o) do
				if v == o then
					print(string.rep('\t', indent+1)..name..'SELF')
				else
					printObj(v, indent+1, i)
				end
			end
			print(string.rep('\t', indent)..'}')
		else
			print(string.rep('\t', indent)..name..tostring(o))
		end
	end
	for i, v in ipairs({...}) do
		printObj(v, 0)
	end
end







-- Lägger objekten i en array i slumpmässig ordning
-- Ett intervall kan anges
-- Uppdaterad: 2012-06-05 16:20 av Marcus Thunström
function randomize(t, from, to)
	from = from or 1
	to = to or #t
	if from < 1 then from = #t+from+1 end
	if to < 1 then to = #t+to end
	for i = from, to-1 do
		table.insert(t, from, table.remove(t, math.random(i, to)))
	end
	return t
end







-- Variation av math.random, med mindre risk för specifierade nummer
-- Uppdaterad: 2012-06-20 17:30 av Marcus Thunström
--[[ Slumphetstest:
	for sparsity = 1, 10 do
		print('Sparsity: '..sparsity)
		local counts = {[0]=0, 0, 0, 0, 0, 0}
		for i = 1, 10000 do
			local nr = randomWithSparsity(0, 5, {0, 5}, sparsity)
			counts[nr] = counts[nr]+1
		end
		for i = 0, 5 do
			print('  '..i..': '..counts[i])
		end
	end
--]]
function randomWithSparsity(min, max, sparsities, sparsity)
	sparsities = sparsities or {}
	local nr
	for i = 1, sparsity do
		nr = math.random(min, max)
		if not table.indexOf(sparsities, nr) then return nr end
	end
	return nr
end







-- Tar bort alla children från en grupp
-- Kan även ta bort children i en array från deras respektive parent
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function removeAllChildren(t)
	local len = t.numChildren or #t
	for i = len, 1, -1 do
		local child = t[i]
		if child.parent then child:removeSelf() end
	end
end







-- Tar bort ett objekt från en table
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function removeTableItem(t, obj)
	return table.remove(t, table.indexOf(t, obj))
end







-- Kör flera transition.to/from, timer.performWithDelay och/eller audio.play efter varann
-- Returnerar ett handle som kan användas för att manipulera sekvensen
--[[
	Exempel:
		local o1 = display.newRect(0, 50, 100, 100)
		local o2 = display.newRect(600, 50, 100, 100)
		local steps = {
			{type='delay', time=1000, onComplete=function()print('delay#1')end},
			{type='transition', target=o1, x=200, time=1000, onComplete=function()print('transition#1')end},
			{type='delay', time=1000, onComplete=function()print('delay#2')end},
			{type='transition', multi={
				{target=o2, x=400, y=300, time=2000},
				{target=o1, y=300, time=1000},
			}, onComplete=function()print('transition#2')end}
		}
		local handle = runTimeSequence(steps)
]]
-- Uppdaterad: 2012-08-26 19:15 av Marcus Thunström
do

	local performWithDelay  = timer.performWithDelay
	local tranFrom          = transition.from
	local tranTo            = transition.to

	local function performMagic(obj)
		local transitionFunc, target = (obj.from and tranFrom or tranTo), obj.target
		obj.type, obj.target, obj.from = nil, nil, nil
		return transitionFunc, target
	end

	function runTimeSequence(steps)
		local delay         = nil
		local i             = 0
		local soundChannel  = nil
		local timeSequence  = {}
		local transitions   = {}

		local function performNext(...)
			delay = nil
			soundChannel = nil
			transitions = {}
			if steps[i] and steps[i]._callback then steps[i]._callback(...) end
			i = i+1
			local step = steps[i]
			if not step then return end
			step._callback = step.onComplete
			if step.type == 'delay' then
			----------------------------------------------------------------

				delay = performWithDelay(step.time, performNext)

			elseif step.type == 'transition' then
			----------------------------------------------------------------

				local multi = step.multi
				if multi then

					local longestPart = multi[1]
					for i = #multi, 2, -1 do
						local part = multi[i]
						if ((part.time or 500) + (part.delay or 0)) > ((longestPart.time or 500) + (longestPart.delay or 0)) then longestPart = part end
					end
					for _, part in ipairs(multi) do
						if part == longestPart then part.onComplete = performNext else part.onComplete = nil end
						local transitionFunc, target = performMagic(part)
						transitions[#transitions+1] = transitionFunc(target, part)
					end

				else

					step.onComplete = performNext
					local transitionFunc, target = performMagic(step)
					transitions = {transitionFunc(target, step)}

				end

			elseif step.type == 'sound' and step.target then
			----------------------------------------------------------------

				soundChannel = audio.play(step.target, setAttr(step, {onComplete=function(e)
					if e.completed then performNext(e) end
				end}))

			else
			----------------------------------------------------------------

				performNext()

			end

		end

		function timeSequence:cancel()
			if delay then timer.cancel(delay) end
			if soundChannel then audio.stop(soundChannel) end
			for i = 1, #transitions do
				transition.cancel(transitions[i])
			end
			delay = nil
			soundChannel = nil
			transitions = {}
		end

		function timeSequence:skip()
			timeSequence:cancel()
			performNext()
		end

		performNext()
		return timeSequence
	end

end







-- Sätter flera attributer på ett objekt i ett svep
-- Kan även sätta speciella parametrar m.h.a. metoder, så som referenspunkt med setReferencePoint()
-- Returnerar argumentobjektet
-- Exempel:
--   img = display.newImage('foo.png')
--   setAttr(img, {x=70, rotation=5})
--   img2 = display.newImageRect('background.png', 1024, 768)
--   setAttr(img, {x=0, y=0}, {rp='TL'})
-- Uppdaterad: 2012-07-11 19:55 av Marcus Thunström
-- 
-- Kan uppdateras för Graphics 2.0 om det behövs
-- Uppdaterad: 2022-05-01 15:35 av Micke Ishaxson
do
	local rps = {
		TL=display.TopLeftReferencePoint,
		TC=display.TopCenterReferencePoint,
		TR=display.TopRightReferencePoint,
		CL=display.CenterLeftReferencePoint,
		C=display.CenterReferencePoint,
		CR=display.CenterRightReferencePoint,
		BL=display.BottomLeftReferencePoint,
		BC=display.BottomCenterReferencePoint,
		BR=display.BottomRightReferencePoint
	}
	function setAttr(obj, attrs, special)
		attrs = attrs or {}
		special = special or {}
		if special.rp then obj:setReferencePoint(rps[special.rp]) end
		for k, v in pairs(attrs) do
			obj[k] = v
		end
		if special.fc then obj:setFillColor(unpack(type(special.fc)=='table'and special.fc or{special.fc})) end
		if special.sc then obj:setStrokeColor(unpack(type(special.sc)=='table'and special.sc or{special.sc})) end
		if special.tc then obj:setTextColor(unpack(type(special.tc)=='table'and special.tc or{special.tc})) end
		return obj
	end
end







--Slumpar positionerna på objekten i en lista.
--Valfria upperbound och lowerbound för att slumpa del av listan.

-- Uppdaterad: 2012-09-04 11:50 av Marcus Thunström
function shuffleList(list, lowerBound, upperBound)
	lowerBound = lowerBound or 1
	upperBound = upperBound or #list
	for i = upperBound, lowerBound, -1 do
	   local j = math.random(lowerBound, i)
	   local tempi = list[i]
	   list[i] = list[j]
	   list[j] = tempi
	end
end







-- Delar på en sträng innehållande siffror, tecken och variabler till en array
-- Notera: det bör inte vara något whitespace i strängen
-- Exempel:
--   splitEquation("3+_=10")  -- {"3", "+", "_", "=", "10"}
--   splitEquation("32+x=58+y")  -- {"32", "+", "x", "=", "58", "+", "y"}
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function splitEquation(str)

	if str == '' then return {} end

	local starts = {}
	local startI, endI

	endI = 0
	while true do -- hitta siffror
		startI, endI = string.find(str, '%d+', endI+1)
		if startI == nil then break end
		starts[#starts+1] = startI
	end
	endI = 0
	while true do -- hitta tecken
		startI, endI = string.find(str, '%p', endI+1)
		if startI == nil then break end
		starts[#starts+1] = startI
	end
	endI = 0
	while true do -- hitta bokstäver/ord
		startI, endI = string.find(str, '[%l%u]+', endI+1)
		if startI == nil then break end
		starts[#starts+1] = startI
	end
	endI = 0
	while true do -- hitta mellanrum
		startI, endI = string.find(str, '%s+', endI+1)
		if startI == nil then break end
		starts[#starts+1] = startI
	end
	table.sort(starts)

	local parts = {}
	for i = 1, #starts-1 do
		parts[#parts+1] = string.sub(str, starts[i], starts[i+1]-1)
	end
	parts[#parts+1] = string.sub(str, starts[#starts], #str)
	return parts

end







-- Uppdaterad: 2012-05-15 10:55 av Marcus Thunström
function sqlBool(v)
	return v and 1 or 0
end

-- Uppdaterad: 2012-05-15 10:55 av Marcus Thunström
function sqlInt(v)
	return math.floor(tonumber(v) or 0)
end

-- Uppdaterad: 2012-05-15 10:55 av Marcus Thunström
function sqlStr(v)
	return '"'..(v or ''):gsub('"', '""')..'"'
end







-- Lägg till denna funktion som event listener för att stoppa bubbling vid ett visst displayobjekt
-- Exempel:
--   w, h = display.contentWidth, display.contentHeight
--   touchBlocker = display.newRect(0, 0, w, h)
--   touchBlocker:addEventListener("touch", stopPropagation)
function stopPropagation()
	return true
end







-- Räknar antalet sub-strängar i en sträng
-- Exempel:
--   print(stringCount("Hej hej hej!", "hej"))  -- 2
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function stringCount(strToSearch, strToFind)
	if #strToFind == 0 then return 0 end
	local count = 0
	local _, i = 0, 1
	while true do
		_, i = string.find(strToSearch, strToFind, i+1, true)
		if i == nil then
			return count
		else
			count = count+1
		end
	end
end







-- Fyller ut tomrummet runt en sträng så att strängen får en bestämd längd
-- Exempel:
--   print(stringPad('Hej', '!', 6))  -- Hej!!!
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function stringPad(str, padding, len, side)
	side = side or 'R'
	if #str < len then
		if side == 'L' then
			return string.rep(padding, math.floor((len-#str)/#padding))..str
		else
			return str..string.rep(padding, math.floor((len-#str)/#padding))
		end
	else
		return str
	end
end







-- Delar en sträng till en array
-- Exempel:
--   arr = stringSplit("Hej på dig!", " ")
--   print(arr[2])  -- "på"
-- Uppdaterad: innan 2012-05-14 av Marcus Thunström
function stringSplit(str, delimiter)
	local result = {}
	local from = 1
	local delimFrom, delimTo = string.find(str, delimiter, from)
	while delimFrom do
		result[#result+1] = string.sub(str, from, delimFrom-1)
		from  = delimTo + 1
		delimFrom, delimTo = string.find(str, delimiter, from)
	end
	result[#result+1] = string.sub(str, from)
	return result
end







-- Ändrar alla bokstäver (inklusive åäö) i en sträng till stora eller små
-- Kan även ta en array med strängar som argument (även multidimensionella arrayer)
-- Uppdaterad: 2012-09-07 11:45 av Marcus Thunström

function stringToLower(str)
	if type(str) == 'table' then
		local arr = {}
		for i, s in ipairs(str) do
			arr[i] = stringToLower(s)
		end
		return arr
	else
		return str:lower():gsub('Å', 'å'):gsub('Ä', 'ä'):gsub('Ö', 'ö')
	end
end

function stringToUpper(str)
	if type(str) == 'table' then
		local arr = {}
		for i, s in ipairs(str) do
			arr[i] = stringToUpper(s)
		end
		return arr
	else
		return str:upper():gsub('å', 'Å'):gsub('ä', 'Ä'):gsub('ö', 'Ö')
	end
end







-- Kopierar en tabell
-- Uppdaterad: 2012-07-16 09:50 av Marcus Thunström
function tableCopy(t, deepCopy)
	local copy = {}
	if deepCopy then
		for k, v in pairs(t) do
			copy[k] = ((type(v) == 'table') and tableCopy(v, true) or v)
		end
	else
		for k, v in pairs(t) do
			copy[k] = v
		end
	end
	return copy
end







-- Hämtar specifierad attribut hos alla objekt i en array eller grupp
-- Uppdaterad: 2012-08-26 17:15 av Marcus Thunström
--[[
	Exempel:
		local t = {
			{x=1, y=10},
			{x=2, y=15},
			{x=3, y=20},
		}
		tableGetAttr(t, "y")  -- {10,15,20}
]]
function tableGetAttr(t, attr)
	local vals = {}
	foreach(t, function(o, i) vals[i] = o[attr] end)
	return vals
end







-- Lägger in ett värde i en tabell om det inte redan finns däri
-- Uppdaterad: 2012-07-25 15:05 av Marcus Thunström
--[[
	Exempel:
		local t = {}
		tableInsertUnique(t, "A")  -- t = {"A"}
		tableInsertUnique(t, "B")  -- t = {"A", "B"}
		tableInsertUnique(t, "A")  -- t = {"A", "B"}
]]
function tableInsertUnique(t, v)
	local unique = true
	for i, tv in ipairs(t) do
		if v == tv then
			unique = false
			break
		end
	end
	if unique then t[#t+1] = v end
	return t
end







-- Slår ihop två numrerade arrayer till en array
-- Uppdaterad: 2012-07-27 17:00 av Marcus Thunström
--[[
	Exempel:
		local t1 = {"A", "B"}
		local t2 = {"i", "j"}
		local t3 = {true}
		tableMerge(t1, t2, t3)  -- {"A", "B", "i", "j", true}
]]
function tableMerge(t1, ...)
	local t = table.copy(t1)
	for _, t2 in ipairs{...} do
		for _, v in ipairs(t2) do
			t[#t+1] = v
		end
	end
	return t
end







-- Returnerar summan av alla värden i en tabell
-- Uppdaterad: 2012-05-07 16:50 av Marcus Thunström
function tableSum(t)
	local sum = 0
	for i, v in ipairs(t) do
		sum = sum+v
	end
	return sum
end







-- Ersätter ÅÄÖ med AA, AE och OE
-- Uppdaterad: 2012-04-14 11:00 av Marcus Thunström
function toFileName(name)
	name = string.gsub(name, 'Å', 'AA')
	name = string.gsub(name, 'Ä', 'AE')
	name = string.gsub(name, 'Ö', 'OE')
	name = string.gsub(name, 'å', 'aa')
	name = string.gsub(name, 'ä', 'ae')
	name = string.gsub(name, 'ö', 'oe')
	return name
end







-- Källa: http://lua-users.org/wiki/StringRecipes
-- Uppdaterad: innan 2012-05-18 09:55 av Marcus Thunström
function wordwrap(str, limit, indent, indent1)
	indent = indent or ''
	indent1 = indent1 or indent
	limit = limit or 72
	local here = 1-#indent1
	return indent1..str:gsub('(%s+)()(%S+)()',
		function(sp, st, word, fi)
			if fi-here > limit then
			here = st - #indent
			return '\n'..indent..word
		end
	end)
end







-- Uppdaterad: 2012-05-14 18:20 av Marcus Thunström
function xmlGetChild(parent, childName)
	for i, child in ipairs(parent.child) do
		if child.name == childName then return child end
	end
	return nil
end







return {
	addSelfRemovingEventListener = addSelfRemovingEventListener,
	calculate = calculate,  executeMathStatement = executeMathStatement,
	changeGroup = changeGroup,
	clamp = clamp,
	copyFile = copyFile,
	extractRandom = extractRandom,
	fileExists = fileExists,
	fitObjectInArea = fitObjectInArea,
	fitTextInArea = fitTextInArea,
	foreach = foreach,
	getCsvTable = getCsvTable,
	getKeys = getKeys,  getValues = getValues,
	getLetterOffset = getLetterOffset,
	gotoCurrentScene = gotoCurrentScene,
	indexOf = indexOf,  indexOfChild = indexOfChild,  indexWith = indexWith,  indicesWith = indicesWith,
	isVowel = isVowel,  isConsonant = isConsonant,
	jsonLoad = jsonLoad,  jsonSave = jsonSave,
	latLonDist = latLonDist,
	loadSounds = loadSounds,  unloadSounds = unloadSounds,
	localToLocal = localToLocal,
	midPoint = midPoint,
	moduleCreate = moduleCreate,  moduleExists = moduleExists,  moduleUnload = moduleUnload,
	newGroup = newGroup,
	newLetterSequence = newLetterSequence,
	newOutlineLetterSequence = newOutlineLetterSequence,
	newOutlineText = newOutlineText,
	newSpriteMultiImageSet = newSpriteMultiImageSet,
	numberSequence = numberSequence,
	pointDist = pointDist,
	pointInRect = pointInRect, rectIntersection = rectIntersection,
	predefArgsFunc = predefArgsFunc,
	printObj = printObj,
	randomize = randomize,
	randomWithSparsity = randomWithSparsity,
	removeAllChildren = removeAllChildren,
	removeTableItem = removeTableItem,
	runTimeSequence = runTimeSequence,
	setAttr = setAttr,
	shuffleList = shuffleList,
	splitEquation = splitEquation,
	sqlBool = sqlBool,  sqlInt = sqlInt,  sqlStr = sqlStr,
	stopPropagation = stopPropagation,
	stringCount = stringCount,
	stringPad = stringPad,
	stringSplit = stringSplit,
	stringToLower = stringToLower,  stringToUpper = stringToUpper,
	tableCopy = tableCopy,
	tableGetAttr = tableGetAttr,
	tableInsertUnique = tableInsertUnique,
	tableMerge = tableMerge,
	tableSum = tableSum,
	toFileName = toFileName,
	wordwrap = wordwrap,
	xmlGetChild = xmlGetChild,
}






