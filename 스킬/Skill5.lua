--Properties--

Component state
number startDelay = 0
number totalDelay = 0.7
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
	_SoundService:PlaySound("5f565443108e459bbb89b46ed658da68", 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	local spawnPosition = Vector3(player.TransformComponent.Position.x + 2 * player.PlayerControllerComponent.LookDirectionX, player.TransformComponent.Position.y, 0)
	_EffectService:PlayEffectAttached("deec9052c3524bedad419cc22b194508", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, StartFrameIndex = 1})
	_TimerService:SetTimerOnce(function()
			_SpawnService:SpawnByModelId("model://70b25a29-a34b-4d38-a70f-b1fe04add56e", "Skill5Object",  spawnPosition, self.Entity.CurrentMap)
		end, 1.0)
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

