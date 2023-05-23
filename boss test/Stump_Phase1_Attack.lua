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
	
	self.BossAIComponent.detectDistance = 3
	
	self.BossComponent.stateComponent:AddState("CHASE", chase)
	self.BossComponent.stateComponent:AddState("ATTACK1", attack1)
	self.BossComponent.stateComponent:AddState("ATTACK2", attack2)
	self.BossComponent.stateComponent:AddState("ATTACK3", attack3)
	self.Entity.MovementComponent.InputSpeed = self.speed
}

[Default]
void AttackStateTimer(number timer)
{
	local changeAttackState = function()
		self.BossComponent.attackEnd = true
		self.attackName = ""
	end
	
	_TimerService:SetTimerOnce(changeAttackState, timer)
}

[Default]
void NormalAttack()
{
	local atatckBox = function()
		local attackSize = Vector2(1, 1)
		local attackOffset = Vector2(0, 0)
		
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
		
		_EffectService:PlayEffect("04743802a02744fba86f57e49302490f", self.Entity, Vector3(self.BossComponent.BossTransformComponent.Position.x, self.BossComponent.BossTransformComponent.Position.y, self.BossComponent.BossTransformComponent.Position.z), 0, Vector3.one, false)
		
		local mountBox = function()
			local mountAttackSize = Vector2(8.8,10)
			
			self:Attack(mountAttackSize, Vector2.zero, nil, CollisionGroups.Player)
		end
		
		_TimerService:SetTimerOnce(mountBox, 0.9)
	end
	
	_TimerService:SetTimerOnce(atatckBox, 1.35)
}

[Default]
void SpawnBat()
{
	local pos = Vector3.zero
	if self.BossComponent.BossTransformComponent.Scale.x < 0 then
		pos = Vector3(self.BossComponent.BossTransformComponent.Position.x+0.5, self.BossComponent.BossTransformComponent.Position.y, self.BossComponent.BossTransformComponent.Position.z)
	else
		pos = Vector3(self.BossComponent.BossTransformComponent.Position.x-0.5, self.BossComponent.BossTransformComponent.Position.y, self.BossComponent.BossTransformComponent.Position.z)
	end
	
	_SpawnService:SpawnByModelId("model://f8e9cb0d-b176-437c-8cae-5aa15a03a3ea", "bat" ,pos, self.Entity.Parent)
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
void SpawnSpirit()
{
	local count = math.random(2, 4)
	for i = 0, count do
		local randomX = math.random(-10, 10)
		local transformComponent = self.Entity.TransformComponent
		_SpawnService:SpawnByModelId("model://e99a1e62-e9a4-41ad-baa6-55a531df04e1", "spirit", Vector3(transformComponent.Position.x + randomX, transformComponent.Position.y , transformComponent.Position.z), self.Entity.Parent)
	end
}

[Default]
void SpawnExplosionStone()
{
	local transform = self.BossAIComponent.target.TransformComponent
	
	_SpawnService:SpawnByModelId("model://81f059a4-e74d-4d59-bca3-dc9a41faf888", "BoomStone", Vector3(transform.Position.x, -0.8, transform.Position.z), self.Entity.Parent)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if self.attackName == "teleport" then
		return 500
	elseif self.attackName == "normal" then
		return 200
	end
	
	return __base:CalcDamage(attacker,defender,attackInfo)
}

[Server]
void SpawnPhase2()
{
	local transformComponent = self.Entity.TransformComponent
	
	_SpawnService:SpawnByModelId("model://c7799eb9-b4be-4128-bd5a-093f3193e268", "Boss_Stump_Phase2", Vector3(transformComponent.Position.x, transformComponent.Position.y, transformComponent.Position.z), self.Entity.Parent)
	self.Entity:Destroy()
}


--Events--

[Default]
HandleStump_Pattern_Event(Stump_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	
	if self.BossComponent.InRange then
		if PtNo >= 0 and PtNo <= 5 then
			self.attackName = "normal"
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
			self:NormalAttack()
		elseif PtNo >= 6 and PtNo <= 8 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 9 then
			self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		end
		
		self:AttackStateTimer(3)
	else
		if PtNo == 0 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo > 0 and PtNo <= 3 then
			--self:teleport()
			self.attackName = "teleport"
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(3)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo > 3 and PtNo <= 6 then
			self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		elseif PtNo > 6 then
			self.attackName = "BoomStone"
			_TimerService:SetTimerOnce(function() self:SpawnExplosionStone() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		end
	end
}

[Default]
HandleStateChangeEvent(StateChangeEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: StateComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local CurrentStateName = event.CurrentStateName
	local PrevStateName = event.PrevStateName
	---------------------------------------------------------
	if CurrentStateName == "DEAD" then
		local transformComponent = self.Entity.TransformComponent
	
		local spawnEffect = function()
			local pos = Vector3(transformComponent.Position.x, transformComponent.Position.y+1, transformComponent.Position.z)
			_EffectService:PlayEffect("03a9f80819c542fe8e2ec00d2d763651", self.Entity, pos, 0, Vector3.one*3, false)
			_TimerService:SetTimerOnce(function() self:SpawnPhase2() end, 2)
		end
		
		_TimerService:SetTimerOnce(spawnEffect, 1.8)
	end
}

[Default]
HandlePattern_Event(Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	if self.BossComponent.InRange then
		if PtNo >= 0 and PtNo <= 5 then
			self.attackName = "normal"
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
			self:NormalAttack()
		elseif PtNo >= 6 and PtNo <= 8 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 9 then
			self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		end
		
		self:AttackStateTimer(3)
	else
		if PtNo == 0 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo > 0 and PtNo <= 3 then
			--self:teleport()
			self.attackName = "teleport"
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(3)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo > 3 and PtNo <= 6 then
			self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		elseif PtNo > 6 then
			self.attackName = "BoomStone"
			_TimerService:SetTimerOnce(function() self:SpawnExplosionStone() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(3)
		end
	end
}

