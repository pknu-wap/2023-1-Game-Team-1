--Properties--

number time = 0
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.time = 5
	self.ExclusiveExecutionWhenRunning = true
	self.BossAIComponent.BossComponent.attackEnd = false
}

[Default]
any OnBehave(number delta)
{
	self.time = self.time - delta
	
	if self.BossAIComponent.BossComponent.attackEnd == false then
		return BehaviourTreeStatus.Running
	else
		self.BossAIComponent.BossComponent.attackEnd = true
		self.BossAIComponent.BossComponent.stateComponent:ChangeState("IDLE")
		return BehaviourTreeStatus.Success
	end
}


--Events--

