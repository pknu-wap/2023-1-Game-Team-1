--Properties--

number PtNo = 0
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.BossAIComponent = self.ParentAI.Entity.BossAIComponent
	self.ExclusiveExecutionWhenRunning = true
	log("패턴 들어가기전 스텀프 상태" ..self.BossAIComponent.BossComponent.stateComponent.CurrentStateName)
}

[Default]
any OnBehave(number delta)
{
	--log("PtNo : 성공 ")-- ..self.PtNo)
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "DEAD" then
		log("보스 죽음")
		return BehaviourTreeStatus.Failure
	end
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName ~= "CHASE" then
		log("움직이지 않습니다 " ..self.BossAIComponent.BossComponent.stateComponent.CurrentStateName )
		return BehaviourTreeStatus.Failure
	end
	
	local event = Stump_Pattern_Event()
	
	event.PtNo = self.PtNo
	
	self.ParentAI.Entity:SendEvent(event)
	
	return BehaviourTreeStatus.Success
}


--Events--

