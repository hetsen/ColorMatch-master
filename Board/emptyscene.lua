local composer 			= require "composer"
local scene 			= composer.newScene()

function scene:create(e)
	params = e.params
	print (params.level)
	prev = composer.getSceneName("previous")
	print('Prev: ', prev)
	print "emptyscene!"
	if prev then 
		composer.removeScene(prev)
	end 

function reverttolast()

	if params.toPrev then
		composer.gotoScene(prev,{params = params})
	else
		composer.gotoScene("controller",{params = params})
	end

end 

timer.performWithDelay (10, function() reverttolast() end)

end 

function scene:show(e)
	
end 

function scene:hide(e)



end 

function scene:destroy(e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
