--Properties--

Component state
Component rigidbody
Component controller
number dashForce = 15
number jumpForce = 10
number startDelay = 0
number totalDelay = 0.3
integer timerId = 0
boolean jumpFlag = true


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.state = _UserService.LocalPlayer.StateComponent
	self.rigidbody = _UserService.LocalPlayer.RigidbodyComponent
	self.controller = _UserService.LocalPlayer.PlayerControllerComponent
}

[Client]
void PreSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" 
		and self.state.CurrentStateName ~= "FALL" and self.state.CurrentStateName ~= "JUMP" or self.jumpFlag == false then return end
	self.timerId = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
	
}

[Client]
void UseSkillClient()
{
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	if self.state.CurrentStateName == "JUMP" or self.state.CurrentStateName == "FALL" then
		self.state:ChangeState("SKILL")
		self.jumpFlag = false
		self:UseSkillServer1(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.rigidbody.RealMoveVelocity.x * 50, self.jumpForce))
	else
		self.state:ChangeState("SKILL")
		self:UseSkillServer2(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.dashForce , 0) * self.controller.LookDirectionX)
	end
}

[Server]
void UseSkillServer1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("af166c03cbbd4c82b128f1ad8f3cbaf4", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Server]
void UseSkillServer2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("114cfd8a5b0842f1a21432d386f3c7fc", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Client Only]
void ChangeStateToIDLE()
{
	if self.state.CurrentStateName == "SKILL" then
		self.state:ChangeState("IDLE")
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
	if self:IsServer() then return end
	_TimerService:ClearTimer(self.timerId)
}

[Default]
HandleFootholdCollisionEvent(FootholdCollisionEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: RigidbodyComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local FootholdNormal = event.FootholdNormal
	local ImpactDir = event.ImpactDir
	local ImpactForce = event.ImpactForce
	local ReflectDir = event.ReflectDir
	local Rigidbody = event.Rigidbody
	---------------------------------------------------------
	self.jumpFlag = true
}

