--Properties--

Vector2 attackSize = Vector2(0.5, 0.4)
Vector2 attackOffset = Vector2(0,0)
number delayTime = 0.03
Component spriteRendererComponent
Component transformComponent
boolean canAttack = false
number Damage = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.spriteRendererComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
	
	local bossEntity = _EntityService:GetEntityByTag("Boss")
	
	if isvalid(bossEntity) then
		if bossEntity.Boss.BossLevel == 1 then
			self.Damage = 100
		elseif bossEntity.Boss.BossLevel == 2 then
			self.Damage = 500
		elseif bossEntity.Boss.BossLevel == 3 then
			self.Damage = 1500
		end
	else 
		log("보스 엔티티를 찾을 수 없습니다!")
	end
	
	_TimerService:SetTimerOnce(function() 
			self.canAttack = true 
			_SoundService:PlaySound("1e40e54821a84a9c8111ecac5eea31d3", 0.1) end, 1.95)
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
	_SoundService:PlaySound("1e40e54821a84a9c8111ecac5eea31d3", 1, defender)
	return self.Damage
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

