--Properties--

string skillName = ""
Component playerComponent
Component stateComponent
Component rigidbodyComponent
Component controllerComponent
Component hitComponent
number dashForce = 0
number jumpForce = 0
number remainCoolTime = 0
number skillCoolTime = 0
number startDelay = 0
number totalDelay = 0
table effectRUID
table soundRUID


--Methods--

[Default]
void OnBeginPlay()
{
	
}

[Client]
void PreSkill()
{
	if self.stateComponent.CurrentStateName ~= "IDLE" and self.stateComponent.CurrentStateName ~= "MOVE" and self.stateComponent.CurrentStateName ~= "ATTACK_WAIT" 
		and self.stateComponent.CurrentStateName ~= "FALL" and self.stateComponent.CurrentStateName ~= "JUMP" or self.remainCoolTime > 0 then return end
	self:CalcCoolTime()
	self.hitComponent.skillTimer1 = _TimerService:SetTimerOnce(self.UseSkillClient, self.startDelay)
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
		self.remainCoolTime = self.remainCoolTime - 1
		end
	coolTimer = _TimerService:SetTimerRepeat(CheckCoolTime, 0.1, 0.1)
}

[Client]
number GetRemainCoolTime()
{
	return self.remainCoolTime
}


--Events--

