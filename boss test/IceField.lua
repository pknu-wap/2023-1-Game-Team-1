--Properties--

Vector2 attackSize = Vector2(0.5, 0.4)
Vector2 attackOffset = Vector2(0,0)
number delayTime = 0.03
Component spriteRendererComponent
Component transformComponent
boolean canAttack = false


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.spriteRendererComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
	
	_TimerService:SetTimerOnce(function() self.canAttack = true end, 1.95)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 2.77)
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

