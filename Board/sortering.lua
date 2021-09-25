local function sortAlfabetically(v1, v2, recursing)
	local a, b = v1, v2

	if not recursing then
		a, b = v1.name, v2.name
	end

	local aStr
	local bStr

	if #a > 1 then
		aStr = string.sub(a, 1, 2)
	else
		aStr = string.sub(a, 1, 1)
	end

	if #b > 1 then
		bStr = string.sub(b, 1, 2)
	else
		bStr = string.sub(b, 1, 1)
	end

	local testA, testB

	if aStr == 'å' or aStr == 'Å'
	or aStr == 'ä' or aStr == 'Ä'
	or aStr == 'ö' or aStr == 'Ö' then
		testA = string.byte(aStr)
	else
		testA = string.byte(string.sub(a, 1, 1))
	end

	if bStr == 'å' or bStr == 'Å'
	or bStr == 'ä' or bStr == 'Ä'
	or bStr == 'ö' or bStr == 'Ö' then
		testB = string.byte(bStr)
	else
		testB = string.byte(string.sub(b, 1, 1))
	end

	if testA > testB then
		return false
	elseif testA < testB then
		return true
	else
		if #a > 1 and #b > 1 then
			return sortAlfabetically(string.sub(a, 2), string.sub(b, 2), true)
		elseif #b > 1 then
			return true
		else
			return false
		end
	end
end

return sortAlfabetically

--table.sort(listan här, funktionen här)