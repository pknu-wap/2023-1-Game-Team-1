--Properties--

string skillName = "sw3"
Component rigidbodyComponent
Component controllerComponent


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
	local attackSizeX = _DataSetToTable:GetNumberTable(row:GetItem("AttackSize.x"))
	local attackSizeY = _DataSetToTable:GetNumberTable(row:GetItem("AttackSize.y"))
	local attackOffsetX = _DataSetToTable:GetNumberTable(row:GetItem("AttackOffset.x"))
	local attackOffsetY = _DataSetToTable:GetNumberTable(row:GetItem("AttackOffset.y"))
	
	self.coefficient = _DataSetToTable:GetNumberTable(row:GetItem("Coefficient"))
	self.upChargeRate = _DataSetToTable:GetNumberTable(row:GetItem("UpChargeRate"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.attackDelay = _DataSetToTable:GetNumberTable(row:GetItem("AttackDelay"))
	self.attackSize = {Vector2(attackSizeX[1], attackSizeY[1])}
	self.attackOffset = {Vector2(attackOffsetX[1], attackOffsetY[1])}
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
	self.hitComponent:Counter(0.25)
	self.playerComponent:MpConsume(self.mpConsumption)
	self:CalcCoolTime()
	local e = ActionStateChangedEvent("swingT3", "swingT3", 0.1, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(function() self:UseSkillClient_Counter(false) end, self.startDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
}

[Client]
void UseSkillClient_Counter(boolean isSuccess)
{
	local e = ActionStateChangedEvent("swingTF", "swingTF", 1.0, SpriteAnimClipPlayType.Onetime)
	self.stateComponent:ChangeState("SKILL")
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	self.rigidbodyComponent:AddForce(Vector2(20, 0) * self.controllerComponent.LookDirectionX)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
	if isSuccess then
		_SoundService:PlaySound(self.soundRUID[2], 1.0) 
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
		self:UseSkillServer(_UserService.LocalPlayer, self.attackDelay[1] - self.attackDelay[1] * (self.playerComponent.atkSpeed - 1))
		self.remainCoolTime = self.remainCoolTime / 2
	else
		_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	end
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffect(self.effectRUID[2], player.CurrentMap, player.TransformComponent.Position, 0, Vector3.one * 1.5, false)
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, "sw3", CollisionGroups.Monster)
}


--Events--

