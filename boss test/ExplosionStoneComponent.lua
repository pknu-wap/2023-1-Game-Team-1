--Properties--

number Damage = 500
number explosionTimer = 1.5
Vector2 spriteSize = Vector2(0,0)
boolean attackOn = false


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.Entity.SpriteRendererComponent.SortingLayer = "Default"
	
	self.Entity.SpriteRendererComponent.SpriteRUID = "2ddee5dbee6b480bacc16932ac0bcb58"
}

[Default]
void BoomReady()
{
	self.Entity.SpriteRendererComponent.SpriteRUID = "8a8c9a735036433c9f63d4ff4328b7d9"
	self.attackOn = true
	
	local scale = self.Entity.TransformComponent.Scale
	scale = Vector3(3, 3, 1)
	self.Entity.TransformComponent.Scale = scale
	
	local pos = self.Entity.TransformComponent.Position
	pos.y = 0.4701535
	self.Entity.TransformComponent.Position = pos
	
	if isvalid(scale) then
		--log("스케일 잘 들어옴")
	end
	
	local attack = function()
	local attackSize = Vector2(scale.x + 1.9, scale.y + 1.9)
	local attackOffset = Vector2(0, 0)
			
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(attack, 0.9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return self.Damage
}

[Server]
void Destroy()
{
	self.Entity:Destroy()
}


--Events--

[Default]
HandleSpriteAnimPlayerEndFrameEvent(SpriteAnimPlayerEndFrameEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ClimbableSpriteRendererComponent
	-- Space: Client
	---------------------------------------------------------
	-- Sender: SpriteRendererComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local FrameIndex = event.FrameIndex
	local ReversePlaying = event.ReversePlaying
	local TotalFrameCount = event.TotalFrameCount
	local AnimPlayer = event.AnimPlayer
	---------------------------------------------------------
	--log("붐 끝")
	if self.attackOn then
		--log("붐 끝222")
		self:Destroy()
	else
		self:BoomReady()
	end
}

