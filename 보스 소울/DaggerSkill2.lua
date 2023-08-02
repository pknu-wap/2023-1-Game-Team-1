--Properties--

string skillName = "dg2"
string class = "dagger"


--Methods--

[Default]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	
	local skillData = _DataService:GetTable("DaggerSkillData")
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
void UseSkillClient()
{
	local player = _UserService.LocalPlayer
	self:UseSkillServer(player, self.attackDelay[1] - self.attackDelay[1] * (self.playerComponent.atkSpeed - 1))
	player.Visible = false
	_TimerService:SetTimerOnce(function() player.Visible = true end, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay - self.totalDelay * (self.playerComponent.atkSpeed - 1))
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function() 	
		player.AttackComponent:Attack(self.attackSize[1], self.attackOffset[1] * player.PlayerControllerComponent.LookDirectionX, self.skillName, CollisionGroups.Monster)
	end, delay)
}


--Events--

