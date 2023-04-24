--Properties--

Entity target
Component BossAIComponent


--Methods--

[Default]
void OnInit()
{
	--local bossAiComponent = self.ParentAI.Entity.BossAIComponent
	if isvalid(self.BossAIComponent) then
		log("CanAttack boss컴포넌트 획득")
	end
	
	self.BossAIComponent:SetPlayer()
	
	if self.BossAIComponent.target ~= nil then
		self.target = self.BossAIComponent.target
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
		log("타겟 nil")
		return BehaviourTreeStatus.Failure
	end
	
	log("CanAttack 플레이어 찾음 " ..self.target.Name)
	
	return BehaviourTreeStatus.Success
}


--Events--

