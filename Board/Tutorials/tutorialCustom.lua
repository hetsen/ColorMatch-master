local returnList = {
	custom = true,
	--background = {name = 'bg', path = 'Graphics/Backgrounds/bg01.png', width = '1536', height = '2048', xScale = 0.25, yScale = 0.25},
	objects = {
		{
			name = 'canvas',
			objectType = 'complexObject',
			objects = {
				{name = 'rect1', objectType = 'rect', width = 64, height = 64, x = -64, y = -64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect2', objectType = 'rect', width = 64, height = 64, x = 0, y = -64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect3', objectType = 'rect', width = 64, height = 64, x = 64, y = -64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect4', objectType = 'rect', width = 64, height = 64, x = -64, y = 0, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect5', objectType = 'rect', width = 64, height = 64, x = 0, y = 0, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect6', objectType = 'rect', width = 64, height = 64, x = 64, y = 0, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect7', objectType = 'rect', width = 64, height = 64, x = -64, y = 64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect8', objectType = 'rect', width = 64, height = 64, x = 0, y = 64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},
				{name = 'rect9', objectType = 'rect', width = 64, height = 64, x = 64, y = 64, alpha = 1, strokeWidth = 2, strokeColor = {96,96,96}},

				{name = 'tile1', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = -64, y = -59, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile2', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 0, y = -59, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile3', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 64, y = -59, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile4', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = -64, y = 5, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile5', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 0, y = 5, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile6', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 64, y = 5, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile7', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = -64, y = 69, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile8', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 0, y = 69, xScale = 0.5, yScale = 0.5, alpha = 0},
				{name = 'tile9', path = 'Graphics/Tiles/tile_s01t02.png', objectType = 'image', width = 128, height = 149, x = 64, y = 69, xScale = 0.5, yScale = 0.5, alpha = 0},
			},
			x = 160,
			y = 160,
			xScale = 1,
			yScale = 1,
			alpha = 0
		},

		{name = 'whiteColor', objectType = 'image', path = 'Graphics/UI/btn_white.png', width = 88, height = 88, xInPercentOfScreen = 0.273, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'blackColor', objectType = 'image', path = 'Graphics/UI/btn_black.png', width = 88, height = 88, xInPercentOfScreen = 0.208, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'redColor', objectType = 'image', path = 'Graphics/UI/btn_R.png', width = 88, height = 88, xInPercentOfScreen = 0.337, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'greenColor', objectType = 'image', path = 'Graphics/UI/btn_G.png', width = 88, height = 88, xInPercentOfScreen = 0.401, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'blueColor', objectType = 'image', path = 'Graphics/UI/btn_B.png', width = 88, height = 88, xInPercentOfScreen = 0.465, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'cyanColor', objectType = 'image', path = 'Graphics/UI/btn_C.png', width = 88, height = 88, xInPercentOfScreen = 0.5295, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'magentaColor', objectType = 'image', path = 'Graphics/UI/btn_M.png', width = 88, height = 88, xInPercentOfScreen = 0.5935, y = 22, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},
		{name = 'indicator', objectType = 'image', path = 'Graphics/UI/indicator_on.png', width = 102, height = 83, xInPercentOfScreen = 0.273, y = 37, fromH = true, realH = true, xScale = 0.2, yScale = 0.2, alpha = 0},

		{name = 'redVial1', objectType = 'image', path = 'Graphics/Objects/vial_R.png', width = 128, height = 128, x = 96, y = 160, xScale = 0.3, yScale = 0.3, alpha = 0},
		{name = 'blueVial1', objectType = 'image', path = 'Graphics/Objects/vial_B.png', width = 128, height = 128, x = 160, y = 96, xScale = 0.3, yScale = 0.3, alpha = 0},
		{name = 'greenVial1', objectType = 'image', path = 'Graphics/Objects/vial_G.png', width = 128, height = 128, x = 160, y = 160, xScale = 0.3, yScale = 0.3, alpha = 0},
		{name = 'redVial2', objectType = 'image', path = 'Graphics/Objects/vial_R.png', width = 128, height = 128, x = 224, y = 160, xScale = 0.3, yScale = 0.3, alpha = 0},

		{name = 'bgBlobImage', objectType = 'image', path = 'pics/marker.png', width = 128, height = 128, xInPercentOfScreen = 0.735, y = 20.5, fromH = true, realH = true, xScale = 0.22, yScale = 0.22, alpha = 1},

		{name = 'startButton', objectType = 'complexObject', objects = {
				{name = 'BlobImage', objectType = 'image', path = 'pics/marker.png', width = 128, height = 128, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'LeftEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'RightEye', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'LeftPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'RightPupil', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
			},
			xInPercentOfScreen = 0.735,
			y = 20.5,
			fromH = true,
			realH = true,
			xScale = 0.22,
			yScale = 0.22,
			alpha = 0
		},
		{name = 'startTile', objectType = 'complexObject', objects = {
				{name = 'BlobImage2', objectType = 'image', path = 'pics/marker.png', width = 128, height = 128, xInPercentOfScreen = 0, yInPercentOfScreen = 0, alpha = 1},
				{name = 'LeftEye2', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'RightEye2', objectType = 'image', path = 'Graphics/Objects/eye_sclera.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'LeftPupil2', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = -0.06, yInPercentOfScreen = -0.04, alpha = 1},
				{name = 'RightPupil2', objectType = 'image', path = 'Graphics/Objects/eye_pupil.png', width = 36, height = 36, xInPercentOfScreen = 0.06, yInPercentOfScreen = -0.04, alpha = 1},
			},
			x = 96,
			y = 96,
			xScale = 0.5,
			yScale = 0.5,
			alpha = 0
		},

		{name = 'goalButton1', path = 'Graphics/Objects/gate_01.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.81, y = 22, fromH = true, realH = true, xScale = 0.18, yScale = 0.18, alpha = 0},
		{name = 'goalButton2', path = 'Graphics/Objects/gate_08.png', objectType = 'image', width = 128, height = 128, xInPercentOfScreen = 0.81, y = 22, fromH = true, realH = true, xScale = 0.18, yScale = 0.18, alpha = 0},
		{name = 'goalTile', path = 'Graphics/Objects/gate_01.png', objectType = 'image', width = 128, height = 128, x = 96, y = 224, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'gateColor', path = 'Graphics/Objects/gate_color.png', objectType = 'image', width = 128, height = 128, x = 96, y = 224, xScale = 0.5, yScale = 0.5, alpha = 0},

		{name = 'marker', path = 'Graphics/Objects/marker.png', objectType = 'image', width = 128, height = 128, x = 160, y = 160, xScale = 0.5, yScale = 0.5, alpha = 0},
		{name = 'theMenuText', objectType = 'text', text = 'Menu', font = systemfont, fontSize = _G.smallFontSize, noBox = true, xInPercentOfScreen = 0.92, y = 22, realH = true, fromH = true, alpha = 1},

		{name = 'text1', objectType = 'text', text = 'This tutorial will show you how the level editor works.', font = systemfont, fontSize = _G.mediumSmallFontSize, xInPercentOfScreen = 0.5, y = 27, realH = true, alpha = 0},
		{name = 'colorRed', objectType = 'rect', width = 12, height = 30, xInPercentOfScreen = 0.0385, y = 14, realH = true, fromH = true, xScale = 1, yScale = 1, alpha = 0},
		{name = 'colorGreen', objectType = 'rect', width = 12, height = 30, xInPercentOfScreen = 0.0855, y = 14, realH = true, fromH = true, xScale = 1, yScale = 1, alpha = 0},
		{name = 'colorBlue', objectType = 'rect', width = 12, height = 30, xInPercentOfScreen = 0.1325, y = 14, realH = true, fromH = true, xScale = 1, yScale = 1, alpha = 0},
		{name = 'tubes', path = 'Graphics/UI/mixer.png', objectType = 'image', width = 240, height = 356, xInPercentOfScreen = 0.08, y = 33, realH = true, fromH = true, xScale = 0.25, yScale = 0.25, alpha = 1},
	},
	preAnimations = {
		{time = 1, target = 'text1', alpha = 1},
	},
	animationSteps = {
		{time = 1, target = 'colorRed', color = {255,0,0}, doNextAuto = true},
		{time = 1, target = 'colorGreen', color = {0,255,0}, doNextAuto = true},
		{time = 1, target = 'colorBlue', color = {0,0,255}, doNextAuto = true},
		{time = 1, target = 'LeftPupil', color = {0,0,0}, doNextAuto = true},
		{time = 1, target = 'RightPupil', color = {0,0,0}, doNextAuto = true},
		{time = 1, target = 'LeftPupil2', color = {0,0,0}, doNextAuto = true},
		{time = 1, target = 'RightPupil2', color = {0,0,0}, doNextAuto = true},

		{time = 1, target = 'rect1', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect2', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect3', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect4', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect5', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect6', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect7', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect8', color = {0, 0, 0}, doNextAuto = true},
		{time = 1, target = 'rect9', color = {0, 0, 0}, doNextAuto = true},
		{time = 500, target = 'canvas', alpha = 1, doNextAuto = true},

		{time = 1, target = 'text1', text = 'First, we will take a look at the canvas.'},
		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},

		-- 20

		{time = 200, target = 'canvas', xScale = 1.1, yScale = 1.1, doNextAuto = true},
		{time = 200, target = 'canvas', xScale = 1, yScale = 1, doNextAuto = true},
		{time = 200, target = 'canvas', xScale = 1.1, yScale = 1.1, doNextAuto = true},
		{time = 200, target = 'canvas', xScale = 1, yScale = 1, doNextAuto = true},
		{time = 200, target = 'canvas', xScale = 1.1, yScale = 1.1, doNextAuto = true},
		{time = 200, target = 'canvas', xScale = 1, yScale = 1},

		{time = 1, target = 'text1', text = 'When you create a new level, you start by defining the size of the canvas.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},
		{time = 1, target = 'text1', text = 'The canvas is where you put all the elements of your level.'},
		{time = 1, target = 'text1', text = 'At the bottom of the screen, there are eight colors.'},
		{time = 1, target = 'text1', text = 'If you press one of the colors, that color is selected'},
		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},

		{time = 1, target = 'whiteColor', alpha = 1, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'whiteColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 1, target = 'whiteColor', alpha = 0, doNextAuto = true},
		{time = 1, target = 'indicator', xInPercentOfScreen = 0.273, y = 37, fromH = true, realH = true, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 1},

		-- 43

		{time = 1, target = 'text1', text = 'White is used to create a tile without a vial.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},
		
		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		-- 53

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, target = 'tile5', alpha = 1},

		{time = 1, target = 'text1', text = 'Black is used to create an empty square.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'blackColor', alpha = 1, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'blackColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 1, target = 'blackColor', alpha = 0, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 0, doNextAuto = true},
		{time = 1, target = 'indicator', xInPercentOfScreen = 0.208, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 1},

		-- 69

		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, target = 'tile5', alpha = 0},

		{time = 1, target = 'text1', text = 'If you use any of the other colors, you will put a vial on the canvas.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},

		-- 80

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'redColor', alpha = 1, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 1, target = 'redColor', alpha = 0, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 0, doNextAuto = true},
		{time = 1, target = 'indicator', xInPercentOfScreen = 0.337, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 1},

		-- 92

		{time = 1, target = 'marker', x = 96, doNextAuto = true},
		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		-- 100

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, target = 'tile4', alpha = 1, doNextAuto = true},
		{time = 500, target = 'redVial1', alpha = 1},

		{time = 1, target = 'text1', text = 'No level is complete without a start and a goal.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},
		{time = 1, target = 'text1', text = 'Clicking on the blob-shaped button allows us to set a start tile.'},

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'LeftEye', alpha = 0, doNextAuto = true},
		{time = 1, target = 'RightEye', alpha = 0, doNextAuto = true},
		{time = 1, target = 'LeftPupil', color = {0,0,0}, alpha = 0, doNextAuto = true},
		{time = 1, target = 'RightPupil', color = {0,0,0}, alpha = 0, doNextAuto = true},
		{time = 1, target = 'startButton', alpha = 1, doNextAuto = true},

		-- 112

		{time = 200, target = 'startButton', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'startButton', xScale = 0.22, yScale = 0.22, doNextAuto = true},
		{time = 200, target = 'startButton', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'startButton', xScale = 0.22, yScale = 0.22, doNextAuto = true},
		{time = 200, target = 'startButton', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'startButton', xScale = 0.22, yScale = 0.22, doNextAuto = true},

		{time = 1, target = 'startButton', alpha = 0, doNextAuto = true},
		{time = 1, target = 'BlobImage', color = {128,128,128}, doNextAuto = true},
		{time = 1, target = 'LeftEye', alpha = 1, doNextAuto = true},
		{time = 1, target = 'RightEye', alpha = 1, doNextAuto = true},
		{time = 1, target = 'LeftPupil', alpha = 1, doNextAuto = true},
		{time = 1, target = 'RightPupil', alpha = 1, doNextAuto = true},
		{time = 1, target = 'startButton', alpha = 1},

		-- 125

		{time = 1, target = 'marker', y = 96, doNextAuto = true},
		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, target = 'tile1', alpha = 1, doNextAuto = true},
		{time = 1, target = 'LeftPupil2', color = {0,0,0}, doNextAuto = true},
		{time = 1, target = 'RightPupil2', color = {0,0,0}, doNextAuto = true},
		{time = 500, target = 'startTile', alpha = 1},

		-- 138

		{time = 1, target = 'text1', text = 'Clicking on the goal-shaped button allows us to set a goal tile.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'goalButton1', alpha = 1, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.22, yScale = 0.22, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.18, yScale = 0.18, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.22, yScale = 0.22, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.18, yScale = 0.18, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.22, yScale = 0.22, doNextAuto = true},
		{time = 200, target = 'goalButton1', xScale = 0.18, yScale = 0.18, doNextAuto = true},
		{time = 1, target = 'goalButton1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'startButton', alpha = 0, doNextAuto = true},
		{time = 1, target = 'goalButton2', alpha = 1},

		-- 151

		{time = 1, target = 'text1', text = 'The goal needs a color. Let\'s make it pink.', doNextAuto = true},
		{time = 1, target = 'text1', alpha = 1},

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'magentaColor', alpha = 1, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'magentaColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 1, target = 'magentaColor', alpha = 0, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 0, doNextAuto = true},
		{time = 1, target = 'indicator', xInPercentOfScreen = 0.5935, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 1},

		-- 165

		{time = 1, target = 'marker', x = 96, y = 224, doNextAuto = true},
		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		-- 173

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, target = 'tile7', alpha = 1, doNextAuto = true},
		{time = 1, target = 'gateColor', color = {255,0,255}, doNextAuto = true},
		{time = 1, target = 'colorRed', alpha = 0, yScale = 0.25, y = 5, fromH = true, realH = true, doNextAuto = true},
		{time = 1, target = 'colorBlue', alpha = 0, yScale = 0.25, y = 5, fromH = true, realH = true, doNextAuto = true},
		{time = 500, simultaneous = true, target = 'goalTile', alpha = 1, doNextAuto = true},
		{time = 500, simultaneous = true, target = 'gateColor', alpha = 1, doNextAuto = true},
		{time = 500, simultaneous = true, target = 'colorRed', alpha = 1, doNextAuto = true},
		{time = 500, target = 'colorBlue', alpha = 1, doNextAuto = true},

		{time = 1, target = 'text1', text = 'Now we have magenta. We need more red to make pink.', alpha = 1},
		{time = 1, target = 'text1', text = 'We can add more color to the goal tile by clicking on it again.'},
		{time = 1, target = 'text1', text = 'This time, we add red to the goal tile.'},

		-- 185

		{time = 1, target = 'text1', alpha = 0, doNextAuto = true},
		{time = 1, target = 'redColor', alpha = 1, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.3, yScale = 0.3, doNextAuto = true},
		{time = 200, target = 'redColor', xScale = 0.2, yScale = 0.2, doNextAuto = true},
		{time = 1, target = 'redColor', alpha = 0, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 0, doNextAuto = true},
		{time = 1, target = 'indicator', xInPercentOfScreen = 0.337, doNextAuto = true},
		{time = 200, target = 'indicator', alpha = 1},

		-- 197

		{time = 1, target = 'marker', alpha = 1, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.55, yScale = 0.55, doNextAuto = true},
		{time = 200, target = 'marker', xScale = 0.5, yScale = 0.5},

		{time = 1, target = 'marker', alpha = 0, doNextAuto = true},
		{time = 500, simultaneous = true, target = 'gateColor', color = {255,0,128}, doNextAuto = true},
		{time = 500, target = 'colorRed', yScale = 0.5, y = 8, fromH = true, realH = true},

		-- 207

		{time = 1, target = 'text1', text = 'We add some more colors to make the level playable.', alpha = 1, doNextAuto = true},

		{time = 500, target = 'tile2', alpha = 1, doNextAuto = true},
		{time = 500, target = 'blueVial1', alpha = 1, doNextAuto = true},

		{time = 500, target = 'tile3', alpha = 1, doNextAuto = true},

		{time = 500, target = 'tile5', alpha = 1, doNextAuto = true},
		{time = 500, target = 'greenVial1', alpha = 1, doNextAuto = true},

		{time = 500, target = 'tile6', alpha = 1, doNextAuto = true},
		{time = 500, target = 'redVial2', alpha = 1, doNextAuto = true},

		{time = 1, target = 'text1', text = 'When we save the level, we give it a name.'},
		{time = 1, target = 'text1', text = 'We also give the level time bonus and step bonus thresholds.'},
		{time = 1, target = 'text1', text = 'Each level must also have an amount of color segments.'},
		{time = 1, target = 'text1', text = 'Since we use two red segments, this level needs two color segments.'},
		{time = 1, target = 'text1', text = 'And that is how the level editor works.'},
	},
	postAnimations = {
		{time = 500, target = 'text1', alpha = 0},
	},
}

if _G.model == 'iPhone' or _G.model == 'iPhone 5' or _G.model == 'iPhone Retina' then
	for i = 1, 20 do
		print('AAAAAAAAJ-fone')
	end

	local function replace(replaceList, sublist)
		for k,v in pairs(replaceList) do
			for i = 1, #returnList[sublist] do
				v2 = returnList[sublist][i]

				print(v.name, v2.name)
				if (v.name and v.name == v2.name)
				or (v.id and v.id == i) then
					for k3,v3 in pairs(v) do
						v2[k3] = v3

						print(k3, v3)
					end
				end
			end
		end
	end

	local replaceObjectsList = {
		{name = 'theMenuText', xInPercentOfScreen = 0.125, fontSize = _G.mediumSmallFontSize},
		{name = 'whiteColor', xInPercentOfScreen = 0.7355, y = 71, xScale = 0.32, yScale = 0.32},
		{name = 'blackColor', xInPercentOfScreen = 0.7355, y = 21, xScale = 0.32, yScale = 0.32},
		{name = 'greenColor', xInPercentOfScreen = 0.482, y = 71, xScale = 0.32, yScale = 0.32},
		{name = 'magentaColor', xInPercentOfScreen = 0.482, y = 21, xScale = 0.32, yScale = 0.32},
		{name = 'redColor', xInPercentOfScreen = 0.355, y = 71, xScale = 0.32, yScale = 0.32},
		{name = 'bgBlobImage', xInPercentOfScreen = 0.895, y = 75, xScale = 0.4, yScale = 0.4, fromH = true, realH = true},
		{name = 'tubes', path = 'Graphics/UI/mixer_compact.png', width = 180, height = 320, xInPercentOfScreen = 0.145, y = 80, xScale = 0.5, yScale = 0.5},
	}

	replace(replaceObjectsList, 'objects')

	local replaceObjectsList = {
		{id = 1, xInPercentOfScreen = 0.049, y = 54, fromH = true, realH = true, xScale = 1.6, yScale = 0.4},
		{id = 2, xInPercentOfScreen = 0.13, y = 54, fromH = true, realH = true, xScale = 1.6, yScale = 0.4},
		{id = 3, xInPercentOfScreen = 0.21, y = 54, fromH = true, realH = true, xScale = 1.6, yScale = 0.4},

		{id = 33, xScale = 0.4, yScale = 0.4},
		{id = 34, xScale = 0.32, yScale = 0.32},
		{id = 35, xScale = 0.4, yScale = 0.4},
		{id = 36, xScale = 0.32, yScale = 0.32},
		{id = 37, xScale = 0.4, yScale = 0.4},
		{id = 38, xScale = 0.32, yScale = 0.32},

		{id = 40, xInPercentOfScreen = 0.734, y = 95, fromH = true, realH = true, xScale = 0.3, yScale = 0.3},

		{id = 58, xScale = 0.4, yScale = 0.4},
		{id = 59, xScale = 0.32, yScale = 0.32},
		{id = 60, xScale = 0.4, yScale = 0.4},
		{id = 61, xScale = 0.32, yScale = 0.32},
		{id = 62, xScale = 0.4, yScale = 0.4},
		{id = 63, xScale = 0.32, yScale = 0.32},

		{id = 66, xInPercentOfScreen = 0.734, y = 45, fromH = true, realH = true, xScale = 0.3, yScale = 0.3},

		{id = 81, xScale = 0.4, yScale = 0.4},
		{id = 82, xScale = 0.32, yScale = 0.32},
		{id = 83, xScale = 0.4, yScale = 0.4},
		{id = 84, xScale = 0.32, yScale = 0.32},
		{id = 85, xScale = 0.4, yScale = 0.4},
		{id = 86, xScale = 0.32, yScale = 0.32},

		{id = 89, xInPercentOfScreen = 0.3515, y = 95, fromH = true, realH = true, xScale = 0.3, yScale = 0.3},

		{id = 110, xScale = 0.4, yScale = 0.4, xInPercentOfScreen = 0.895, y = 75, fromH = true, realH = true},

		{id = 111, xScale = 0.48, yScale = 0.48},
		{id = 112, xScale = 0.4, yScale = 0.4},
		{id = 113, xScale = 0.48, yScale = 0.48},
		{id = 114, xScale = 0.4, yScale = 0.4},
		{id = 115, xScale = 0.48, yScale = 0.48},
		{id = 116, xScale = 0.4, yScale = 0.4},

		{id = 140, xScale = 0.32, yScale = 0.32, xInPercentOfScreen = 0.897, y = 28, fromH = true, realH = true},

		{id = 141, xScale = 0.4, yScale = 0.4},
		{id = 142, xScale = 0.32, yScale = 0.32},
		{id = 143, xScale = 0.4, yScale = 0.4},
		{id = 144, xScale = 0.32, yScale = 0.32},
		{id = 145, xScale = 0.4, yScale = 0.4},
		{id = 146, xScale = 0.32, yScale = 0.32},

		{id = 149, xScale = 0.32, yScale = 0.32, xInPercentOfScreen = 0.897, y = 28, fromH = true, realH = true},

		{id = 154, xScale = 0.4, yScale = 0.4},
		{id = 155, xScale = 0.32, yScale = 0.32},
		{id = 156, xScale = 0.4, yScale = 0.4},
		{id = 157, xScale = 0.32, yScale = 0.32},
		{id = 158, xScale = 0.4, yScale = 0.4},
		{id = 159, xScale = 0.32, yScale = 0.32},

		{id = 162, xInPercentOfScreen = 0.479, y = 45, fromH = true, realH = true, xScale = 0.3, yScale = 0.3},

		{id = 175, y = 54, fromH = true, realH = true, yScale = 0.4},
		{id = 176, y = 54, fromH = true, realH = true, yScale = 0.4},

		{id = 186, xScale = 0.4, yScale = 0.4},
		{id = 187, xScale = 0.32, yScale = 0.32},
		{id = 188, xScale = 0.4, yScale = 0.4},
		{id = 189, xScale = 0.32, yScale = 0.32},
		{id = 190, xScale = 0.4, yScale = 0.4},
		{id = 191, xScale = 0.32, yScale = 0.32},

		{id = 194, xInPercentOfScreen = 0.3515, y = 95, fromH = true, realH = true, xScale = 0.3, yScale = 0.3},

		{id = 205, y = 60, fromH = true, realH = true, yScale = 0.8},
	}

	replace(replaceObjectsList, 'animationSteps')
end

return returnList