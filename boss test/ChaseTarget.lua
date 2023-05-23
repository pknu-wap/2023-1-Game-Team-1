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
	self.target = self.ParentAI.Entity.BossAIComponent.target
	self.targetTransform = self.target.TransformComponent
	
	self.BossTransform = self.ParentAI.Entity.TransformComponent
	self.ExclusiveExecutionWhenRunning = true
	
	self.time = _UtilLogic:RandomDouble() * 3
	self.BossAIComponent.BossComponent.stateComponent:ChangeState("CHASE")
	self.BossAIComponent.BossComponent.BossMovementComponent.InputSpeed = self.BossAIComponent.BossComponent.speed
	self.BossAIComponent.BossComponent.InRange = false
	
	ChaseTarget().ExclusiveExecutionWhenRunning = true
	log("CHase시작한다" ..self.BossAIComponent.BossComponent.stateComponent.CurrentStateName)
}

[Default]
any OnBehave(number delta)
{
	if not _EntityService:IsValid(self.target) then
		log("ChaseTarget 실패!")
		self.BossAIComponent.BossComponent.stateComponent:ChangeState("IDLE")
		return BehaviourTreeStatus.Failure
	end
	if self.BossAIComponent.BossComponent.stateComponent.CurrentStateName == "DEAD" then
		log("보스 죽음")
		return BehaviourTreeStatus.Failure
	end
	
	local dir = self.targetTransform.Position - self.BossTransform.Position
	dir.z = 0
	dir.y = 0
	
	if self.BossAIComponent.BossComponent.speed ~= 0 then
		self.BossTransform.Scale.x = dir.x > 0 and -1 or 1
		self.BossAIComponent.BossComponent.BossMovementComponent:MoveToDirection(Vector2(dir.x, dir.y), delta)
	end
	
	self.time = self.time - delta
	--log("남은 추적 시간 " ..self.time)
	if math.abs(dir.x) < self.BossAIComponent.detectDistance then
		--log("타겟 범위 안")
		--self.ExclusiveExecutionWhenRunning = false
		self.BossAIComponent.BossComponent.InRange = true
		if self.time < 0 then
			self.BossAIComponent.BossComponent.BossMovementComponent.InputSpeed = 0
			return BehaviourTreeStatus.Success
		else
			return BehaviourTreeStatus.Running
		end
		
	elseif	self.time < 0 then
		--log("타겟 범위 밖 시간 오버")
		self.BossAIComponent.BossComponent.BossMovementComponent.InputSpeed = 0
		--self.ExclusiveExecutionWhenRunning = false
		self.BossAIComponent.BossComponent.InRange = false
		return BehaviourTreeStatus.Success
	end
	
	return BehaviourTreeStatus.Running
}


--Events--

