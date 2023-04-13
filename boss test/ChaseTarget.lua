--Properties--

Entity target
Component targetTransform
Component BossAIComponent
Component BossTransform
number time = 0


--Methods--

[Default]
void OnInit()
{
	log("ChaseTarget 의 시작입니다!")
	self.target = self.ParentAI.Entity.BossAIComponent.target
	self.targetTransform = self.target.TransformComponent
	
	self.BossTransform = self.ParentAI.Entity.TransformComponent
	
	self.time = _UtilLogic:RandomDouble() * 3
	
	ChaseTarget().ExclusiveExecutionWhenRunning = true
}

[Default]
any OnBehave(number delta)
{
	if not _EntityService:IsValid(self.target) then
		log("ChaseTarget 실패!")
		return BehaviourTreeStatus.Failure
	end
	
	local dir = self.targetTransform.Position - self.BossTransform.Position
	dir.z = 0
	
	log("거리 " ..dir.x .." " ..self.BossTransform.Position.x .." " ..self.targetTransform.Position.x)
	self.BossTransform.Position = self.BossTransform.Position + Vector3.Normalize(dir) * delta
	self.BossTransform.Scale.x = dir.x > 0 and -1 or 1
	
	log("쫓아가는 중....")
	return BehaviourTreeStatus.Running
}


--Events--

