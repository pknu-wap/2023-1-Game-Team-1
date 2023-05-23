--Properties--

string skillName = "Skill1"
Component playerComponent
Component stateComponent
number coefficient = 0
number upChargeRate = 0
number startDelay = 0
number totalDelay = 0
Vector2 attackSize = Vector2(0,0)
Vector2 attackOffset = Vector2(0,0)
integer timerId = 0
number remainCoolTime = 0
number skillCoolTime = 0
integer mpConsumption = 0
string effectRUID = ""
string hitEffectRUID = ""
string soundRUID = ""
string hitSoundRUID = ""


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then
		self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
		self.stateComponent = _UserService.LocalPlayer.StateComponent
	end
	
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", self.skillName)
	self.coefficient = tonumber(row:GetItem("Coefficient"))
	self.upChargeRate = tonumber(row:GetItem("UpChargeRate"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.attackSize = Vector2(tonumber(row:GetItem("AttackSize.x")), tonumber(row:GetItem("AttackSize.y")))
	self.attackOffset = Vector2(tonumber(row:GetItem("AttackOffset.x")), tonumber(row:GetItem("AttackOffset.y")))
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.mpConsumption = tonumber(row:GetItem("MpConsumption"))
	self.effectRUID = row:GetItem("EffectRUID")
	self.hitEffectRUID = row:GetItem("HitEffectRUID")
	self.soundRUID = row:GetItem("SoundRUID")
	self.hitSoundRUID = row:GetItem("HitSoundRUID")
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" or self.remainCoolTime > 0 or self.playerComponent.Mp < self.mpConsumption then return end
	self.stateComponent:ChangeState("SKILL")
	self.playerComponent:MpConsume(self.mpConsumption)
	self:CalcCoolTime()
	self.timerId = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay - self.startDelay * (self.playerComponent.atkSpeed - 1))
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer)
	local e = ActionStateChangedEvent("swingT3", "swingT3", 1.25 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID, 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID, player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill1", CollisionGroups.Monster)
	end, 0.25)
}

[Client Only]
void ChangeStateToIDLE()
{
	if self.stateComponent.CurrentStateName == "SKILL" then
		self.stateComponent:ChangeState("IDLE")
	end
}

[Client]
void CalcCoolTime()
{
	self.remainCoolTime = self.skillCoolTime
	local coolTimer = 0
	local CheckCoolTime = function()
		self.remainCoolTime = self.remainCoolTime - 1
		log(self.remainCoolTime)
		if self.remainCoolTime <= 0 then _TimerService:ClearTimer(coolTimer) end
		end
	coolTimer = _TimerService:SetTimerRepeat(CheckCoolTime, 1, 1)
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

