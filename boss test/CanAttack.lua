--Properties--

Entity target
number time = 0
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	local bossAiComponent = self.ParentAI.Entity.BossAIComponent
	if isvalid(bossAiComponent) then
		log("boss컴포넌트 획득")
	end
	
	self.BossAIComponent:SetPlayer()
	
	self.time = _UtilLogic:RandomDouble() * 3
}

[Default]
any OnBehave(number delta)
{
	log("CanAttack 실행")
	if self.target == nil then
		log("CanAttack 플레이어 찾을 수 없음")
		return BehaviourTreeStatus.Failure
	end	
	return BehaviourTreeStatus.Failure
}


--Events--

