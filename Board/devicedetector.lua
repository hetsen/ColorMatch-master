local dd = {}

function dd.get()
	local model = system.getInfo('model')
	local H = display.pixelHeight
	local W = display.pixelWidth

	if model == "iPad" then 
		if W > 769 then 
			model = "iPad Retina"
		end 
	end 
	
	if model == "iPhone" then 
		if W > 481 then
			model = "iPhone Retina" 
		end 

		if ( (H/W) > 1.5 ) then
   			model = "iPhone 5" 
		end
	end 
	
	return model 
end

return dd
