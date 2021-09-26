aspectRatio = (display.pixelWidth / display.pixelHeight)
print("Pixel width "..display.pixelWidth)
print("Pixel height "..display.pixelHeight)
print("Aspect ratio "..aspectRatio)
if aspectRatio < 0.6 then
    -- print('iPhone 5')
    _G.iphoneFive = true
-- elseif aspectRatio < 0.7 then
--     print('iPhone')
-- else
--     print('iPad')
end

application = {
	content = {
      graphicsCompatibility = 1,  --this turns on V1 Compatibility mode
        
		width = 320,
		height = 320 / aspectRatio, 
		scale = "none",
		fps = 60,
		
		
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
