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
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "DEAD" then
		log("보스 죽음")
		return BehaviourTreeStatus.Failure
	end
	if self.target == nil then
		log("CanAttack 안댐" ..self.ParentAI.Entity.Name)
		return BehaviourTreeStatus.Failure
	end
	
	return BehaviourTreeStatus.Success
}


--Events--

