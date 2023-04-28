--Properties--

number PtNo = 0
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	self.ExclusiveExecutionWhenRunning = true
}

[Default]
any OnBehave(number delta)
{
	--log("PtNo : 성공 ")-- ..self.PtNo)
	if self.ParentAI.Entity.StateComponent.CurrentStateName ~= "CHASE" then
		log("움직이지 않습니다")
		return BehaviourTreeStatus.Failure
	end
	
	local event = Stump_Pattern_Event()
	
	event.PtNo = self.PtNo
	
	self.ParentAI.Entity:SendEvent(event)
	
	return BehaviourTreeStatus.Success
}


--Events--

