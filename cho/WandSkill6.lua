--Properties--

string skillName = "wa6"
string class = "wand"


--Methods--

[Default]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	
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
	self.skillDuration = tonumber(row:GetItem("Duration"))
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.mpConsumption = tonumber(row:GetItem("MpConsumption"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = _DataSetToTable:GetStringTable(row:GetItem("HitEffectRUID"))
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer, self.attackDelay[1] - self.attackDelay[1] * (self.playerComponent.atkSpeed - 1))
	local e = ActionStateChangedEvent("shoot1", "shoot1", 0.75 * self.playerComponent.atkSpeed, SpriteAnimClipPlayType.Onetime)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, self.skillName, CollisionGroups.Player)
	end, delay)
}

[Server]
void EnableBuff(Entity player)
{
	__base:EnableBuff(player)
	_EffectService:PlayEffectAttached(self.hitEffectRUID[1], player, Vector3.zero, 0, Vector3.one, false)
	log(player.Name.." : 방어막 버프 활성화")
}

[Server]
void DisableBuff(Entity player)
{
	__base:DisableBuff(player)
	log(player.Name.." : 방어막 버프 비활성화")
}


--Events--

