--Properties--

string skillName = "Skill5"
Component state
table coefficient
number startDelay = 0
number totalDelay = 0.7
Vector2 attackSize = Vector2(0,0)
Vector2 attackOffset = Vector2(0,0)
integer timerId = 0
number remainCoolTime = 0
number skillCoolTime = 0
table effectRUID
string hitEffectRUID = ""
table soundRUID
string hitSoundRUID = ""
string modelID = ""


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then 
		self.state = _UserService.LocalPlayer.StateComponent
	end
	
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", self.skillName)
	
	self.coefficient = _DataSetToTable:GetNumberTable(row:GetItem("Coefficient"))
	self.attackSize = Vector2(tonumber(row:GetItem("AttackSize.x")), tonumber(row:GetItem("AttackSize.y")))
	self.attackOffset = Vector2(tonumber(row:GetItem("AttackOffset.x")), tonumber(row:GetItem("AttackOffset.y")))
	self.skillCoolTime = tonumber(row:GetItem("CoolTime"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = row:GetItem("HitEffectRUID")
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = row:GetItem("HitSoundRUID")
	self.modelID = row:GetItem("Option")
}

[Client]
void PreSkill()
{
	if self.remainCoolTime > 0 or self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" then return end
	self.state:ChangeState("SKILL")
	self:CalcCoolTime()
	self.timerId = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
}

[Client]
void UseSkillClient()
{
	self:UseSkillServer(_UserService.LocalPlayer)
	local e = ActionStateChangedEvent("swingT3", "swingT3", 1.25, SpriteAnimClipPlayType.Onetime)
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	_ActionChange:SendToServer(_UserService.LocalPlayer, e)
	_SoundService:PlaySound(self.soundRUID[1], 0.75)
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	local spawnPosition = Vector3(player.TransformComponent.Position.x + 2 * player.PlayerControllerComponent.LookDirectionX, player.TransformComponent.Position.y, 0)
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip, StartFrameIndex = 1})
	_TimerService:SetTimerOnce(function()
			local object = _SpawnService:SpawnByModelId(self.modelID, "Skill5Object",  spawnPosition, self.Entity.CurrentMap)
			object.Skill5Object.player = self.Entity
		end, 1.0)
}

[Client Only]
void ChangeStateToIDLE()
{
	if self.state.CurrentStateName == "SKILL" then
		self.state:ChangeState("IDLE")
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
}

