--Properties--

number MaxHp = 100
number Hp = 0
boolean IsDead = false
number DestroyDelay = 0.6
Component stateAnimationComponent
Component stateComponent
Entity map


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.Hp = self.MaxHp
	self.stateAnimationComponent = self.Entity.StateAnimationComponent
}

[Server Only]
void Dead()
{
	self.IsDead = true
	
	if self.stateComponent then
		self.stateComponent:ChangeState("DEAD")
		log("죽음")
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
	end
	
	_TimerService:SetTimerOnce(delayHide, self.DestroyDelay)
}

[Default]
void Hit()
{
	if self.stateComponent then
		self.stateComponent:ChangeState("HIT")
	end
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
		self:Hit()
		return
	end
	
	self:Dead()
}

