--Properties--

Component state
Component rigidbody
Component controller
number dashForce = 15
number jumpForce = 10
number delay = 0.3
integer timerId = 0


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.state = _UserService.LocalPlayer.StateComponent
	self.rigidbody = _UserService.LocalPlayer.RigidbodyComponent
	self.controller = _UserService.LocalPlayer.PlayerControllerComponent
}

[Server]
void PlayEffect1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("af166c03cbbd4c82b128f1ad8f3cbaf4", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Server]
void PlayEffect2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("114cfd8a5b0842f1a21432d386f3c7fc", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Client]
void UseSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" 
		and self.state.CurrentStateName ~= "FALL" and self.state.CurrentStateName ~= "JUMP" then return end
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.delay)
	if self.state.CurrentStateName == "JUMP" or self.state.CurrentStateName == "FALL" then
		self.state:ChangeState("SKILL")
		self:PlayEffect1(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.rigidbody.RealMoveVelocity.x * 50, self.jumpForce))
	else
		self.state:ChangeState("SKILL")
		self:PlayEffect2(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.dashForce , 0) * self.controller.LookDirectionX)
	end
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

