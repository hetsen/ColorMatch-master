--[[  
 ____   ___   ____ ___    _    _       __  __  ___  ____  _   _ _     _____ 
/ ___| / _ \ / ___|_ _|  / \  | |     |  \/  |/ _ \|  _ \| | | | |   | ____|
\___ \| | | | |    | |  / _ \ | |     | |\/| | | | | | | | | | | |   |  _|  
 ___) | |_| | |___ | | / ___ \| |___  | |  | | |_| | |_| | |_| | |___| |___ 
|____/ \___/ \____|___/_/   \_\_____| |_|  |_|\___/|____/ \___/|_____|_____|

--------------------------------------------------------------------------------------------------

// 
// Copyright (c) 2013 All Right Reserved, Mikael Isaksson
//
//
// Commercial use with this code is NOT allowed unless author is credited.
// Changes in the code is allowed and MUST be mentioned somewhere in the product.
// Claiming this code as your own is NOT allowed.
// Redistribution of this code is NOT allowed.
// 
// Author: 	Mikael Isaksson
// Email:	mikael.isaksson1@gmail.com
// Date: 	2013-07-15
// 
// Please contact me if you are using this code, it would be fun to see what kind of app you ar releasing.
// :)

,--.  ,--. ,-----. ,--.   ,--.    ,--------. ,-----.  
|  '--'  |'  .-.  '|  |   |  |    '--.  .--''  .-.  ' 
|  .--.  ||  | |  ||  |.'.|  |       |  |   |  | |  | 
|  |  |  |'  '-'  '|   ,'.   |       |  |   '  '-'  ' 
`--'  `--' `-----' '--'   '--'       `--'    `-----'  

--------------------------------------------------------------------------------------------------

First of all!

local soical = require 'socialModule'

--=--facebook=--

In build settings:



settings = {
    iphone = {
        plist = {

            UIApplicationExitsOnSuspend = false,

            --facebookAppID = "123123123123123123",

            CFBundleURLTypes = {
                {
                CFBundleURLSchemes = { "fb123123123123123", }
                }
            }
        }
    }
} 





social.sendfbMessage(newMessage) -- Posts a message

example: social.sendfbMessage("This game is cool!")

social.sendfbAppCapture(imageName,message) -- Posts a screen capture of the GROUP you have selected.

example: social.sendfbAppCapture("filename.jpg","Look at my app! LOOK AT IT!")

social.sendfbPostImage(folder,imageName,message) -- Posts a picture

example: social.sendfbPostImage(system.ResourceDirectory,"filename.jpg","I wanna post this pic, cuz I can!")

--=TWITTER=--

social.sendTweet(tweetMessage) -- Sends a tweet

example: social.sendTweet("Hello, tweeters!")

social.sendTweetAppCapture(image,tweetMessage) -- Sends a tweet along with a screen capture of the GROUP you have selected.

example: social.sendTweetAppCapture("filename.jpg","This will be tweeted!")

social.sendTweetImage(folder,image,tweetMessage) -- Sends a tweet along with a picture

example: social.sendTweetImage(system.ResourceDirectory,"filename.jpg","Look at this cool picture!")

--=SMS=--

social.sendSMS(smsTo,smsMessage) -- Sends an sms

example: social.sendSMS("Check out my app!!!")


--=MAIL=--

social.sendMailAppCapture(image,mailTo,mailSubject,mailMessage) -- Sends an email along with a screen capture of the GROUP you have selected.

example: social.sendMailAppCapture("filename.jpg","test@test.com","Check this app out!","So this is my app! // Mike")

social.sendMailImage(folder,image,mailTo,mailSubject,mailMessage) -- Sends an email along with an picture.

example: social.sendMailImage(system.ResourceDirectory,"filename.jpg","test@test.com","Check out this pic!","This is a cool pic huh? //Mike")

social.sendMail(mailTo,mailSubject,mailMessage) -- Sends an email

example: social.sendMail("test@test.com","This is my subject","This is my message. // Mike")


--]]
-- --facebook --


local social = {}

local fbAppID = "352378071558753"

--local facebook  = require "--facebook"
local tweetOptions
local screenCap

function social.sendfbMessage(newMessage)
		
	local post = newMessage

	function social.postTheMessage()
		--facebook.request( "me/feed", "POST", {message = post} )
	end


	function social.loginListener( event )
	    if event.isError then
	        native.showAlert( "ERROR", event.response, { "OK" } )
	    else
	        if event.type == "session" and event.phase == "login" then
	            social.postTheMessage()
	        elseif event.type == "request" then
				native.showAlert( "Success", "Your message has been sent!", { "OK" } )
	        end
	    end
	end
		--facebook.login( fbAppID, social.loginListener, { "publish_stream" } )

end

function social.sendfbAppCapture(imageName,message)
	local Image = imageName
	local messageParam = message
	 
	function social.postTheImage(messageParam)

		
		local attachment = {
		        message = messageParam,
		        source = {
		                baseDir	 = system.DocumentsDirectory, 
		                filename = Image,
		                type	 = "image"
		        },
		}
	function social.request()
		--facebook.request( "me/photos", "POST", attachment )
		fbTimer2 = nil
	end

		
		local fbTimer1 = timer.performWithDelay(100,function()
			screenCap = display.captureScreen( false )
			display.save(screenCap, Image, system.DocumentsDirectory)
			fbTimer3 = timer.performWithDelay(105,function()
				fbTimer3 = nil
				display.remove(screenCap)
			end)
			fbTimer1 = nil
			local fbTimer2 = timer.performWithDelay(200,social.request)

		end)  
	end
	 

	function social.loginListener( event )
	    if event.isError then
	        native.showAlert( "ERROR", event.response, { "OK" } )
	    else
	        if event.type == "session" and event.phase == "login" then
	            social.postTheImage(messageParam)
	        elseif event.type == "request" then
				native.showAlert( "Success", "Your request for help has been sent to --facebook!", { "OK" } )
	        end
	    end
	end
		--facebook.login( fbAppID, social.loginListener, { "publish_stream" } )

end

function social.sendfbPostImage(folder,imageName,message)
	local Image 		= imageName
	local messageParam 	= message
	local newFolder 	= folder
	 
	function social.postNewImage(messageParam,folder,Image)
		
		local attachment = {
		        message = messageParam,
		        source = {
		                baseDir	 = folder, 
		                filename = Image,
		                type 	 = "image"
		        },
		}
			--facebook.request( "me/photos", "POST", attachment )
		
	end
	 

	function social.loginListener( event )
	    if event.isError then
	        native.showAlert( "ERROR", event.response, { "OK" } )
	    else
	        if event.type == "session" and event.phase == "login" then
	            social.postNewImage(messageParam,folder,Image)
	            
	        elseif event.type == "request" then
				native.showAlert( "Success", "Your request for help has been sent to --facebook!", { "OK" } )
	        end
	    end
	end
		--facebook.login( fbAppID, social.loginListener, { "publish_stream" } )

end

-- TWITTER --
function social.sendTweet(tweetMessage)
	
	function social.tweetListener(event)
	   if ( event.action == "cancelled" ) then
	      print( "Cancelled" )
	   else
	      print( "Tweet has been sent!" )
	   end
	end
	
	local tweetOptions = {
	   message 	= tweetMessage,
	   listener = social.tweetListener,
	}
	native.showPopup( "twitter", tweetOptions )

end

function social.sendTweetAppCapture(image,tweetMessage)
local newTweet = tweetMessage
local newImage = image

	function social.tweetListener(event)
	   if ( event.action == "cancelled" ) then
	      print( "Cancelled" )
	   else
	      print( "Tweet has been sent!" )
	   end
	end
	screenCap = display.captureScreen( false )
	display.save(screenCap, image, system.DocumentsDirectory)
	tweetTimer = timer.performWithDelay(100,function()
		tweetTimer = nil
		display.remove(screenCap)
	end)
	
	local tweetOptions = {
	   message 	= newTweet,
	   listener = social.tweetListener,
	   image = {
	      baseDir 	= system.DocumentsDirectory,
	      filename 	= newImage
	      }
	}
	
	function social.goPopUpNative(tweetMessage,image)
		native.showPopup( "twitter", tweetOptions )
		nativeTimer = nil
	end
	
	local nativeTimer = timer.performWithDelay(100,social.goPopUpNative)

end

function social.sendTweetImage(folder,image,tweetMessage)
local newTweet 	= tweetMessage
local newImage 	= image
local newFolder = folder

	function social.tweetListener(event)
	   if ( event.action == "cancelled" ) then
	      print( "Cancelled" )
	   else
	      print( "Tweet has been sent!" )
	   end
	end
	
	local tweetOptions = {
	   message 	= newTweet,
	   listener = social.tweetListener,
	   image = {
	      baseDir  = newFolder,
	      filename = newImage
	      }
	}
	

	native.showPopup( "twitter", tweetOptions )

end

--------------------------------------------------------------------------------------------------

function social.sendSMS(smsTo,smsMessage)
	local smsOptions = {
		to 	 = smsTo,
		body = smsMessage
	}
	native.showPopup("sms", smsOptions)
end

--------------------------------------------------------------------------------------------------

function social.sendMailAppCapture(image,mailTo,mailSubject,mailMessage)
	local newMail 	 = mailMessage
	local newTo		 = mailTo
	local newSubject = mailSubject
	local newImage 	 = image

	screenCap = display.captureScreen( false )
	display.save(screenCap, image, system.DocumentsDirectory)
	local mailTimer = timer.performWithDelay(100,function()
		mailTimer = nil
		display.remove(screenCap)
	end)

	local mailOptions = {
	to = newTo or "JohnDoe@Hello.com",
	subject = newSubject or"My subject hurts :(",
	body = newMail or "IMMA FIRIN MAH LAZAH!",

	attachment = { 
		baseDir	 = system.DocumentsDirectory, 
		filename = image,
		type	 = "image" },
	}
	function social.goMailNative(mailTo,subjectTo,mailMessage)
		native.showPopup("mail", mailOptions)
	end	

	local nativeTimer = timer.performWithDelay(100,social.goMailNative)
end

function social.sendMailImage(folder,image,mailTo,mailSubject,mailMessage)
	local newMail 	 = mailMessage
	local newTo		 = mailTo
	local newSubject = mailSubject
	local newImage 	 = image
	local newFolder  = folder



	local mailOptions = {
	to 		= newTo or "JohnDoe@Hello.com",
	subject = newSubject or"My subject hurts :(",
	body 	= newMail or "IMMA FIRIN MAH LAZAH!",

	attachment = { 
		baseDir	 = newFolder, 
		filename = newImage,
		type	 = "image" 
		},
	}

	native.showPopup("mail", mailOptions)
end

function social.sendMail(mailTo,mailSubject,mailMessage)
	local newMail 	 = mailMessage
	local newTo		 = mailTo
	local newSubject = mailSubject

	local mailOptions = {
	to 		= newTo or "JohnDoe@Hello.com",
	subject = newSubject or"My subject hurts :(",
	body 	= newMail or "IMMA FIRIN MAH LAZAH!",
	}
	
	native.showPopup("mail", mailOptions)
end


return social
