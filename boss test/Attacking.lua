--Properties--

Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.ExclusiveExecutionWhenRunning = true
	self.BossAIComponent.BossComponent.attackEnd = false
}

[Default]
any OnBehave(number delta)
{
	if self.BossAIComponent.BossComponent.attackEnd == false then
		return BehaviourTreeStatus.Running
	else
		self.BossAIComponent.BossComponent.stateComponent:ChangeState("IDLE")
		return BehaviourTreeStatus.Success
	end
}


--Events--

