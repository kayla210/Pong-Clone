function love.load()
	initializeWindow()
	initializeObject()
	
	--Pause variable
	state = 'notstarted'
end

function love.update(dt)
	--If state is in play, continue
	if state ~= 'play' then
		return
	end
	
	objectMovement(dt)
	objectBoundaries()
	hitPaddle()
	missPaddle()
	increaseObjectSpeed()
end

function love.draw()
    	love.graphics.setColor(255,255,255)
    	love.graphics.rectangle('fill', paddle1_x, paddle1_y, paddle1_width, paddle1_height)
    	love.graphics.rectangle('fill', paddle2_x, paddle2_y, paddle2_width, paddle2_height)
    	love.graphics.rectangle('fill', ball_x, ball_y, ball_width, ball_height)
	
	if state == 'notstarted' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("Press ENTER to start Pong!", 0, (screen_height / 2) - 50, width, "center")
	end
	
	if state == 'pause' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("PAUSED", 0, (screen_height / 2) - 50, width, "center")
	end
	
	if state == 'paddle1win' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("PADDLE 1 WINS", 0, (screen_height / 2) - 50, width, "center")
	end
	
	if state == 'paddle2win' then
		stopScreen()
		width = love.graphics.getWidth()
		love.graphics.printf("PADDLE 2 WINS", 0, (screen_height / 2) - 50, width, "center")
	end
end

function love.keypressed(key)
	if key == 'return' then
		if state == 'notstarted' then
			state = 'play'
		end
	end
	
	if key == 'q' or key == 'escape' then
		love.event.quit()
	end
	
	if key == 'p' then
		if state == 'play' then
			state = 'pause'
		elseif state == 'pause' then
			state = 'play'
		end
	end

	if key == 'r' then
		if state == 'paddle1win' or state == 'paddle2win' then
			state = 'play'
		end
	end
end

--###### Initialize game window ######
function initializeWindow()
	love.graphics.setBackgroundColor(0,0,0)
	
	--Screen size
	screen_width = 500
	screen_height = 300
	
	--Window title and size
	love.window.setTitle('Pong')
    	love.window.setMode(screen_width, screen_height)
end

--###### Initialize game objects ######
function initializeObject()
	--Initialize paddle1
	paddle1_width = 20
	paddle1_height = 70
	paddle1_x = 0
	paddle1_y = (screen_height / 2) - (paddle1_height / 2)
	paddle1_speed = 400
	
	--Initialize paddle2
	paddle2_width = 20
	paddle2_height = 70
	paddle2_x = screen_width - paddle2_width
	paddle2_y = (screen_height / 2) - (paddle2_height / 2)
	paddle2_speed = 400
	
	--Initialize ball
	ball_height = 20
	ball_width = 20
	ball_x = (screen_width / 2) - (ball_width / 2) 
	ball_y = (screen_height / 2) - (ball_height / 2)
	ball_speed_x = -200
	ball_speed_y = 200
end

--###### Control object movement ######
function objectMovement(dt)
	--Movement for paddle1 (WASD)
	if love.keyboard.isDown('w') then
        paddle1_y = paddle1_y - (paddle1_speed * dt)
    	end
 	if love.keyboard.isDown('s') then
    		paddle1_y = paddle1_y + (paddle1_speed * dt)
    	end

	--Movement for paddle2 (Arrow keys)
    	if love.keyboard.isDown('up') then
        	paddle2_y = paddle2_y - (paddle2_speed * dt)
    	end
    	if love.keyboard.isDown('down') then
        	paddle2_y = paddle2_y + (paddle2_speed * dt)
    	end
    		
	--Move the ball according to speed and time
    	ball_x = ball_x + (ball_speed_x * dt)
    	ball_y = ball_y + (ball_speed_y * dt)
end

--###### Set object boundaries ######
function objectBoundaries()
	--Boundaries for paddle1
    	if paddle1_y < 0 then
        	paddle1_y = 0
    	elseif (paddle1_y + paddle1_height) > screen_height then
        	paddle1_y = screen_height - paddle1_height
 	end

	--Boundaries for paddle2
    	if paddle2_y < 0 then
        	paddle2_y = 0
    	elseif (paddle2_y + paddle2_height) > screen_height then
        	paddle2_y = screen_height - paddle2_height
    	end

	--Boundaries for ball
    	if ball_y < 0 then
        	ball_speed_y = math.abs(ball_speed_y)
    	elseif (ball_y + ball_height) > screen_height  then
        	ball_speed_y = -math.abs(ball_speed_y)
    	end
end

--###### Sets what occurs when the ball hits a paddle ######
function hitPaddle()
	--When ball hits paddle1
 	if ball_x <= paddle1_width and
    	(ball_y + ball_height) >= paddle1_y and
    	ball_y < (paddle1_y + paddle1_height)
    	then
        	ball_speed_x = math.abs(ball_speed_x)
    	end

	--When ball hits paddle2
    	if (ball_x + ball_width) >= (screen_width - paddle2_width) and
    	(ball_y + ball_height) >= paddle2_y and
    	ball_y < (paddle2_y + paddle2_height)
	then
        ball_speed_x = -math.abs(ball_speed_x)
    end
end

--###### Sets what occurs when either paddle misses the ball ######
function missPaddle()
	--If one of the paddles misses the ball, respawn ball
    	--[[if ball_x + ball_width < 0 or ball_x > screen_width then
        	ball_x = (screen_width / 2) - (ball_width / 2)
        	ball_y = (screen_height / 2) - (ball_height / 2)
        	ball_speed_x = -200
        	ball_speed_y = 200
    	end--]]
    
    	--If paddle1 misses the ball, paddle2 wins
    	if ball_x + ball_width < 0 then
		initializeObject()
    		state = 'paddle2win'
 	end
    
    	--If paddle2 misses the ball, paddle1 wins
	if ball_x > screen_width then
		initializeObject()
		state = 'paddle1win'
	end
end

--###### As the game goes on, increase object speed for increased difficulty ######
function increaseObjectSpeed()
	paddle1_speed = paddle1_speed + 0.1
	paddle2_speed = paddle2_speed + 0.1
	
	if ball_speed_x > 0 then
		ball_speed_x = ball_speed_x + 0.1
	elseif ball_speed_x < 0 then
		ball_speed_x = ball_speed_x - 0.1
	end
	
	if ball_speed_y > 0 then
		ball_speed_y = ball_speed_y + 0.1
	elseif ball_speed_y < 0 then
		ball_speed_y = ball_speed_y - 0.1
	end
end

--###### Screen to use when game is paused/stopped/not started yet ######
function stopScreen()
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle('fill', 0, 0, screen_width, screen_height)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(love.graphics.newFont(18))
end
