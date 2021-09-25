local tenflib = require("tenfLib")
local productBuyResult = require 'productBuyResult'

local proxy = {}
local isSimulator = "simulator" == system.getInfo("environment")

local validProducts, invalidProducts = {}, {}
local returnProductsCallback

function showStoreNotAvailableWarning()
	if isSimulator then
		native.showAlert("Notice", "In-app purchases is not supported by the Corona Simulator.", { "OK" } )
	else
		native.showAlert("Notice", "In-app purchases is not supported on this device.", { "OK" } )
	end
end

local function buyIt(productId)
	--local productId = validProducts[e.target.index].productIdentifier

	if store.isActive == false then
		showStoreNotAvailableWarning()
	elseif store.canMakePurchases == false then
		native.showAlert("Store purchases are not available, please try again later", {"OK"})
	elseif productId then
		print("Ka-ching! Purchasing " .. tostring(productId))
		
		store.purchase( {productId} )
	end
end

function proxy.onBuy(product)
	-- local function buyAnswer(e2)
	-- 	if e2.index == 1 then
	buyIt(product.productIdentifier)
	-- 	end
	-- end

	-- native.showAlert(('Buy ' .. product.title .. '?'), product.description, {'Buy', 'Cancel'}, buyAnswer)
end

function proxy.restoreIt()
	if store.isActive then
		store.restore()
	else
		showStoreNotAvailableWarning()
	end
end

-- function proxy.addProductFields()
-- 	if validProducts and #validProducts > 0 then
-- 		for i=1, #validProducts do
-- 			local myButton = display.newGroup()

-- 			local bg = display.newRoundedRect(myButton, 0, 0, 80, 200)
-- 			bg.x, bg.y = 0, 0
-- 			bg:setFillColor(i*64 + 64, 128, 128)

-- 			local fg = display.newText(myButton, validProducts[i].name, 0, 0, nil, 18)
-- 			fg.x, fg.y = 0, 0
-- 			fg:setTextColor(0)

-- 			myButton.description = validProducts[i].description
-- 			myButton.index = i
-- 			myButton.name = validProducts[i].name
-- 			myButton.x = _W*0.5
-- 			myButton.y = i*myButton.height*1.1 - #validProducts*0.5 - myButton.height*0.55
-- 			myButton:addEventListener('tap', onBuy)
-- 		end


-- 		local myRestoreButton = display.newGroup()

-- 		local bg = display.newRoundedRect(myRestoreButton, 0, 0, 80, 200)
-- 		bg.x, bg.y = 0, 0

-- 		myRestoreButton.x = _W*0.5
-- 		myRestoreButton.y = i*myRestoreButton.height*1.1 - #validProducts*0.5 - myRestoreButton.height*0.55
-- 		myRestoreButton:addEventListener('tap', restoreIt)
-- 	end
-- end

function loadProductsCallback( event )
	print("Running loadProductsCallback...")
	validProducts = event.products
	invalidProducts = event.invalidProducts
	returnProductsCallback(validProducts)
end

function proxy.returnProductsTo(returnCallback)
	returnProductsCallback = returnCallback
end

function proxy.updateIAPSettings(transaction, purchasedNow)
	local productId = transaction.productIdentifier

	local loadedPurchases = tenflib.jsonLoad('purchases') or {}

	if purchasedNow then
		loadedPurchases[transaction.productIdentifier] = true

		tenflib.jsonSave('purchases', loadedPurchases)
	end

	local loadedIAPSettings = tenflib.jsonLoad('IAPSettings') or {worldsUnlocked = {['Find the Cure'] = true}, adsEnabled = true}

	if productBuyResult and productBuyResult[productId] then
		if productBuyResult[productId].worlds then
			for k,v in pairs(productBuyResult[productId].worlds) do
				loadedIAPSettings.worldsUnlocked[k] = true
			end
		end

		if productBuyResult[productId].noAds then
			loadedIAPSettings.adsEnabled = false
		end

		_G.adsEnabled = loadedIAPSettings.adsEnabled or true
		_G.worldsUnlocked = loadedIAPSettings.worldsUnlocked
	end

	tenflib.jsonSave('IAPSettings', loadedIAPSettings)
end

local function onPurchased(transaction)
	proxy.updateIAPSettings(transaction, true)

	return {
		"Success!",
		"Transaction successful!"
	}
end

local function onRestored(transaction)
	proxy.updateIAPSettings(transaction)
	-- Om jag har förstått restored korrekt så ska den göra samma sak som purchased, fast utan kostnad.

	return {
		"Restored!",
		"Restored transaction:" ..
		"\n   Original ID: " ..
		tostring(transaction.originalTransactionIdentifier) ..
		"\n   Original date: " ..
		tostring(transaction.originalDate)
	}
end

local function onRefunded(transaction)

	return {
		"Refunded!",
		"A previously purchased product was refunded by the store."
	}
end

local function onCancelled(transaction)

	return {
		"Cancelled!",
		"Transaction cancelled by user."
	}
end

local function onFailed(transaction)
	return {
		"Failed!",
		"Transaction failed:\n" ..
		tostring(transaction.errorType) ..
		"\n" ..
		tostring(transaction.errorString)
	}
end

local function onError(transaction)
	return {"Error!", "Unknown event"}
end

function proxy.transactionCallback( event )
	local infoString

	if event.transaction.state == "purchased" then
		infoString = onPurchased(event.transaction)
	elseif  event.transaction.state == "restored" then
		infoString = onRestored(event.transaction)
	elseif  event.transaction.state == "refunded" then
		infoString = onRefunded(event.transaction)
	elseif event.transaction.state == "cancelled" then
		infoString = onCancelled(event.transaction)
	elseif event.transaction.state == "failed" then        
		infoString = onFailed(event.transaction)
	else
		infoString = onError(event.transaction)
	end

	store.finishTransaction( event.transaction )

	native.showAlert(infoString[1], infoString[2], {'Ok'})
end

function proxy.setupMyStore()
	collectgarbage()

	if store.isActive or isSimulator then
		if store.canLoadProducts then
			store.loadProducts(appleProductList, loadProductsCallback)
		end
	end
end

return proxy