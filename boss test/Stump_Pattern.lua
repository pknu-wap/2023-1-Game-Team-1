--Properties--

number PtNo = 0


--Methods--

[Default]
any OnBehave(number delta)
{
	log("PtNo : 성공")
	if self.ParentAI.Entity.StateComponent.CurrentStateName ~= "MOVE" then
		log("움직이지 않습니다")
		return BehaviourTreeStatus.Failure
	end
	
	return BehaviourTreeStatus.Success
}


--Events--

