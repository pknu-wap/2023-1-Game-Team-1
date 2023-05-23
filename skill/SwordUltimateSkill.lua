--Properties--

string skillName = "UltimateSkill"


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then
		self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
		self.stateComponent = _UserService.LocalPlayer.StateComponent
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
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer)
	local e1 = ActionStateChangedEvent("swingT3", "swingT3", 0.1, SpriteAnimClipPlayType.Onetime)
	local e2 = ActionStateChangedEvent("swingT1", "swingT1", 1.5, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e1)
	_TimerService:SetTimerOnce(function() _ActionChange:SendToServer(_UserService.LocalPlayer, e2) end, 0.85)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	local camera = player.CameraComponent
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
	_EffectService:PlayEffect(self.effectRUID[2], player.CurrentMap, Vector3(camera.CameraOffset.x, camera.CameraOffset.y, 0), 0, Vector3.one * 2.5, false, {FlipX = flip})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1], "UltimateSkill", CollisionGroups.Monster)
		end, 2.0)
}


--Events--

