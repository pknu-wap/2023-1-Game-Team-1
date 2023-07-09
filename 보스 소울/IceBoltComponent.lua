--Properties--

number speed = 5
number duration = 1.5
number Damage = 500
Component transformComponent
boolean ToLeft = true
number NewValue1 = 0
Component bossTransform


--Methods--

[Server Only]
void OnBeginPlay()
{
	local bossEntity = _EntityService:GetEntityByTag("Boss")
	
	self.transformComponent = self.Entity.TransformComponent
	self.bossTransform = bossEntity.TransformComponent
	
	if isvalid(bossEntity) then
		if bossEntity.Boss.BossLevel == 1 then
			self.Damage = 500
		elseif bossEntity.Boss.BossLevel == 2 then
			self.Damage = 2500
		elseif bossEntity.Boss.BossLevel == 3 then
			self.Damage = 8000
		end
	else 
		log("보스 엔티티를 찾을 수 없습니다!")
	end
	
	_TimerService:SetTimerOnce(function() self:IceBolt() end, self.duration)
	
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
	
	return self.Damage
}

[Default]
void IceBolt()
{
	local triggerComponent = self.Entity.TriggerComponent
	local boomPos = Vector3(self.transformComponent.Position.x, self.transformComponent.Position.y -0.5, self.transformComponent.Position.z )
	local boomScale = Vector3.one
	if self.bossTransform.Scale.x < 0 then
		boomScale.x = -1
	end
	_SoundService:PlaySound("1e8eea01af384f29bdea60555e44bd55", 1)
	_EffectService:PlayEffect("33ac4bcaebbb468d93e39acd4edf9869", self.Entity, boomPos, 0, boomScale, false)
	local shape = BoxShape(Vector2(self.transformComponent.Position.x, self.transformComponent.Position.y), Vector2(3.2, 1.5), 0)
	
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
		self:IceBolt()
	end
	
}

