------------------------------------------------------------------------------------------
--
-- Pagination av 10FINGERS AB
-- pagination.lua
--
-- Påbörjad: 2012-11-20 av Marcus Thunström
-- Uppdaterad: 2012-11-28 av Marcus Thunström
--
--[[--------------------------------------------------------------------------------------



API-beskrivning:

	pagination = require('modules.pagination')( [parent,] left, top, width, height, margin, rows, cols, [vertical [, continousScrolling] ] )
		- parent: vilken grupp paginationobjektet ska läggas in i. (Default: nil)
		- left: vänstermarginal för paginationobjektet.
		- top: toppmarginal för paginationobjektet.
		- width: paginationobjektets bredd.
		- height: paginationobjektets höjd.
		- margin: distans mellan celler och paginationobjektets kant.
		- rows: antal rader för cellerna.
		- cols: antal kolumner för cellerna.
		- vertical: om scrollning huvudsakligen ska ske vertikalt eller horisontellt. (Påverkar pagedisplayen.) (Default: false)
		- continousScrolling: . (Default: false)

	pagination:attachPageDisplay( progressDisplay, progressDisplayHeight ) :: Sätter fast en sidvisare på paginationobjektet.
		- progressDisplay: objekt skapad med progressDisplay-modulen.
		- progressDisplayHeight: höjden på det avsatta området för för progressdisplayen i paginationobjektet.

	pagination:setCellContent( content, pageX, pageY, row, col ) :: Lägger in innehåll i angiven cell.
		- content: det displayobject som ska in i cellen.
		- pageX: vilken sida på x-axeln.
		- pageY: vilken sida på y-axeln.
		- row: vilken rad.
		- col: vilken kolumn.



Event:

	press
		Avfyras när användaren trycker på innehållet i en cell.
		event.target är cellinnehållet som användaren tryckt på.
		event.pagination är paginationobjektet



Exempel på användande:

	local width, height = display.contentWidth, display.contentHeight

	-- Skapa paginationobjekt (som är en grupp)
	local pagination = require('modules.pagination')(0, 0, width, height, 80, 3, 4)

	-- Lägg in några knappar på första sidan
	for i = 1, 10 do
		local button = display.newGroup()
		tenfLib.setAttr(display.newRect(button, 0, 0, 180, 130), {x=0, y=0}, {fc={200,100,100,100}})
		tenfLib.setAttr(display.newText(button, 'hej'..i, 0, 0, nil, 40), {x=0, y=0})
		pagination:setCellContent(button, 1, 1, math.floor((i-1)/4+1), (i-1)%4+1)
		button:addEventListener('press', function(e)
			print(e.target[2].text)
			transition.to(e.target, {time=100, xScale=0.9, yScale=0.9})
			transition.to(e.target, {delay=100, time=100, xScale=1, yScale=1})
		end)
	end

	-- Lägg in ett par texter på sida två och tre
	pagination:setCellContent(tenfLib.setAttr(display.newText('--->', 0, 0, nil, 40), {x=0, y=0}), 2, 1, 2, 2)
	pagination:setCellContent(tenfLib.setAttr(display.newText('HEJ!', 0, 0, nil, 40), {x=0, y=0}), 3, 1, 1, 2)

	-- Lää in en sidvisare.
	pagination:attachPageDisplay(require('modules.progressDisplay')('bullets', 1, 1, {color={255,150,50}, width=width/2}), 100)



--]]--------------------------------------------------------------------------------------



local tenfLib       = require('modules.tenfLib')

local printObj      = tenfLib.printObj

local deadZoneR     = 20

local k             = {}

local methods       = {}







-- Funktioner
------------------------------------------------------------------------------------------



local getCell
local rearrangeAllCells, rearrangeCell
local scrollMovedHandler, scrollTapHandler



function getCell(pagination, pageX, pageY, row, col)
	local data = pagination[k]

	local pages = data.pages
	local page = select(2, tenfLib.indexWith(pages, nil, {pageX=pageX, pageY=pageY}))
	if not page then
		page = tenfLib.newGroup(data.pagesGroup)
		page.pageX, page.pageY = pageX, pageY
		page.x, page.y = (page.pageX-1)*data.width, (page.pageY-1)*data.height
		pages[#pages+1] = page
	end

	local cells = data.cells
	local cell = select(2, tenfLib.indexWith(cells, nil, {pageX=pageX, pageY=pageY, row=row, col=col}))
	if not cell then
		cell = tenfLib.newGroup(page)
		cell.pageX, cell.pageY, cell.row, cell.col = pageX, pageY, row, col
		cells[#cells+1] = cell
	end

	data.scroller:setPageAmountX(math.max(pageX, data.scroller:getPageAmountX()))
	data.scroller:setPageAmountY(math.max(pageY, data.scroller:getPageAmountY()))

	return cell
end



function rearrangeAllCells(pagination)
	for _, cell in ipairs(pagination[k].cells) do
		rearrangeCell(pagination, cell)
	end
end

function rearrangeCell(pagination, cell)
	local data = pagination[k]
	cell.x = data.margin+(cell.col-0.5)*(data.width-2*data.margin)/data.cols
	cell.y = data.margin+(cell.row-0.5)*(data.height-data.pageDisplayHeight-2*data.margin)/data.rows
end



function scrollMovedHandler(pagination, e)
	local data = pagination[k]
	data.pagesGroup.x, data.pagesGroup.y = data.width*(1-e.x), data.height*(1-e.y)
	if data.pageDisplay then data.pageDisplay:setProgress(data.vertical and e.y or e.x) end
end

function scrollTapHandler(pagination, e)
	local data = pagination[k]

	local scrollerBounds = data.scroller.contentBounds
	local x, y = scrollerBounds.xMin, scrollerBounds.yMin

	local pageX, pageY = math.floor(e.x), math.floor(e.y)
	local row = math.ceil((e.touchY-y-data.margin)/((data.height-2*data.margin-data.pageDisplayHeight)/data.rows))
	local col = math.ceil((e.touchX-x-data.margin)/((data.width-2*data.margin)/data.cols))

	local cell = select(2, tenfLib.indexWith(data.cells, nil, {pageX=pageX, pageY=pageY, row=row, col=col}))
	local cellContent = cell and cell[1]

	if cellContent then
		local b = cellContent.contentBounds
		if tenfLib.pointInRect(e.touchX, e.touchY, b.xMin, b.yMin, b.xMax-b.xMin, b.yMax-b.yMin) then
			cellContent:dispatchEvent{name='press', target=cellContent, pagination=pagination}
		end
	end

end







-- Metoder
------------------------------------------------------------------------------------------



-- -- setCellContent( pagination, content [, pageX, [ pageY ] [, row, col ] ] )
-- -- setCellContent( pagination, content )
-- -- setCellContent( pagination, content, pageX )
-- -- setCellContent( pagination, content, pageX, row, col )
-- -- setCellContent( pagination, content, pageX, pageY )
-- setCellContent( pagination, content, pageX, pageY, row, col ) -- använd denna!

function methods.setCellContent(pagination, content, pageX, pageY, row, col)
	-- if pageY and row and not col then pageY, row, col = nil, pageY, row end

	-- local data = pagination[k]
	-- local cells = data.cells

	local cell = getCell(pagination, pageX, pageY, row, col)
	tenfLib.removeAllChildren(cell)
	cell:insert(content)
	rearrangeCell(pagination, cell)

end



function methods.attachPageDisplay(pagination, progressDisplay, height)
	local data = pagination[k]

	data.pageDisplay, data.pageDisplayHeight = progressDisplay, height
	data.pageDisplay.x = data.width/2
	data.pageDisplay.y = data.height-data.pageDisplayHeight+data.pageDisplay:getMaxHeight()/2

	pagination:insert(data.pageDisplay)
	data.pageDisplay:setInterval(1, data.vertical and data.scroller:getPageAmountY() or data.scroller:getPageAmountX())

	rearrangeAllCells(pagination)

end







-- Constructor
------------------------------------------------------------------------------------------



return function(parent, left, top, width, height, margin, rows, cols, vertical, continousScrolling)

	if type(parent) ~= 'table' then
		parent, left,   top,  width, height, margin, rows,    cols, vertical, continousScrolling =
		nil,    parent, left, top,   width,  height, margin,  rows, cols,     vertical
	end



	-- Skapa paginationobjekt och förbered privat data

	local pagination = tenfLib.setAttr(tenfLib.newGroup(parent), methods)
	pagination.x, pagination.y = left, top

	local data = {
		cols = cols,  rows = rows,
		margin = margin,
		pageDisplay = nil,  pageDisplayHeight = 0,
		pages = {},  cells = {},
		pagesGroup = tenfLib.newGroup(pagination),
		scroller = require('modules.pageScroller')(pagination, 0, 0, width, height, width, height, 1, 1, continousScrolling),
		vertical = vertical,
		width = width,  height = height,
	}
	pagination[k] = data



	-- Event listeners

	data.scroller:addEventListener('scrollMoved', function(e) scrollMovedHandler(pagination, e) end)
	data.scroller:addEventListener('scrollTap', function(e) scrollTapHandler(pagination, e) end)



	return pagination

end



--[[             .,77$I88$?
        .?ZZ77Z:..,:ZZZOONZ$O8O$:
      ,ZOOMO8$,....:OOOOZODZ8OD8OZ.
  ,ZODO8$DDNI:,....,O8OZOODN$$OOO7
.OOO8888$NMN$+,....,Z8I+I$OD877OO.
?8OOO8ZOOMMN8O=,...,7OII$$?IMO$Z$
 $DOOZOONMN$ZZD?=,.,7$7$$DN?78O$.
  Z8OZ$ZMN$ZNN7O$+,.+8$I$NMD??                 ,:::::::,,,.
   $8OO.8DNMMNZZZ~,.,I$$$?Z$I=.             ,:,::::~~~:. .
    ZZ+ $ZODO888+::,,.,~$7$I?+            :~:,,,,:
        .ZOO88O8+~:,,,..,I?I+,          8NNDZ:,,
         7$ZOOZ?+:,~::,...+=:.        NMMMMNO.
          Z$$$+?+~I88D8O,..,        ZNMMMND.
          :?$O$++=8NN8N8:...       NMNNNN.
          :7I7+?+=?DNNND:,.,     :7NNNDI
          I7+7I?I++$ZOZ7=,:O=  .,,~888+
        .I77$$Z7?I$$$77I~:,.?DZ,,,,:8$
        7$$777Z$$7?I?++~:,,..=DD:,,.,?
       7$$$7I77$II++~:::,,...,8DD:,..,,
      ,7$$$7I777?I++~::,,.....=DDDZ,...,
      77$77$I$II??+=~~:,,,....,DDDDD,..,,
     .777III77$??+=:~~~:,,,,,.,=DD8D~...,,
     I777I??I$ZI?=~:~==:,,.,..,,8D$DZ....,
     III??++I7I?=~,,,~~~:,,....,IO=DZ....,.
     I?+==~=I??=~~,,.:~:,,....,,::+8:....,.
    .II?=++=I?+=~~::,,:::,,,..,,,,::,......
     +I?++=?=?+==~~:::::=:,,,,,,:,,,,.....,
      II+??????++~~==~=~~:,::,,::,,,.,...,,.
      7I?+?7?I??~:+=+++?==~,,,,::,..=:,,.,,,
     .I++?I++??++=~~~===+?~:,,,.    ,=~,...,
      I+===++++=+~====?=++~,,.,      :=:,.,,
      ?+~:~~= ,,~~~==~~=+~:,.,,       =~:,,.
      =+=~::~.       =~~+~,,,,,       ,~:,,.
       ++~:,,.       =~~+~::,,.       =~,,,
       +=~:,,,       =~~:,,,,,        ~:..,
       ~+~,,.,      .~:~:,....        =:.,,
       .+=,,..      ~:=:,,,,,         ~,..,
        ?+~,..,   .~::~:,,,,,         ~,..,
        +~:,.., ,:~:::~:,,..,         :,,.,
        +~,...,~~::~:~:,.....        .:,,,,
       .~,,....I7=+=:~:,,...         ::,=::,
      .,,,,,,.,     ,,,,....        ,+=,+:,~
     :=,:=,,~,,     :::::,,,.         ,::=~
    .?=,+:,,:,,    ~~~~~,,,,,
                   ..~7++=:~.
]]
