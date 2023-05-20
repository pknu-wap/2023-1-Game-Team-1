--Properties--

Vector2 MeteorAttackSize = Vector2(2.4, 2)
Vector2 attackOffset = Vector2(0,0)
number delayTime = 0.03
Component spriteRendererComponent
Component transformComponent
boolean canAttack = false
Vector2 FireAttackSize = Vector2(3.5,1.5)


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.spriteRendererComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
	
	_TimerService:SetTimerOnce(function() self:AttackNear() end, 1)
	_TimerService:SetTimerOnce(function() self:AttackFire() end, 1.53)
}

[Default]
void AttackNear()
{
	self:Attack(self.MeteorAttackSize, self.attackOffset, nil, CollisionGroups.Player)
}

[Default]
void AttackFire()
{
	self.spriteRendererComponent.SpriteRUID = "5596e3b3188b4cbb926e9dc28db223f5"
	self:Attack(self.FireAttackSize, self.attackOffset, nil, CollisionGroups.Player)
	self.MeteorAttackSize.x = self.FireAttackSize.x
	self.MeteorAttackSize.y = self.FireAttackSize.y
	self.transformComponent.Scale.x = 2
	self.transformComponent.Scale.y = 2
	self.canAttack = true
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 3.9)
}

[Default]
void FireAttack()
{
	self.spriteRendererComponent.SpriteRUID = "5596e3b3188b4cbb926e9dc28db223f5"
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 100
}

[Server Only]
void OnUpdate(number delta)
{
	if self.canAttack == true then
		self:AttackNear()
	end
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
	
}

