--Properties--

string skillName = "UltimateSkill"
Component state
number coefficient = 0
number startDelay = 0
number totalDelay = 0
Vector2 attackSize = Vector2(0,0)
Vector2 attackOffset = Vector2(0,0)
integer timerId = 0
table effectRUID
string hitEffectRUID = ""
string soundRUID = ""
string hitSoundRUID = ""


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then 
		self.state = _UserService.LocalPlayer.StateComponent
	end
	
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", self.skillName)
	
	self.coefficient = tonumber(row:GetItem("Coefficient"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.attackSize = Vector2(tonumber(row:GetItem("AttackSize.x")), tonumber(row:GetItem("AttackSize.y")))
	self.attackOffset = Vector2(tonumber(row:GetItem("AttackOffset.x")), tonumber(row:GetItem("AttackOffset.y")))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = row:GetItem("HitEffectRUID")
	self.soundRUID = row:GetItem("SoundRUID")
	self.hitSoundRUID = row:GetItem("HitEffectRUID")
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
	local e1 = ActionStateChangedEvent("swingT3", "swingT3", 0.1, SpriteAnimClipPlayType.Onetime)
	local e2 = ActionStateChangedEvent("swingT1", "swingT1", 1.5, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e1)
	_TimerService:SetTimerOnce(function() _ActionChange:SendToServer(_UserService.LocalPlayer, e2) end, 0.85)
	_SoundService:PlaySound("b9c62d5fa12f461889d3392164112234", 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	local camera = player.CameraComponent
	_EffectService:PlayEffectAttached("fa4309d8353440ca8abe6f6992fb7106", player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	_EffectService:PlayEffect("9aac6392c97e4b7f96899d3b02de1cf9", self.Entity.CurrentMap, Vector3(camera.CameraOffset.x, camera.CameraOffset.y, 0), 0, Vector3.one * 2.5, false, {FlipX = flip})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize, self.attackOffset, "UltimateSkill", CollisionGroups.Monster)
		end, 2.0)
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

