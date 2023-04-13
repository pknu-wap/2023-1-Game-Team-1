--Properties--

Entity target
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.target = self.ParentAI.Entity.BossAIComponent.target
}

[Default]
any OnBehave(number delta)
{
	return BehaviourTreeStatus.Failure
}


--Events--

