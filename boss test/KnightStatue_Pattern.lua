--Properties--

number PtNo = 0
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.BossAIComponent = self.ParentAI.Entity.BossAIComponent
	self.ExclusiveExecutionWhenRunning = true
}

[Default]
any OnBehave(number delta)
{
	--log("PtNo : 성공 ")-- ..self.PtNo)
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "DEAD" then
		log("보스 죽음")
		return BehaviourTreeStatus.Failure
	end
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "CHASE" or self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "HIT" then
		local event = KnightStatue_Pattern_Event()
	
		event.PtNo = self.PtNo
		
		self.ParentAI.Entity:SendEvent(event)
		
		return BehaviourTreeStatus.Success
	else
		log("움직이지 않습니다 " ..self.BossAIComponent.BossComponent.stateComponent.CurrentStateName )
		return BehaviourTreeStatus.Failure
	end
}


--Events--
