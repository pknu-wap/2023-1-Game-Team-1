--Properties--

string skillName = "Skill4"
Component playerComponent
Component stateComponent
Component rigidbodyComponent
Component controllerComponent
table coefficient
number startDelay = 0
number totalDelay = 0
table attackSize
table attackOffset
integer timerId = 0
integer timerId2 = 0
integer timerId3 = 0
number remainCoolTime = 0
number skillCoolTime = 0
integer mpConsumption = 0
table effectRUID
table hitEffectRUID
table soundRUID
table hitSoundRUID


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then 
		self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
		self.stateComponent = _UserService.LocalPlayer.StateComponent
		self.rigidbodyComponent = _UserService.LocalPlayer.RigidbodyComponent
		self.controllerComponent = _UserService.LocalPlayer.PlayerControllerComponent
	end
	
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", self.skillName)
	local attackSizeX = _DataSetToTable:GetNumberTable(row:GetItem("AttackSize.x"))
	local attackSizeY = _DataSetToTable:GetNumberTable(row:GetItem("AttackSize.y"))
	local attackOffsetX = _DataSetToTable:GetNumberTable(row:GetItem("AttackOffset.x"))
	local attackOffsetY = _DataSetToTable:GetNumberTable(row:GetItem("AttackOffset.y"))
	
	self.coefficient = _DataSetToTable:GetNumberTable(row:GetItem("Coefficient"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.attackSize = {Vector2(attackSizeX[1], attackSizeY[2]), Vector2(attackSizeX[2], attackSizeY[2]), Vector2(attackSizeX[3], attackSizeY[3])}
	self.attackOffset = {Vector2(attackOffsetX[1], attackOffsetY[2]), Vector2(attackOffsetX[2], attackOffsetY[2]), Vector2(attackOffsetX[3], attackOffsetY[3])}
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.mpConsumption = tonumber(row:GetItem("MpConsumption"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = _DataSetToTable:GetStringTable(row:GetItem("HitEffectRUID"))
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = _DataSetToTable:GetStringTable(row:GetItem("HitSoundRUID"))
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
	self:UseSkillServer1(_UserService.LocalPlayer)
	local e1 = ActionStateChangedEvent("stabO1", "stabO1", 1.75 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	local e2 = ActionStateChangedEvent("swingTF", "swingTF", 1.25 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	local e3 = ActionStateChangedEvent("swingT1", "swingT1", 1.25* self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e1)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
	self.timerId2 = _TimerService:SetTimerOnce(function()
			self:UseSkillServer2(_UserService.LocalPlayer)
			self.rigidbodyComponent:AddForce(Vector2(15, 0) * self.controllerComponent.LookDirectionX)
			_ActionChange:SendToServer(_UserService.LocalPlayer, e2)
			_SoundService:PlaySound(self.soundRUID[2], 0.75)
		end, 0.55 - 0.55 * (self.playerComponent.atkSpeed - 1))
	self.timerId3 = _TimerService:SetTimerOnce(function()
			self:UseSkillServer3(_UserService.LocalPlayer)
			_ActionChange:SendToServer(_UserService.LocalPlayer, e3)
			_SoundService:PlaySound(self.soundRUID[3], 0.75)
		end, 1.2 - 1.2 * (self.playerComponent.atkSpeed - 1))
}

[Server]
void UseSkillServer1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, "Skill4-1", CollisionGroups.Monster)
}

[Server]
void UseSkillServer2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	player.AttackComponent:Attack(self.attackSize[2], self.attackOffset[2] * player.PlayerControllerComponent.LookDirectionX, "Skill4-2", CollisionGroups.Monster)
}

[Server]
void UseSkillServer3(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[3], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize[3], self.attackOffset[3] * player.PlayerControllerComponent.LookDirectionX, "Skill4-3", CollisionGroups.Monster)
		end, 0.15)
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
	_TimerService:ClearTimer(self.timerId2)
	_TimerService:ClearTimer(self.timerId3)
}
