enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}

function checkCollisions(enemies, bullets)
	for i,e in pairs(enemies) do 
		for _,b in pairs(bullets) do
			if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
				table.remove(enemies, i)
			end
		end
	end
end 

function love.load()
	player = {}
	player.x = 0
	player.y = 550
	player.width = 80
	player.height = 20
	player.speed = 5
	player.bullets = {}
	player.cooldown = 20
	player.fire = function()
		if player.cooldown <= 0 then
			player.cooldown = 30
			bullet = {}
			bullet.width = 10
			bullet.height = 10
			bullet.x = player.x + player.width / 2 - bullet.width / 2
			bullet.y = player.y
			table.insert(player.bullets, bullet)
		end
	end
	enemies_controller:spawnEnemy(0, 0)
	enemies_controller:spawnEnemy(700, 0)
	love.graphics.setDefaultFilter('nearest', 'nearest')
end

function enemies_controller:spawnEnemy(x, y)
	enemy = {}
	enemy.x = x
	enemy.y = y 
	enemy.height = 20
	enemy.width = 40
	enemy.bullets = {}
	enemy.cooldown = 200
	enemy.speed = 0
	table.insert(self.enemies, enemy)
end


function enemy:fire()
	if enemy.cooldown <= 0 then
		enemy.cooldown = 30
		bullet = {}
		bullet.width = 10
		bullet.height = 10
		bullet.x = self.x + player.width / 2 - self.bullet.size / 2
		bullet.y = self.y
		table.insert(self.bullets, bullet)
	end
end


function love.update(dt)
	player.cooldown = player.cooldown - 1
	if love.keyboard.isDown("right") then 
		player.x = player.x + player.speed
	elseif love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end	

	if love.keyboard.isDown("space") then 
			player.fire()
	end

	for _,e in pairs(enemies_controller.enemies) do
		e.y = e.y + 1
	end

	for i,b in ipairs(player.bullets) do
		if b.y < -10 then
			table.remove(player.bullets, i)
		end
		b.y = b.y - 5
	end
	checkCollisions(enemies_controller.enemies, player.bullets)
end




function love.draw()
	-- Player
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)

	-- Enemies
	love.graphics.setColor(255, 0, 0)
	for _,e in pairs(enemies_controller.enemies) do
		love.graphics.rectangle("fill", e.x, e.y, enemy.width, enemy.height)
	end

	-- Bullets
	love.graphics.setColor(255, 255, 255)
	for _,b in pairs(player.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, bullet.width, bullet.height)
	end
end