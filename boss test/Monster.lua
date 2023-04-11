--Properties--

number MaxHp = 100
number Hp = 0
boolean RespawnOn = false
boolean IsDead = false
number RespawnDelay = 5
number DestroyDelay = 0.6


--Methods--

[Default]
void OnBeginPlay()
{
	self.Hp = self.MaxHp
}

[Server Only]
void Dead()
{
	self.IsDead = true
	local stateComponent = self.Entity.StateComponent
	if stateComponent then
		stateComponent:ChangeState("DEAD")
		log("monster change state to DEAD")
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
		
		if self.RespawnOn == false then
			--self.Entity:Destroy()
		end
	end
	
	_TimerService:SetTimerOnce(delayHide, self.DestroyDelay)
}

[Server Only]
void Respawn()
{
	log("Respawn")
	self.IsDead = false
	self.Entity:SetVisible(true)
	self.Entity:SetEnable(true)
	
	self.Hp = self.MaxHp
	local stateComponent = self.Entity.StateComponent
	if stateComponent then
		stateComponent:ChangeState("IDLE")
	end
}

[Default]
void Hit()
{
	local stateComponent = self.Entity.StateComponent
	if stateComponent then
		stateComponent:ChangeState("HIT")
	end
}


--Events--

[Default]
HandleHitEvent(HitEvent event)
{
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	--------------------------------------------------------
	if self:IsClient() then return end
	
	local originalHp = self.Hp
	self.Hp = self.Hp - TotalDamage
	
	if self.Hp > 0 or originalHp <= 0 then
		self:Hit()
		return	
	end
	
	self:Dead()
	
	self.RespawnOn = true
	log("리스폰 온")
	
	local timerFunc = function() self:Respawn() end
	
	if self.RespawnOn then
		log("나중에 부활")
		_TimerService:SetTimerOnce(timerFunc, self.RespawnDelay)
	end
}

