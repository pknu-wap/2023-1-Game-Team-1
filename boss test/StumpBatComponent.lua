--Properties--

number speed = 3
number duration = 3
number damage = 500
Component transformComponent
boolean ToLeft = true
number NewValue1 = 0
Component bossTransform


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.transformComponent = self.Entity.TransformComponent
	self.bossTransform = _EntityService:GetEntityByTag("Boss").TransformComponent
	_TimerService:SetTimerOnce(function() self:BatAttack() end, self.duration)
	
	if self.bossTransform.Scale.x < 0 then
		self.ToLeft = false
		self.transformComponent.Scale.x = -1
	end
}

[Server Only]
void OnUpdate(number delta)
{
	local xDelta = self.speed * delta
	
	if self.ToLeft then
	    xDelta = xDelta * -1
	end 
	
	self.Entity.TransformComponent:Translate(xDelta, 0)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return self.damage
}

[Default]
void BatAttack()
{
	local triggerComponent = self.Entity.TriggerComponent
	local boomPos = Vector3(self.transformComponent.Position.x + (0.5 * (self.ToLeft == true and -1 or 1)), self.transformComponent.Position.y, self.transformComponent.Position.z )
	_EffectService:PlayEffect("005d606301de46798afdc5b8f2283352", self.Entity, boomPos, 0, Vector3.one, false)
	local shape = BoxShape(Vector2(self.transformComponent.Position.x, self.transformComponent.Position.y), Vector2(triggerComponent.BoxSize.x+1, triggerComponent.BoxSize.y+1), 0)
	
	self:AttackFast(shape, nil, CollisionGroups.Player)	
	
	self.Entity:Destroy()
}


--Events--

[Server Only]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TriggerComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	---------------------------------------------------------
	if isvalid(TriggerBodyEntity.PlayerComponent) then
		self:BatAttack()
	end
	
}

