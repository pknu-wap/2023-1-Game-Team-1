--Properties--

Component state
number startDelay = 0
number totalDelay = 0.7
Vector2 attackSize = Vector2(1.5,1.25)
Vector2 attackOffset = Vector2(0.75,0)
integer timerId = 0


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
	self.timerId = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer)
	local e = ActionStateChangedEvent("swingT3", "swingT3", 1.25, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound("27bc0369186844eca452cf461427d4ef", 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached("90f6fed910d4442bac874bf1133fa7a3", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill1", CollisionGroups.Monster)
	end, 0.25)
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

