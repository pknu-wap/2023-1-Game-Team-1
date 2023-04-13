--Properties--

Entity target
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
	
	if bossAiComponent.target ~= nil then
		self.target = bossAiComponent.target
	end
	
	if self.target ~= nil then
		log("타겟 설정 완료! Can Attack 의 타겟 네임 : " ..self.target.Name)
	end
}

[Default]
any OnBehave(number delta)
{
	log("CanAttack 실행")
	if self.target == nil then
		log("CanAttack 플레이어 찾을 수 없음")
		return BehaviourTreeStatus.Failure
	end	
	
	log("CanAttack 플레이어 찾음 " ..self.target.Name)
	return BehaviourTreeStatus.Success
}


--Events--

