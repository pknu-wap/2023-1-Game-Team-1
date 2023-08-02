--Properties--

string skillName = "wa7"
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
	self.attackSize = {Vector2(attackSizeX[1], attackSizeY[1]), Vector2(attackSizeX[2],attackSizeY[2])}
	self.attackOffset = {Vector2(attackOffsetX[1], attackOffsetY[1])}
	self.skillDuration = tonumber(row:GetItem("Duration"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = _DataSetToTable:GetStringTable(row:GetItem("HitEffectRUID"))
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = _DataSetToTable:GetStringTable(row:GetItem("HitSoundRUID"))
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" or self.remainCoolTime > 0 or self.playerComponent.Up < 100 then return end
	self.stateComponent:ChangeState("SKILL")
	self.playerComponent:UpConsume(100)
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay  - self.startDelay * (self.playerComponent.atkSpeed - 1))
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
	local Position = player.TransformComponent.Position
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, PlayRate = player.ExtendPlayerComponent.atkSpeed})
	_TimerService:SetTimerOnce(function()
			player.AttackComponent:Attack(self.attackSize[2], self.attackOffset[2], self.skillName, CollisionGroups.Player)
		end, delay)
	local attack = function(offset)
		_EffectService:PlayEffect(self.effectRUID[1], player.Parent, Vector3(Position.x + offset, Position.y, Position.z), 0, Vector3.one, false, {PlayRate = player.ExtendPlayerComponent.atkSpeed})
		_EffectService:PlayEffect(self.effectRUID[1], player.Parent, Vector3(Position.x - offset, Position.y, Position.z), 0, Vector3.one, false, {PlayRate = player.ExtendPlayerComponent.atkSpeed})
		_TimerService:SetTimerOnce(function()
				player.AttackComponent:AttackFrom(self.attackSize[1], Vector2(Position.x + offset, Position.y + 2), self.skillName, CollisionGroups.Monster)
				player.AttackComponent:AttackFrom(self.attackSize[1], Vector2(Position.x - offset, Position.y + 2), self.skillName, CollisionGroups.Monster)
			end, delay)
	end
	_TimerService:SetTimerOnce(function() attack(1.5) end, delay / 2)
	_TimerService:SetTimerOnce(function() attack(3.0) end, delay)
	_TimerService:SetTimerOnce(function() attack(4.5) end, delay * 1.5)
	_TimerService:SetTimerOnce(function() attack(6) end, delay * 2)
}

[Server]
void EnableBuff(Entity player)
{
	__base:EnableBuff(player)
	_EffectService:PlayEffectAttached(self.hitEffectRUID[1], player, Vector3.zero, 0, Vector3.one, false)
	log(player.Name.." : 궁극기 버프 활성화")
}

[Server]
void DisableBuff(Entity player)
{
	log(player.Name.." : 궁극기 버프 비활성화")
}


--Events--

