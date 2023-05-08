--Properties--

string skillName = "SwordDash"
Component state
Component rigidbody
Component controller
number dashForce = 0
number jumpForce = 0
number startDelay = 0
number totalDelay = 0
integer timerId = 0
table effectRUID
string soundRUID = ""
boolean jumpFlag = true


--Methods--

[Default]
void OnBeginPlay()
{
	if self:IsClient() then
		self.state = _UserService.LocalPlayer.StateComponent
		self.rigidbody = _UserService.LocalPlayer.RigidbodyComponent
		self.controller = _UserService.LocalPlayer.PlayerControllerComponent
	end
	
	local skillData = _DataService:GetTable("DashData")
	local row = skillData:FindRow("Name", self.skillName)
	
	self.dashForce = tonumber(row:GetItem("DashForce"))
	self.jumpForce = tonumber(row:GetItem("JumpForce"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.soundRUID = row:GetItem("SoundRUID")
	
	self.jumpFlag = true
}

[Client]
void PreSkill()
{
	if self.state.CurrentStateName ~= "IDLE" and self.state.CurrentStateName ~= "MOVE" and self.state.CurrentStateName ~= "ATTACK_WAIT" 
		and self.state.CurrentStateName ~= "FALL" and self.state.CurrentStateName ~= "JUMP" or self.jumpFlag == false then return end
	self.timerId = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
	
}

[Client]
void UseSkillClient()
{
	self.timerId = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	if self.state.CurrentStateName == "JUMP" or self.state.CurrentStateName == "FALL" then
		self.state:ChangeState("SKILL")
		self.jumpFlag = false
		self:UseSkillServer1(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.rigidbody.RealMoveVelocity.x * 50, self.jumpForce))
		_SoundService:PlaySound(self.soundRUID, 0.75)
	else
		self.state:ChangeState("SKILL")
		self:UseSkillServer2(_UserService.LocalPlayer)
		self.rigidbody:SetForce(Vector2(self.dashForce , 0) * self.controller.LookDirectionX)
		_SoundService:PlaySound(self.soundRUID, 0.75)
	end
}

[Server]
void UseSkillServer1(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Server]
void UseSkillServer2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Client Only]
void ChangeStateToIDLE()
{
	if self.state.CurrentStateName == "SKILL" then
		self.state:ChangeState("IDLE")
	end
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

[Default]
HandleFootholdCollisionEvent(FootholdCollisionEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: RigidbodyComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local FootholdNormal = event.FootholdNormal
	local ImpactDir = event.ImpactDir
	local ImpactForce = event.ImpactForce
	local ReflectDir = event.ReflectDir
	local Rigidbody = event.Rigidbody
	---------------------------------------------------------
	self.jumpFlag = true
}

