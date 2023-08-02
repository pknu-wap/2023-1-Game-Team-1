--Properties--

string skillName = "sw2"
string class = "sword"


--Methods--

[Default]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	
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
	self.attackSize = {Vector2(attackSizeX[1], attackSizeY[1]), Vector2(attackSizeX[2], attackSizeY[2])}
	self.attackOffset = {Vector2(attackOffsetX[1], attackOffsetY[1]), Vector2(attackOffsetX[2], attackOffsetY[2])}
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.mpConsumption = tonumber(row:GetItem("MpConsumption"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = _DataSetToTable:GetStringTable(row:GetItem("HitEffectRUID"))
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = _DataSetToTable:GetStringTable(row:GetItem("HitSoundRUID"))
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer, self.attackDelay[1] - self.attackDelay[1] * (self.playerComponent.atkSpeed - 1))
	local e = ActionStateChangedEvent("swingT1", "swingT1", 1.25 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
	self.hitComponent.skillTimer2 = _TimerService:SetTimerOnce(self.UseSkillClient2, 0.75 - 0.75 * (self.playerComponent.atkSpeed - 1))
}

[Client]
void UseSkillClient2()
{
	local e = ActionStateChangedEvent("swingTF", "swingTF", 1.25 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self:UseSkillServer2(_UserService.LocalPlayer, self.attackDelay[2] - self.attackDelay[2] * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[2], 0.75)
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3(0.75, 0.75, 0), false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, self.skillName, CollisionGroups.Monster)
	end, delay)
}

[Server]
void UseSkillServer2(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0 	
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function()
		player.AttackComponent:Attack(self.attackSize[2], self.attackOffset[2] * player.PlayerControllerComponent.LookDirectionX, self.skillName.."-2", CollisionGroups.Monster)
	end, delay)
}


--Events--

