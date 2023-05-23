--Properties--

string skillName = ""
Component playerComponent
Component stateComponent
Component hitComponent
table coefficient
table upChargeRate
number startDelay = 0
number totalDelay = 0
table attackSize
table attackOffset
number remainCoolTime = 0
number skillCoolTime = 0
integer mpConsumption = 0
table effectRUID
table hitEffectRUID
table soundRUID
table hitSoundRUID


--Methods--

[Default]
void OnBeginPlay()
{
	
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" or self.remainCoolTime > 0 or self.playerComponent.Mp < self.mpConsumption then return end
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
void UseSkillServer(Entity player)
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
	local coolTimer = 0
	local CheckCoolTime = function()
		if self.remainCoolTime <= 0 then _TimerService:ClearTimer(coolTimer) end
		self.remainCoolTime = self.remainCoolTime - 0.1
		log(self.remainCoolTime)
		end
	coolTimer = _TimerService:SetTimerRepeat(CheckCoolTime, 0.1, 0.1)
}


--Events--

