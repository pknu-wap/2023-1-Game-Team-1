--Properties--

Component state
Component rigidbody
Component controller
Component hit
number startDelay = 0.75
number totalDelay = 0.75
Vector2 attackSize = Vector2(4.0,1.25)
Vector2 attackOffset = Vector2(2,0)
integer timerId = 0


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.state = _UserService.LocalPlayer.StateComponent
	self.rigidbody = _UserService.LocalPlayer.RigidbodyComponent
	self.controller = _UserService.LocalPlayer.PlayerControllerComponent
	self.hit = _UserService.LocalPlayer.PlayerHit
}

[Client]
void PreSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" then return end
	self.state:ChangeState("SKILL")
	self.hit:Counter(0.25)
	local e = ActionStateChangedEvent("swingT3", "swingT3", 0.1, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(function() self:UseSkillClient(false) end, self.startDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
}

[Client]
void UseSkillClient(boolean isSuccess)
{
	local e = ActionStateChangedEvent("swingTF", "swingTF", 1.0, SpriteAnimClipPlayType.Onetime)
	self.state:ChangeState("SKILL")
	_TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	self.rigidbody:AddForce(Vector2(20, 0) * self.controller.LookDirectionX)
	_SoundService:PlaySound("c614e227c25a4381a6b833cfa2cd1f60", 0.75)
	if isSuccess then 
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
		self:UseSkillServer(_UserService.LocalPlayer)
	else
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	end
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffect("91eed87ae39d4baf97b21b996c4acb52", self.Entity.CurrentMap, self.Entity.TransformComponent.Position, 0, Vector3.one * 1.5, false)
	_EffectService:PlayEffectAttached("d5959054cf0841a0bd9a82fd1d38966a", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill3", CollisionGroups.Monster)
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
	if self:IsServer() or Extra ~= "Counter" or self.Entity ~= _UserService.LocalPlayer then return end
	_TimerService:ClearTimer(self.timerId)
	self:UseSkillClient(true)
	_SoundService:PlaySound("1732e555ecf84c8fb9fbc10735b6e102", 1.0)
	
}

