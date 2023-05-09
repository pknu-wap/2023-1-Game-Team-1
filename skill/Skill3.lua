--Properties--

string skillName = "Skill3"
Component playerComponent
Component stateComponent
Component rigidbodyComponent
Component controllerComponent
Component hitComponent
number coefficient = 0
number startDelay = 0
number totalDelay = 0
Vector2 attackSize = Vector2(0,0)
Vector2 attackOffset = Vector2(0,0)
integer timerId = 0
number remainCoolTime = 0
number skillCoolTime = 0
integer mpConsumption = 0
table effectRUID
string hitEffectRUID = ""
table soundRUID
string hitSoundRUID = ""


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then 
		self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
		self.stateComponent = _UserService.LocalPlayer.StateComponent
		self.rigidbodyComponent = _UserService.LocalPlayer.RigidbodyComponent
		self.controllerComponent = _UserService.LocalPlayer.PlayerControllerComponent
		self.hitComponent = _UserService.LocalPlayer.PlayerHit
	end
	
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", self.skillName)
	local row2 = skillData:FindRow("Name", "Skill3 - Counter")
	self.coefficient = tonumber("Coefficient")
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.attackSize = Vector2(tonumber(row:GetItem("AttackSize.x")), tonumber(row:GetItem("AttackSize.y")))
	self.attackOffset = Vector2(tonumber(row:GetItem("AttackOffset.x")), tonumber(row:GetItem("AttackOffset.y")))
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.mpConsumption = tonumber(row:GetItem("MpConsumption"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = row:GetItem("HitEffectRUID")
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = row:GetItem("HitSoundRUID")
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" or self.remainCoolTime > 0 or self.playerComponent.Mp < self.mpConsumption then return end
	self.stateComponent:ChangeState("SKILL")
	self.hitComponent:Counter(0.25)
	self.playerComponent:MpConsume(self.mpConsumption)
	self:CalcCoolTime()
	local e = ActionStateChangedEvent("swingT3", "swingT3", 0.1, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(function() self:UseSkillClient(false) end, self.startDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
}

[Client]
void UseSkillClient(boolean isSuccess)
{
	local e = ActionStateChangedEvent("swingTF", "swingTF", 1.0, SpriteAnimClipPlayType.Onetime)
	self.stateComponent:ChangeState("SKILL")
	_TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	self.rigidbodyComponent:AddForce(Vector2(20, 0) * self.controllerComponent.LookDirectionX)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
	if isSuccess then 
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
		self:UseSkillServer(_UserService.LocalPlayer)
		self.remainCoolTime = self.remainCoolTime / 2
	else
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	end
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffect(self.effectRUID[2], self.Entity.CurrentMap, self.Entity.TransformComponent.Position, 0, Vector3.one * 1.5, false)
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	player.AttackComponent:Attack(self.attackSize, self.attackOffset * player.PlayerControllerComponent.LookDirectionX, "Skill3", CollisionGroups.Monster)
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
	if self:IsServer() or Extra ~= "Counter" or self.Entity ~= _UserService.LocalPlayer then return end
	_TimerService:ClearTimer(self.timerId)
	self:UseSkillClient(true)
	_SoundService:PlaySound(self.soundRUID[2], 1.0)
	
}

