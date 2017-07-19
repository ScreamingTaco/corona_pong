--composer.gotoScene( sceneName [, options] )

local composer = require( "composer" )
local physics = require("physics")
local widget = require("widget")
local scene = composer.newScene()

local backBtn

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"-- -------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
   
function backBtnRelease()
    composer.gotoScene("scenes.menu", fade, 500)
end
    
-- create()
function scene:create( event )

    local sceneGroup = self.view
-- Code here runs when the scene is first created but has not yet appeared on screen
    background = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor(0, 0, 0) -- black

    local screenTop = display.newRect(display.contentCenterX, display.screenOriginY, 450, 1)
    screenTop:setFillColor(0, 0, 0)
    local screenBottom = display.newRect(display.contentCenterX, display.contentHeight, 450, 1)
    screenBottom:setFillColor(0, 0, 0)


    --the different colors are to make debugging easier, will change for release
    platform = display.newRect(display.contentCenterX + (display.contentWidth / 2), display.contentCenterY, 10, display.contentHeight)
    platform:setFillColor( 1, 1, 1)
    platform.score = 0
    player = display.newRect(display.contentCenterX - (display.contentWidth / 2), display.contentCenterY, 10, display.contentHeight / 5)
    player:setFillColor( 1, 1, 1)
    player.score = 0
    player.speed = 2--bigger numbers mean slower movement
    ball = display.newCircle(display.contentCenterX, display.contentCenterY, 10)
    ball:setFillColor( 1, 1, 1)

    physics.start()
    physics.pause()
    
    physics.addBody(screenTop, "static", {bounce = 0})
    physics.addBody(screenBottom, "static", {bounce = 0})
    physics.addBody(platform, "static", {bounce = 0})
    physics.addBody(player, "static", {bounce = 0})
    physics.addBody(ball, "dynamic", { radius = ball.radius, bounce=1.05})
    ball.gravityScale = 0 --removes the effect of gravity from the ball

	backBtn = widget.newButton{
		label="back",
		labelColor = { default={255}, over={128} },
		width=154, height=40,
		onRelease = backBtnRelease	-- event listener function
	}
	backBtn.x = display.contentCenterX
	backBtn.y = display.contentCenterY / 10

    sceneGroup:insert(background)
    sceneGroup:insert(player)
    sceneGroup:insert(platform)
    sceneGroup:insert(ball)
    sceneGroup:insert(backBtn)
end

local function reset()
    ball.x = display.contentCenterX
    ball.y = display.contentCenterY
    timer.performWithDelay(3000, ball:setLinearVelocity(350, -math.random(20, 75)))
    player.y = display.contentCenterY
    platform.x = display.contentCenterX + (display.contentWidth / 2)
    platform.y = display.contentCenterY
end

local function TouchListener( event )
    if ( event.phase == "began" ) then --TODO check that player.bottom and player.top dont go past screenBottom
        player.transition_time = math.abs((event.y - player.y) / player.speed)
        transition.to(player, {y = event.y, speed = player.transition_time})
    elseif ( event.phase == "moved") then
        player.transition_time = math.abs((event.y - player.y) / player.speed)
        transition.to(player, {y = event.y, speed = player.transition_time})
    end
end

local function Update (event)
    if ball.x < player.x - 30 then
        reset()
    end
end

-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
-- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
-- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "enterFrame", Update )--stuff to do every update interval
        background:addEventListener( "touch", TouchListener )
        reset()
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)
        physics.stop()
        Runtime:removeEventListener("enterFrame", Update)
        
    elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen

    end
end


    --  destroy()
function scene:destroy( event )

    local sceneGroup = self.view
-- Code here runs prior to the removal of scene's view

    package.loaded[physics] = nil
    physics = nil
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

        
return scene
