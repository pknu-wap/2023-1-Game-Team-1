--Properties--

number MaxHp = 5000
number Hp = 0
boolean IsDead = false
number DestroyDelay = 0
Component todd


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
		
		self.Entity:Destroy()
	end
	
	_TimerService:SetTimerOnce(delayHide, self.DestroyDelay)
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
	
	if self:IsClient() then return end
	
	local originalHp = self.Hp
	self.Hp = self.Hp - TotalDamage
	
	if self.Hp > 0 or originalHp <= 0 then
		return	
	end
	
	log("튜토 머쉬 컷")
	self:Dead()
	self.todd:ChangeMode(4)
}

