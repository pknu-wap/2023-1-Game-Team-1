--Properties--

Component BossComponent
Component BossAIComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
}

[Server Only]
void teleport()
{
	
	local targetTransform = self.BossAIComponent.target.TransformComponent.Position
		
	self.BossComponent.BossMovementComponent:SetPosition(Vector2(targetTransform.x, targetTransform.y))
	
	local atatckBox = function()
		local attackSize = Vector2(1, 1)
		local attackOffset = Vector2(0, 0)
		
		self:Attack(attackSize, attackOffset, nil)
	end
	
	_TimerService:SetTimerOnce(atatckBox, 0.3)
}

[Default]
void AttackStateTimer(number timer)
{
	local changeAttackState = function()
		self.BossComponent.attackEnd = true
	end
	
	_TimerService:SetTimerOnce(changeAttackState, timer)
}


--Events--

[Default]
HandleStump_Pattern_Event(Stump_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	log("스텀프 패턴 이벤트 발생 "..PtNo)
	
	if self.BossComponent.InRange then
		if PtNo >= 0 and PtNo <= 9 then
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo >= 5 and PtNo <= 7 then
			self.BossComponent.stateComponent:ChangeState("ATTACK2")
		elseif PtNo >= 8 and PtNo <= 9 then
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		end
		
		self:AttackStateTimer(3)
	else
		if PtNo >= 0 and PtNo <= 9 then
			--self:teleport()
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(3)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		end
	end
}

