--Properties--

string skillName = "wa4"
string modelId = ""


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then
		self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
		self.stateComponent = _UserService.LocalPlayer.StateComponent
		self.hitComponent = _UserService.LocalPlayer.PlayerHit
	end
	
	local skillData = _DataService:GetTable("WandSkillData")
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
	self.modelId = row:GetItem("Option")
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer, self.attackDelay[1] - self.attackDelay[1] * (self.playerComponent.atkSpeed - 1))
	local e = ActionStateChangedEvent("swingO3", "swingO3", 1.25, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	local spawnPosition = Vector3(player.TransformComponent.Position.x + 2.5, player.TransformComponent.Position.y, 0)
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function()
			local object = _SpawnService:SpawnByModelId(self.modelId, "WandSkill4Object",  spawnPosition, player.CurrentMap)
			object.WandSkill4Object.player = player
		end, delay)
}

[Server]
void EnableBuff(Entity player)
{
	_EffectService:PlayEffectAttached(self.hitEffectRUID[2], player, Vector3.zero, 0, Vector3.one, false)
	player.ExtendPlayerComponent:RecoverHp(self.coefficient[2])
}


--Events--

