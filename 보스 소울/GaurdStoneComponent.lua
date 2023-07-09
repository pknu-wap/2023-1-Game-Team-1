--Properties--

number MaxHp = 100
number CurrentHp = 0
number Damage = 200
number delayTime = 0.03
boolean attackOn = false
number Timer = 0
Component transformComponent
Entity boss


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.transformComponent = self.Entity.TransformComponent
	self.boss = _EntityService:GetEntityByTag("Boss")
	
	_SoundService:PlaySound("3c90a0219abf42129bb790d773a1dc2f", 0.5)
	_TimerService:SetTimerOnce(function() _TimerService:SetTimerRepeat(function() self:AttackNear() end, 3) end, 3)
	
	if isvalid(self.boss) then
		log("보스 " ..self.boss.Name)
	end
	
	if isvalid(self.boss) then
		if self.boss.Boss.BossLevel == 1 then
			self.Damage = 500
			self.MaxHp = 200
		elseif self.boss.Boss.BossLevel == 2 then
			self.Damage = 2000
			self.MaxHp = 2000
		elseif self.boss.Boss.BossLevel == 3 then
			self.Damage = 5000
			self.MaxHp = 20000
		end
	else 
		log("보스 엔티티를 찾을 수 없습니다!")
	end
	
	self.CurrentHp = self.MaxHp
}

[Default]
void AttackNear()
{
	local attackSize = Vector2(5.3, 5.2)
	local attackOffset = Vector2(0, 0)
	
	_SoundService:PlaySound("5fc538f1170f4cb4993bebef4211a87f", 0.5)
	_EffectService:PlayEffect("003698afe94c48c0af40a16c126be607", self.Entity, self.transformComponent.Position + Vector3(0, 1, 0), 0, Vector3.one, false)
	
	self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
}

[Server]
void Destroy()
{
	log("파괴된다!!")
	
	
	self.boss.KnightStatue_Attack.godMode = false
	log("monster change state to DEAD")
	
	local delayHide = function()
		self.Entity:Destroy()
	end
	
	_TimerService:SetTimerOnce(delayHide, 0.5)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_SoundService:PlaySound("8faba700d24b4d16bea40a13cf71918f", 0.2)
	return self.Damage
	--return __base:CalcDamage(attacker,defender,attackInfo)
}


--Events--

[Server Only]
HandleHitEvent(HitEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: HitComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	---------------------------------------------------------
	if self:IsClient() then return end
	
	self.CurrentHp = self.CurrentHp - TotalDamage
	
	if self.CurrentHp > 0 then
		return	
	end
	
	self:Destroy()
}

