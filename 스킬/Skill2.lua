--Properties--

Component state
number startDelay = 0
number totalDelay = 1.4
Vector2 attackSize = Vector2(2.2,1.5)
Vector2 attackOffset = Vector2(0.75,0)
integer timerId1 = 0
integer timerId2 = 0


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.state = _UserService.LocalPlayer.StateComponent
}

[Client]
void PreSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" then return end
	self.state:ChangeState("SKILL")
	self.timerId1 = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer1(_UserService.LocalPlayer)
	local e1 = ActionStateChangedEvent("swingT1", "swingT1", 1.25, SpriteAnimClipPlayType.Onetime)
	local e2 = ActionStateChangedEvent("swingTF", "swingTF", 1.25, SpriteAnimClipPlayType.Onetime)
	self.timerId1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e1)
	_SoundService:PlaySound("077fabb6b17c4c7499c8d9cd17ed62c8", 0.75)
	self.timerId2 = _TimerService:SetTimerOnce(function()
			self:UseSkillServer2(_UserService.LocalPlayer)
			_ActionChange:SendToServer(_UserService.LocalPlayer, e2)
			_SoundService:PlaySound("8e1bc8b4b07f4c918fbe0340c9db0576", 0.75)
		end, 0.75)
}

[Server]
void UseSkillServer1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("41af2dfa3b934cdc8928ed4216232a4d", player, Vector3.zero, 0, Vector3(0.75, 0.75, 0), false, {FlipX = flip})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill2-1", CollisionGroups.Monster)
	end, 0.3)
}

[Server]
void UseSkillServer2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0 	
	_EffectService:PlayEffectAttached("d2089557d7f947f4850e87b63e320db7", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	_TimerService:SetTimerOnce(function()
		player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill2-2", CollisionGroups.Monster)
	end, 0.3)
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
}

