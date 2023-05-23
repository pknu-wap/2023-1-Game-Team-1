--Properties--

boolean isCounter = false
integer skillTimer1 = 0
integer skillTimer2 = 0
integer skillTimer3 = 0


--Methods--

[Default]
void OnHit(Entity attacker, integer damage, boolean isCritical, string attackInfo, int32 hitCount)
{
	if self.isCounter then
		damage = 0
		attackInfo = "Counter"
		self.isCounter = false
	end
	
	__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
}

[Server]
void Counter(number sec)
{
	self.isCounter = true
	_TimerService:SetTimerOnce(function() self.isCounter = false end, sec)
}

[Client]
void CancelSkill()
{
	_TimerService:ClearTimer(self.skillTimer1)
	_TimerService:ClearTimer(self.skillTimer2)
	_TimerService:ClearTimer(self.skillTimer3)
}


--Events--

[Default]
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
	if self:IsServer() then return end
	self:CancelSkill()
	
	if Extra == "Counter" and self.Entity == _UserService.LocalPlayer then
		_TimerService:ClearTimer(self.skillTimer1)
		_SwordSkill3:UseSkillClient_Counter(true)
	end
}

