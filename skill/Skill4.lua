--Properties--

Component state
Component rigidbody
Component controller
number delay = 1.9
Vector2 attackSize1 = Vector2(3,0.5)
Vector2 attackOffset1 = Vector2(1.5,0)
Vector2 attackSize2 = Vector2(4.5,0.75)
Vector2 attackOffset2 = Vector2(1.25,0)
Vector2 attackSize3 = Vector2(1.5,1.25)
Vector2 attackOffset3 = Vector2(0.75,0)
integer timerId1 = 0
integer timerId2 = 0
integer timerId3 = 0


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.state = _UserService.LocalPlayer.StateComponent
	self.rigidbody = _UserService.LocalPlayer.RigidbodyComponent
	self.controller = _UserService.LocalPlayer.PlayerControllerComponent
}

[Server]
void PlayEffectAndAttack1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("fb75823f35b44065ad07300a8a21cc03", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	player.AttackComponent:Attack(self.attackSize1, self.attackOffset1 * player.PlayerControllerComponent.LookDirectionX, "Skill4-1", CollisionGroups.Monster)
}

[Server]
void PlayEffectAndAttack2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("137539a9348b43fa859b85166e24208a", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	player.AttackComponent:Attack(self.attackSize2, self.attackOffset2 * player.PlayerControllerComponent.LookDirectionX, "Skill4-2", CollisionGroups.Monster)
}

[Server]
void PlayEffectAndAttack3(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("5b1bca4c94e64bcab98427cb23106606", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize3, self.attackOffset3 * player.PlayerControllerComponent.LookDirectionX, "Skill4-3", CollisionGroups.Monster)
		end, 0.15)
}

[Client]
void UseSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" then return end
	self.state:ChangeState("SKILL")
	self:PlayEffectAndAttack1(_UserService.LocalPlayer)
	local e1 = ActionStateChangedEvent("stabO1", "stabO1", 1.75, SpriteAnimClipPlayType.Onetime)
	local e2 = ActionStateChangedEvent("swingTF", "swingTF", 1.25, SpriteAnimClipPlayType.Onetime)
	local e3 = ActionStateChangedEvent("swingT1", "swingT1", 1.25, SpriteAnimClipPlayType.Onetime)
	self.timerId1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.delay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e1)
	_SoundService:PlaySound("915da5a755944599979b9369d1bfd980", 0.75)
	self.timerId2 = _TimerService:SetTimerOnce(function()
			self:PlayEffectAndAttack2(_UserService.LocalPlayer)
			self.rigidbody:AddForce(Vector2(15, 0) * self.controller.LookDirectionX)
			_ActionChange:SendToServer(_UserService.LocalPlayer, e2)
			_SoundService:PlaySound("8556bff9c68748a08f706799c5d789e6", 0.75)
		end, 0.55)
	self.timerId3 = _TimerService:SetTimerOnce(function()
			self:PlayEffectAndAttack3(_UserService.LocalPlayer)
			_ActionChange:SendToServer(_UserService.LocalPlayer, e3)
			_SoundService:PlaySound("b66546edf7ff474fb6063a03d23617fa", 0.75)
		end, 1.2)
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
	_TimerService:ClearTimer(self.timerId1)
	_TimerService:ClearTimer(self.timerId2)
	_TimerService:ClearTimer(self.timerId3)
}

