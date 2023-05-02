--Properties--

Entity target
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.BossAIComponent:SetPlayer()
	
	if self.BossAIComponent.target ~= nil then
		self.target = self.BossAIComponent.target
	end
}

[Default]
any OnBehave(number delta)
{
	
	if self.target == nil then
		self.BossAIComponent:SetPlayer()
		return BehaviourTreeStatus.Failure
	end
	
	return BehaviourTreeStatus.Success
}


--Events--

