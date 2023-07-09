--Properties--

string skillName = ""
Component playerComponent
Component stateComponent
Component hitComponent
table coefficient
table upChargeRate
number startDelay = 0
number totalDelay = 0
table attackDelay
table attackSize
table attackOffset
number skillDuration = 0
number remainDuration = 0
number remainCoolTime = 0
number skillCoolTime = 0
integer mpConsumption = 0
table effectRUID
table hitEffectRUID
table soundRUID
table hitSoundRUID
integer buffTimer = 0
boolean isSkillReady = true


--Methods--

[Default]
void OnBeginPlay()
{
	
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" or not self.isSkillReady or self.playerComponent.Mp < self.mpConsumption then return end
	self.stateComponent:ChangeState("SKILL")
	self.playerComponent:MpConsume(self.mpConsumption)
	self:CalcCoolTime()
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay - self.startDelay * (self.playerComponent.atkSpeed - 1))
}

[Client]
void UseSkillClient()
{
	
}

[Server]
void UseSkillServer(Entity player, number delay)
{
	
}

[Client Only]
void ChangeStateToIDLE()
{
	if self.stateComponent.CurrentStateName == "SKILL" then
		self.stateComponent:ChangeState("IDLE")
	end
}

[Client Only]
void CalcCoolTime()
{
	self.remainCoolTime = self.skillCoolTime
	self.isSkillReady = false
	local coolTimer = 0
	local CheckCoolTime = function()
		if self.remainCoolTime <= 0 then 
			_TimerService:ClearTimer(coolTimer)
			self.isSkillReady = true 
		end
		self.remainCoolTime = self.remainCoolTime - 1
		end
	coolTimer = _TimerService:SetTimerRepeat(CheckCoolTime, 0.1, 0.1)
}

[Server]
void EnableBuff(Entity player)
{
	self:CalcDuration(player, player.Name)
}

[Server]
void DisableBuff(Entity player)
{
	
}

[Client]
void CalcDuration(Entity player)
{
	if self.remainDuration > 0 then
		self:DisableBuff(player)
		self.remainDuration = self.skillDuration
	end
	self.remainDuration = self.skillDuration
	_TimerService:ClearTimer(self.buffTimer)
	local CheckDuration = function()
		if self.remainDuration <= 0 then 
			_TimerService:ClearTimer(self.buffTimer) 
			self:DisableBuff(player)
		end
		self.remainDuration = self.remainDuration - 1
	end
	self.buffTimer = _TimerService:SetTimerRepeat(CheckDuration, 0.1, 0.1)
}


--Events--

