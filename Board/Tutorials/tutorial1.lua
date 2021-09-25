local returnList = {
	background = {name = 'bg', path = 'Graphics/Backgrounds/bg01.png', width = '1536', height = '2048', xScale = 0.25, yScale = 0.25},
	objects = {
		{name = 'tile1', objectType = 'complexObject', objects = {
				{name = 'tile1Down', path = 'Graphics/Tiles/tile_single.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'tile1Up', path = 'Graphics/Tiles/tile_s02t01.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
			},
			xInPercentOfScreen = 0.5,
			yInPercentOfScreen = 0.377,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},
		{name = 'tile2', objectType = 'complexObject', objects = {
				{name = 'tile2Down', path = 'Graphics/Tiles/tile_left.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'tile2Up', path = 'Graphics/Tiles/tile_s02t01.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
			},
			xInPercentOfScreen = 0.3,
			yInPercentOfScreen = 0.5115,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},
		{name = 'tile3', objectType = 'complexObject', objects = {
				{name = 'tile3Down', path = 'Graphics/Tiles/tile_middle.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'tile3Up', path = 'Graphics/Tiles/tile_s02t01.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
			},
			xInPercentOfScreen = 0.5,
			yInPercentOfScreen = 0.5115,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},
		{name = 'tile4', objectType = 'complexObject', objects = {
				{name = 'tile4Down', path = 'Graphics/Tiles/tile_right.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'tile4Up', path = 'Graphics/Tiles/tile_s02t01.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
			},
			xInPercentOfScreen = 0.7,
			yInPercentOfScreen = 0.5115,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},
		
		-- {name = 'tile1', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0.5, yInPercentOfScreen = 0.377, xScale = 0.5, yScale = 0.5, alpha = 0},
		-- {name = 'tile2', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0.3, yInPercentOfScreen = 0.5115, xScale = 0.5, yScale = 0.5, alpha = 0},
		-- {name = 'tile3', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0.5, yInPercentOfScreen = 0.5115, xScale = 0.5, yScale = 0.5, alpha = 0},
		-- {name = 'tile4', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.5115, xScale = 0.5, yScale = 0.5, alpha = 0},

		{name = 'gate8', path = 'Graphics/Objects/gate_08.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate7', path = 'Graphics/Objects/gate_07.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate6', path = 'Graphics/Objects/gate_06.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate5', path = 'Graphics/Objects/gate_05.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate4', path = 'Graphics/Objects/gate_04.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate3', path = 'Graphics/Objects/gate_03.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate2', path = 'Graphics/Objects/gate_02.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gate1', path = 'Graphics/Objects/gate_01.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gateColor', path = 'Graphics/Objects/gate_color.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.505, xScale = 0.5, yScale = 0.5, alpha = 0},

		{name = 'marker', path = 'Graphics/Objects/marker.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.5, yInPercentOfScreen = 0.365, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'redVial', path = 'Graphics/Objects/vial_R.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.5, yInPercentOfScreen = 0.37, xScale = 0.35, yScale = 0.35, alpha = 0},
		{name = 'blob', objectType = 'complexObject', objects = {
				{name = 'blobImage', objectType = 'image', path = 'pics/marker.png', width = 128, height = 128, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'leftEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'rightEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'leftPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'rightPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
			},
			xInPercentOfScreen = 0.3,
			yInPercentOfScreen = 0.5,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},

		{name = 'hudBlob', objectType = 'complexObject', objects = {
				{name = 'hudBlobImage', objectType = 'image', path = 'pics/marker.png', width = 128, height = 128, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'hudLeftEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'hudRightEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'hudLeftPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'hudRightPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
			},
			xInPercentOfScreen = 0.36,
			yInPercentOfScreen = 0.058,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 1
		},

		{name = 'pmBg', path = 'Graphics/UI/hud_btn_fitting.png', objectType = 'image', width = 114, height = 114, xInPercentOfScreen = 0.6, yInPercentOfScreen = 0.058, xScale = 0.425, yScale = 0.425, alpha = 1},
		{name = 'minus', path = 'Graphics/UI/hud_btn_minus.png', objectType = 'image', width = 114, height = 114, xInPercentOfScreen = 0.6, yInPercentOfScreen = 0.058, xScale = 0.425, yScale = 0.425, alpha = 1},
		{name = 'plus', path = 'Graphics/UI/hud_btn_plus.png', objectType = 'image', width = 114, height = 114, xInPercentOfScreen = 0.6, yInPercentOfScreen = 0.058, xScale = 0.425, yScale = 0.425, alpha = 1},

		{name = 'text1', objectType = 'text', text = 'This tutorial will show you the basics of how to play.', font = systemfont, fontSize = _G.mediumSmallFontSize, xInPercentOfScreen = 0.5, y = 27, realH = true, fromH = true, alpha = 1},
		{name = 'colorRed', objectType = 'rect', width = 16, height = 42, xInPercentOfScreen = 0.054, yInPercentOfScreen = 0.056, xScale = 1, yScale = 1, alpha = 0},
		{name = 'tubes', path = 'Graphics/UI/hud_mixer.png', objectType = 'image', width = 260, height = 280, xInPercentOfScreen = 0.125, yInPercentOfScreen = 0.09, xScale = 0.35, yScale = 0.35, alpha = 1},
		{name = 'scale', path = 'Graphics/UI/hud_scale1_compact.png', objectType = 'image', width = 133, height = 67, xInPercentOfScreen = 0.122, yInPercentOfScreen = 0.052, xScale = 0.55, yScale = 0.55, alpha = 1},
	},
	preAnimations = {
		{time = 1, target = 'gateColor', color = {255,0,0}},
		{time = 1, target = 'marker', color = {128,255,128}},
		{time = 1, target = 'leftPupil', color = {0,0,0}},
		{time = 1, target = 'rightPupil', color = {0,0,0}},
		{time = 1, target = 'hudLeftPupil', color = {0,0,0}},
		{time = 1, target = 'hudRightPupil', color = {0,0,0}},
		{time = 1, target = 'hudBlobImage', color = {255,0,0}},
		{time = 1, target = 'colorRed', color = {255,0,0}},
		{time = 1, target = 'blobImage', color = {128,128,128}},
		{time = 500, target = 'tile1', alpha = 1},
		{time = 500, target = 'tile2', alpha = 1},
		{time = 500, target = 'tile3', alpha = 1},
		{time = 500, target = 'tile4', alpha = 1},
		{time = 1, delay = 500, target = 'gate8', alpha = 1},
		{time = 1, delay = 500, target = 'gate7', alpha = 1},
		{time = 1, delay = 500, target = 'gate6', alpha = 1},
		{time = 1, delay = 500, target = 'gate5', alpha = 1},
		{time = 1, delay = 500, target = 'gate4', alpha = 1},
		{time = 1, delay = 500, target = 'gate3', alpha = 1},
		{time = 1, delay = 500, target = 'gate2', alpha = 1},
		{time = 500, target = 'gate1', alpha = 1},
		{time = 500, target = 'gateColor', alpha = 1},
		{time = 500, target = 'redVial', alpha = 1},
		{time = 500, target = 'blob', alpha = 1},
		{time = 500, target = 'text', alpha = 1},
	},
	animationSteps = {
		{time = 1, target = 'text1', text = 'Your mission is to reach the goal gate with the correct color.'},
		{time = 1, target = 'text1', text = 'The gate and the HUD-blob both tell you which color you need.'},

		{time = 200, target = 'gateColor', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'gateColor', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'gateColor', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'gateColor', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'gateColor', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'gateColor', xScale = 0.5, yScale = 0.5, doNextAuto = true},

		{time = 200, target = 'hudBlob', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'hudBlob', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'hudBlob', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'hudBlob', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'hudBlob', xScale = 0.6, yScale = 0.6, doNextAuto = true},
		{time = 200, target = 'hudBlob', xScale = 0.5, yScale = 0.5},

		{time = 1, target = 'text1', text = 'In this example, we need a red color to finish the level.'},
		{time = 1, target = 'text1', text = 'If we click on a tile, the blob will go to that tile.', doNextAuto = true},
		{time = 200, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},

		{time = 100, simultaneous = true, target = 'leftPupil', xInPercentOfScreen = -0.04, yInPercentOfScreen = -0.06, doNextAuto = true},
		{time = 100, simultaneous = true, target = 'rightPupil', xInPercentOfScreen = 0.08, yInPercentOfScreen = -0.06, doNextAuto = true},

		{time = 200, target = 'marker', alpha = 1},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 1, target = 'blob', yScale = 0.25, doNextAuto = true},
		{time = 100, target = 'blob', xInPercentOfScreen = 0.5, doNextAuto = true},

		{time = 0, target = 'leftPupil', xInPercentOfScreen = -0.06, doNextAuto = true},
		{time = 0, target = 'rightPupil', xInPercentOfScreen = 0.06, doNextAuto = true},

		{time = 1, target = 'blob', yScale = 0.5, doNextAuto = true},
		{time = 1, target = 'text1', text = 'The blob can take several steps at once if its path isn\'t blocked.'},
		{time = 1, delay = 250, target = 'blob', xScale = 0.25, doNextAuto = true},
		{time = 100, target = 'blob', yInPercentOfScreen = 0.377, doNextAuto = true},

		{time = 0, target = 'leftPupil', yInPercentOfScreen = -0.04, doNextAuto = true},
		{time = 0, target = 'rightPupil', yInPercentOfScreen = -0.04, doNextAuto = true},

		{time = 1, target = 'blob', xScale = 0.5, doNextAuto = true},
		{time = 1, target = 'text1', text = 'When the blob walks onto a tile with a vial, it picks up that vial.', alpha = 1},
		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 500, target = 'redVial', alpha = 0, doNextAuto = true},
		{time = 500, simultaneous = true, target = 'colorRed', alpha = 1, doNextAuto = true},
		{time = 500, target = 'blobImage', color = {255,0,0}, doNextAuto = true},
		{time = 1, target = 'text1', text = 'Notice that the red container in the upper left corner is filled.', alpha = 1},
		{time = 1, target = 'text1', text = 'The color of the blob now matches the goal color, so the gate opens.', alpha = 1},
		{time = 10, target = 'gate1', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate2', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate3', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate4', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate5', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate6', alpha = 0, doNextAuto = true},
		{time = 10, target = 'gate7', alpha = 0},

		{time = 1, target = 'text1', text = 'Now that the gate is opened, we can finish the level.'},
		{time = 1, target = 'marker', xInPercentOfScreen = 0.7, yInPercentOfScreen = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},

		{time = 100, simultaneous = true, target = 'leftPupil', xInPercentOfScreen = -0.04, yInPercentOfScreen = -0.02, doNextAuto = true},
		{time = 100, simultaneous = true, target = 'rightPupil', xInPercentOfScreen = 0.08, yInPercentOfScreen = -0.02, doNextAuto = true},

		{time = 200, target = 'marker', alpha = 1},
		{time = 200, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 1, target = 'blob', xScale = 0.25, doNextAuto = true},
		{time = 100, target = 'blob', yInPercentOfScreen = 0.5, doNextAuto = true},

		{time = 0, target = 'leftPupil', yInPercentOfScreen = -0.04, doNextAuto = true},
		{time = 0, target = 'rightPupil', yInPercentOfScreen = -0.04, doNextAuto = true},

		{time = 1, target = 'blob', xScale = 0.5, doNextAuto = true},
		{time = 1, delay = 250, target = 'blob', yScale = 0.25, doNextAuto = true},
		{time = 100, target = 'blob', xInPercentOfScreen = 0.7, doNextAuto = true},

		{time = 0, target = 'leftPupil', xInPercentOfScreen = -0.06, doNextAuto = true},
		{time = 0, target = 'rightPupil', xInPercentOfScreen = 0.06, doNextAuto = true},
		
		{time = 1, target = 'blob', yScale = 0.5, doNextAuto = true},

		{time = 100, delay = 300, simultaneous = true, target = 'leftPupil', xScale = 1.2, yScale = 1.2, doNextAuto = true},
		{time = 100, target = 'rightPupil', xScale = 1.2, yScale = 1.2, doNextAuto = true},
		{time = 100, simultaneous = true, target = 'leftPupil', xScale = 1, yScale = 1, doNextAuto = true},
		{time = 100, target = 'rightPupil', xScale = 1, yScale = 1, doNextAuto = true},
		{time = 500, delay = 300, target = 'blob', xScale = 0.01, yScale = 0.01, rotation = 400, alpha = 0, doNextAuto = true},
		{time = 1, target = 'text1', text = 'And those are the basics of the game.'},
	},
	postAnimations = {
		{time = 500, target = 'gate8', alpha = 0},
		{time = 500, target = 'gateColor', alpha = 0},
		{time = 500, target = 'tile1', alpha = 0},
		{time = 500, target = 'tile2', alpha = 0},
		{time = 500, target = 'tile3', alpha = 0},
		{time = 500, target = 'tile4', alpha = 0},
		{time = 500, target = 'marker', alpha = 0},
		{time = 500, target = 'blob', alpha = 0},
		{time = 500, target = 'colorRed', alpha = 0},
	},
}

-- if _G.model == 'iPad' then
-- 	for k,v in pairs(returnList.objects) do
-- 		if v.name == 'minus' or v.name == 'plus' then
-- 			v.xScale, v.yScale = 0.25, 0.25
-- 			v.yInPercentOfScreen = v.yInPercentOfScreen*0.5
-- 		elseif v.name == 'colorRed' then
-- 			v.xScale, v.yScale = v.xScale*0.5, v.yScale*0.5
-- 			v.xInPercentOfScreen = 0.045
-- 			v.yInPercentOfScreen = 0.04
-- 		elseif v.name == 'tubes' then
-- 			v.xScale, v.yScale = v.xScale*0.5, v.yScale*0.5
-- 			v.xInPercentOfScreen = 0.085
-- 			v.yInPercentOfScreen = 0.06
-- 		elseif v.name == 'hudBlob' then
-- 			v.xScale, v.yScale = v.xScale*0.6, v.yScale*0.6
-- 			v.yInPercentOfScreen = 0.037
-- 		end
-- 	end

-- 	for k,v in pairs(returnList.animationSteps) do
-- 		if v.target == 'minus' and v.xScale then
-- 			v.xScale, v.yScale = v.xScale*0.5, v.yScale*0.5
-- 		end
-- 	end
-- end


return returnList