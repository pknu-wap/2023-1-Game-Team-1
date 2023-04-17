--Properties--

Entity target
Component targetTransform
Component BossAIComponent
Component BossTransform
number time = 0
number distance = 2


--Methods--

[Default]
void OnInit()
{
	log("ChaseTarget 의 시작입니다!")
	self.target = self.ParentAI.Entity.BossAIComponent.target
	self.targetTransform = self.target.TransformComponent
	
	self.BossTransform = self.ParentAI.Entity.TransformComponent
	
	self.time = _UtilLogic:RandomDouble() * 3
	self.BossAIComponent.BossComponent.stateComponent:ChangeState("CHASE")
	
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
	dir.y = 0
	
	log("거리 " ..dir.x .." " ..self.BossTransform.Position.x .." " ..self.targetTransform.Position.x)
	--self.BossTransform.Position = self.BossTransform.Position + Vector3.Normalize(dir)
	self.BossTransform.Scale.x = dir.x > 0 and -1 or 1
	
	self.BossAIComponent.BossComponent.BossMovementComponent:MoveToDirection(Vector2(dir.x, dir.y), delta)
	
	self.time = self.time - delta
	log("남은 추적 시간 " ..self.time)
	if math.abs(dir.x) < self.distance then
		log("타겟 범위 안")
		return BehaviourTreeStatus.Success
	
	elseif	self.time < 0 then
		log("타겟 범위 밖 시간 오버")
		return BehaviourTreeStatus.Success
	end
	
	log("쫓아가는 중...." ..self.ParentAI.Entity.StateComponent.CurrentStateName)
	return BehaviourTreeStatus.Running
}


--Events--

