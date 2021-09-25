local gr = {}


function gr.list (set)
	local graphics = {}
	

	if set == nil or set == "default" then 
		graphics.imagelist 		= {"Graphics/Tiles/tile_left.png","Graphics/Tiles/tile_middle.png","Graphics/Tiles/tile_right.png","Graphics/Tiles/tile_single.png"}
		graphics.itemlist  		= {"","pics/goal.png","Graphics/Objects/vial_R.png","Graphics/Objects/vial_G.png","Graphics/Objects/vial_B.png","Graphics/Objects/vial_C.png","Graphics/Objects/vial_M.png","Graphics/Objects/vial_Y.png"}
		graphics.touchtile 		= "Graphics/Objects/marker.png"
		graphics.gate 			= {"Graphics/Objects/gate_01.png","Graphics/Objects/gate_02.png","Graphics/Objects/gate_03.png","Graphics/Objects/gate_04.png","Graphics/Objects/gate_05.png","Graphics/Objects/gate_06.png","Graphics/Objects/gate_07.png","Graphics/Objects/gate_08.png"}
		graphics.gate.lamp 		= {"Graphics/Objects/gate_color.png","Graphics/Objects/gate_glow.png"}
		graphics.background 	= {"Graphics/Backgrounds/bg02.png","Graphics/Backgrounds/layer05.png","Graphics/Backgrounds/layer06.png","Graphics/Backgrounds/layer07.png"}
		graphics.star 			= {"Graphics/Objects/star02.png"}
		graphics.oneway			= {"Graphics/Objects/arrow_sprite.png"}
	end 

	--add more sets here



	return graphics 

end 

return gr
