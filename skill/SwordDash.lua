--Properties--

string skillName = "SwordDash"
boolean jumpFlag = false


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
	
	local skillData = _DataService:GetTable("DashData")
	local row = skillData:FindRow("Name", self.skillName)
	
	self.dashForce = tonumber(row:GetItem("DashForce"))
	self.jumpForce = tonumber(row:GetItem("JumpForce"))
	self.startDelay = tonumber(row:GetItem("StartDelay"))
	self.totalDelay = tonumber(row:GetItem("TotalDelay"))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.jumpFlag = true
}

[Client]
void UseSkillClient()
{
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.ChangeStateToIDLE, self.totalDelay)
	if self.stateComponent.CurrentStateName == "JUMP" or self.stateComponent.CurrentStateName == "FALL" then
		self.stateComponent:ChangeState("SKILL")
		self.jumpFlag = false
		self:UseSkillServer(_UserService.LocalPlayer)
		self.rigidbodyComponent:SetForce(Vector2(self.rigidbodyComponent.RealMoveVelocity.x * 50, self.jumpForce))
		_SoundService:PlaySound(self.soundRUID[1], 0.75)
		log("윗점")
	else
		self.stateComponent:ChangeState("SKILL")
		self:UseSkillServer2(_UserService.LocalPlayer)
		self.rigidbodyComponent:SetForce(Vector2(self.dashForce , 0) * self.controllerComponent.LookDirectionX)
		_SoundService:PlaySound(self.soundRUID[1], 0.75)
		log("대시")
	end
}

[Server]
void UseSkillServer(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[1], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}

[Default]
void UseSkillServer2(Entity player)
{
	local flip = player.PlayerControllerComponent.LookDirectionX > 0
	_EffectService:PlayEffectAttached(self.effectRUID[2], player, Vector3.zero, 0, Vector3.one, false, {FlipX = flip})
}


--Events--

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

