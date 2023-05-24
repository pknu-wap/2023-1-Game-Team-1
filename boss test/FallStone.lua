--Properties--

Vector2 attackSize = Vector2(2.8,14)
Vector2 attackOffset = Vector2(0,0)
number delayTime = 0.03
Component spriteRendererComponent
number fallSpeed = 3
Component transformComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.spriteRendererComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
}

[Default]
void AttackNear()
{
	self:Attack(self.attackSize, self.attackOffset, nil, CollisionGroups.Player)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 100
}

[Server Only]
void Boom()
{
	self.spriteRendererComponent.SpriteRUID = "01891ebdfaa14647bc3e6e0982ea9bd2"
	self.transformComponent.Scale = Vector3.one * 2
	self:AttackNear()
	
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 0.45)
}

[Server Only]
void OnUpdate(number delta)
{
	local yDelta = self.fallSpeed * delta * -1
	
	self.transformComponent:Translate(0, yDelta)
}


--Events--

[Default]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TriggerComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	---------------------------------------------------------
	self:Boom()
	self.fallSpeed = 0
}

