-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local infiniteBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to ClassicMode.lua scene
	composer.gotoScene( "scenes.classicMode", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onInfiniteBtnRelease()
    composer.gotoScene("scenes.infiniteMode", fade, 500)
    return true
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

    
	-- create/position logo/title image on upper-half of the screen
	--idea: make the title a button that gives a fact about pong on every tap
    local titleLogo = display.newImageRect( "images/logo.png", display.contentCenterX * 1.5, display.contentCenterY * 1.5)
	titleLogo.x = display.contentCenterX
	titleLogo.y = display.contentCenterY / 3
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Classic Mode",
		labelColor = { default={255}, over={128} },
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = (display.contentHeight / 2)

    
    infiniteBtn = widget.newButton{
		label="Infinite Mode",
		labelColor = { default={255}, over={128} },
		width= display.contentHeight / 3, height = display.contentWidth / 12,
		onRelease = onInfiniteBtnRelease-- event listener function
	}
        
    infiniteBtn.x = display.contentCenterX
    infiniteBtn.y = display.contentHeight - (display.contentHeight / 4)
    
	-- all display objects must be inserted into group
	--sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
    sceneGroup:insert( infiniteBtn)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
    if infiniteBtn then
        infiniteBtn:removeSelf()
        infiniteBtn = nil
    end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-----------------------------------------------------------------------------------------
return scene
