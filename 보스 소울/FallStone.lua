--Properties--

Vector2 attackSize = Vector2(2.8,14)
Vector2 attackOffset = Vector2(0,0)
number delayTime = 0.03
Component spriteRendererComponent
number fallSpeed = 3
Component transformComponent
number Damage = 0
Component soundComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.spriteRendererComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
	self.soundComponent = self.Entity.SoundComponent
	
	local bossEntity = _EntityService:GetEntityByTag("Boss")
	
	if isvalid(bossEntity) then
		if bossEntity.Boss.BossLevel == 1 then
			self.Damage = 200
		elseif bossEntity.Boss.BossLevel == 2 then
			self.Damage = 1000
		elseif bossEntity.Boss.BossLevel == 3 then
			self.Damage = 2500
		end
	else 
		log("보스 엔티티를 찾을 수 없습니다!")
	end
}

[Default]
void AttackNear()
{
	self:Attack(self.attackSize, self.attackOffset, nil, CollisionGroups.Player)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	self:BoomSound(2)
	return self.Damage
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

[Client]
void BoomSound(number num)
{
	_SoundService:PlaySound("4a15424616fa4db0b898dd2bebed2a2d", num)
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
	if TriggerBodyEntity.TriggerComponent.CollisionGroup ~= CollisionGroups.Player then
		self:BoomSound(0.3)
	end
	
	self.fallSpeed = 0
	self:Boom()
}

