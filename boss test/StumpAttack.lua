--Properties--

Component BossComponent
Component BossAIComponent
number speed = 0.5
string attackName = ""


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
	
	self.BossComponent.stateComponent:AddState("Chase")
	self.BossComponent.stateComponent:AddState("ATTACK1")
	self.BossComponent.stateComponent:AddState("ATTACK2")
	self.BossComponent.stateComponent:AddState("ATTACK3")
	self.Entity.MovementComponent.InputSpeed = self.speed
}

[Server Only]
void teleport()
{
	
	local targetTransform = self.BossAIComponent.target.TransformComponent.Position
	
	self.BossComponent.BossMovementComponent:SetPosition(Vector2(targetTransform.x, self.BossComponent.BossTransformComponent.Position.y))
	
	local atatckBox = function()
		local attackSize = Vector2(1, 0.1)
		local attackOffset = Vector2(0, 0)
		
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(atatckBox, 0.6)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if self.attackName == "teleport" then
		return 500
	end
	
	return __base:CalcDamage(attacker,defender,attackInfo)
}

[Default]
void AttackStateTimer(number timer)
{
	local changeAttackState = function()
		self.BossComponent.attackEnd = true
	end
	
	_TimerService:SetTimerOnce(changeAttackState, timer)
}

[Default]
void SpawnSpirit()
{
	local count = math.random(5, 10)
	for i = 0, count do
		local randomX = math.random(-10, 10)
		local transformComponent = self.Entity.TransformComponent
		_SpawnService:SpawnByModelId("model://e99a1e62-e9a4-41ad-baa6-55a531df04e1", "spirit", Vector3(transformComponent.Position.x + randomX, transformComponent.Position.y + 0.5, transformComponent.Position.z), self.Entity.Parent)
	end
}

[Default]
void SpawnExplosionStone()
{
	local transform = self.BossAIComponent.target.TransformComponent
	
	_SpawnService:SpawnByModelId("model://81f059a4-e74d-4d59-bca3-dc9a41faf888", "BoomStone", Vector3(transform.Position.x, -0.8, transform.Position.z), self.Entity.Parent)
}


--Events--

[Default]
HandleStump_Pattern_Event(Stump_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	
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
		PtNo = 5
		if PtNo >= 0 and PtNo <= 2 then
			--self:teleport()
			self.attackName = "teleport"
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(3)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo > 2 and PtNo <= 4 then
			self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		elseif PtNo > 4 then
			self.attackName = "BoomStone"
			_TimerService:SetTimerOnce(function() self:SpawnExplosionStone() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		end
	end
}

