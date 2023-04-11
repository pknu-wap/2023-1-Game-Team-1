--Properties--

Entity player
number time = 0


--Methods--

[Default]
any OnBehave(number delta)
{
	log("CanAttack 실행")
	if self.player == nil then
		log("CanAttack 플레이어 찾을 수 없음")
		return BehaviourTreeStatus.Failure
	end	
	return BehaviourTreeStatus.Failure
}

[Default]
void OnInit()
{
	self.ParentAI.Entity.BossAIComponent:SetPlayer()
	
	self.time = _UtilLogic:RandomDouble() * 3
}


--Events--

