--Properties--

string skillName = "sw4"
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
	self.attackSize = {Vector2(attackSizeX[1], attackSizeY[1]), Vector2(attackSizeX[2], attackSizeY[2]), Vector2(attackSizeX[3], attackSizeY[3])}
	self.attackOffset = {Vector2(attackOffsetX[1], attackOffsetY[1]), Vector2(attackOffsetX[2], attackOffsetY[2]), Vector2(attackOffsetX[3], attackOffsetY[3])}
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
	local e = ActionStateChangedEvent("stabO1", "stabO1", 1.75 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
	self.hitComponent.skillTimer2 = _TimerService:SetTimerOnce(self.UseSkillClient2, 0.55 - 0.55 * (self.playerComponent.atkSpeed - 1))
	self.hitComponent.skillTimer3 = _TimerService:SetTimerOnce(self.UseSkillClient3, 1.2 - 1.2 * (self.playerComponent.atkSpeed - 1))
}

[Client]
void UseSkillClient2()
{
	local e = ActionStateChangedEvent("swingTF", "swingTF", 1.25 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self:UseSkillServer2(_UserService.LocalPlayer, self.attackDelay[2] - self.attackDelay[2] * (self.playerComponent.atkSpeed - 1))
	self.rigidbodyComponent:AddForce(Vector2(15, 0) * self.controllerComponent.LookDirectionX)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[2], 0.75)
}

[Client]
void UseSkillClient3()
{
	local e = ActionStateChangedEvent("swingT1", "swingT1", 1.25* self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self:UseSkillServer3(_UserService.LocalPlayer, self.attackDelay[3] - self.attackDelay[3] * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[3], 0.75)
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, "sw4-1", CollisionGroups.Monster)
}

[Server]
void UseSkillServer2(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	player.AttackComponent:Attack(self.attackSize[2], self.attackOffset[2] * player.PlayerControllerComponent.LookDirectionX, "sw4-2", CollisionGroups.Monster)
}

[Server]
void UseSkillServer3(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[3], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize[3], self.attackOffset[3] * player.PlayerControllerComponent.LookDirectionX, "sw4-3", CollisionGroups.Monster)
		end, delay)
}


--Events--

