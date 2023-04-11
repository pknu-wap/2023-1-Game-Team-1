--Properties--

any Child = nil
Entity player


--Methods--

[Default]
any OnBehave(number delta)
{
	log("Checker 실행")
	local BossComponent = self.ParentAI.Entity.Boss
	
	if BossComponent.Hp <= 0 then
		log("보스 피 없따")
		return BehaviourTreeStatus.Failure
	end
	
	log("보스 피 있다")
	
	return BehaviourTreeStatus.Success
}

[Default]
void OnInit()
{
	if self.player == nil then
		log("Checker 플레이어 셋")
		local bossAIcomponent = self.ParentAI.Entity.BossAIComponent
		bossAIcomponent:SetPlayer()
		
		self.player = bossAIcomponent.player 
		
	end
}


--Events--

