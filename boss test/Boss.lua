--Properties--

number MaxHp = 100
number Hp = 0
boolean IsDead = false
number speed = 0.5
number detectDistance = 0
number DestroyDelay = 0.6
Component stateComponent
Component stateAnimationComponent
Component BossMovementComponent
Component BossAIComponent
Component BossTransformComponent
Entity map
boolean attackEnd = true
boolean InRange = false
Component SpriteComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.Hp = self.MaxHp
	self.stateAnimationComponent = self.Entity.StateAnimationComponent
	self.stateComponent = self.Entity.StateComponent
	self.BossMovementComponent = self.Entity.MovementComponent
	self.BossAIComponent = self.Entity.BossAIComponent
	self.BossTransformComponent = self.Entity.TransformComponent
	self.SpriteComponent = self.Entity.SpriteRendererComponent
	self.attackEnd = true
	self.stateComponent:RemoveState("HIT")
	
	--log("현재 체력 " ..self.Hp)
}

[Server Only]
void Dead()
{
	self.IsDead = true
	
	if self.stateComponent then
		self.stateComponent:ChangeState("DEAD")
		--log("죽음")
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		--self.Entity:SetEnable(false)
	end
	
	_TimerService:SetTimerOnce(delayHide, self.DestroyDelay)
}

[Default]
void Hit()
{
	if self.stateComponent then
		--self.stateComponent:ChangeState("HIT")
	end
}

[Server Only]
void OnUpdate(number delta)
{
	--log("보스 현재 스테이트 상태 : " ..self.stateComponent.CurrentStateName)
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

