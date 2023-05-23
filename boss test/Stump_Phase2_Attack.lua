--Properties--

Component BossComponent
Component BossAIComponent
number speed = 0.5
string attackName = ""
number damage = 1
boolean canSpecial = true


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
	
	self.BossComponent.MaxHp = 201
	self.BossComponent.Hp = self.BossComponent.MaxHp
	
	self.BossAIComponent.detectDistance = 3
	
	self.BossComponent.stateComponent:AddState("Chase", chase)
	self.BossComponent.stateComponent:AddState("ATTACK1", attack1)
	self.BossComponent.stateComponent:AddState("ATTACK2", attack2)
	self.BossComponent.stateComponent:AddState("ATTACK3", attack3)
	self.BossComponent.stateComponent:AddState("ATTACK4", attack4)
	self.BossComponent.stateComponent:AddState("ATTACK5", attack5)
	self.BossComponent.stateComponent:AddState("ATTACK6", attack6)
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
	
	_TimerService:SetTimerOnce(atatckBox, 1.2)
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
		local attackSize = Vector2(3.6, 2)
		local attackOffset = Vector2(0, 0)
		
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(atatckBox, 0.3)
}

[Default]
void SpawnSpirit()
{
	local count = math.random(5, 10)
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
void Heal()
{
	local curHp = self.BossComponent.Hp
	
	curHp = curHp+1000
	
	if curHp > self.BossComponent.MaxHp then
		curHp = self.BossComponent.MaxHp
	end 
	
	self.BossComponent.Hp = curHp
}

[Default]
void Breath()
{
	local breathAttack = function()
		local attackSize = Vector2(5, 2)
		local attackOffset
		if self.BossComponent.BossTransformComponent.Scale.x < 0 then
			attackOffset = Vector2(2.5, 0.8)
		else
			attackOffset = Vector2(-2.5, 0.8)
		end
			
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(breathAttack, 1.32)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return self.damage
}

[Default]
void SpecialAttack()
{
	_EffectService:PlayEffect("0500c2f8c29d45ec80b517396e263b66", self.Entity, Vector3.zero, 0, Vector3.one*5, false)
	
	local SpecialAttack = function()
		local attackSize = Vector2(100,20)
		local attackOffset = Vector2.zero
		
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(SpecialAttack, 2.25)
}


--Events--

[Default]
HandleStump_Pattern_Event(Stump_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	if self.BossComponent.Hp < self.BossComponent.MaxHp/2 and self.canSpecial == true then
		self:SpecialAttack()
		self.damage = 1000
		self:AttackStateTimer(2.6)
		
		self.canSpecial = false
		
		_TimerService:SetTimerOnce(function() self.canSpecial = true end, 300)
		goto skip_attack
	end
	
	if self.BossComponent.InRange then
		if PtNo >= 0 and PtNo <= 3 then
			--self.attackName = "normal"
			self.damage = 200
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
			self:NormalAttack()
			self:AttackStateTimer(2.7)
		elseif PtNo > 3 and PtNo < 6 then
			--self.attackName = "breath"
			self.damage = 500
			self.BossComponent.stateComponent:ChangeState("ATTACK2")
			self:Breath()
			self:AttackStateTimer(2.1)
		elseif PtNo >= 6 and PtNo <= 8 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.5)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 9 then
			--self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK6")
			self:AttackStateTimer(2.5)
		end
	else
		if PtNo == 0 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.5)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 1 and PtNo <= 3 then
			--self.attackName = "teleport"
			self.damage = 500
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo == 4 then
			self:Heal()
			self:AttackStateTimer(2.6)
			self.BossComponent.stateComponent:ChangeState("ATTACK5")
		elseif PtNo > 4 and PtNo <= 6 then
			--self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK6")
			self:AttackStateTimer(2.5)
		elseif PtNo > 6 then
			--self.attackName = "BoomStone"
			_TimerService:SetTimerOnce(function() self:SpawnExplosionStone() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(2.5)
		end
	end
	::skip_attack::
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
		log("클리어")
		self.Entity:Destroy()
	end
}

[Default]
HandlePattern_Event(Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	if self.BossComponent.Hp < self.BossComponent.MaxHp/2 and self.canSpecial == true then
		self:SpecialAttack()
		self.damage = 1000
		self:AttackStateTimer(2.6)
		
		self.canSpecial = false
		
		_TimerService:SetTimerOnce(function() self.canSpecial = true end, 300)
		goto skip_attack
	end
	
	if self.BossComponent.InRange then
		if PtNo >= 0 and PtNo <= 3 then
			--self.attackName = "normal"
			self.damage = 200
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
			self:NormalAttack()
			self:AttackStateTimer(2.7)
		elseif PtNo > 3 and PtNo < 6 then
			--self.attackName = "breath"
			self.damage = 500
			self.BossComponent.stateComponent:ChangeState("ATTACK2")
			self:Breath()
			self:AttackStateTimer(2.1)
		elseif PtNo >= 6 and PtNo <= 8 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.5)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 9 then
			--self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK6")
			self:AttackStateTimer(2.5)
		end
	else
		if PtNo == 0 then
			_TimerService:SetTimerOnce(function() self:SpawnBat() end, 1.5)
			self:AttackStateTimer(2.5)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
		elseif PtNo >= 1 and PtNo <= 3 then
			--self.attackName = "teleport"
			self.damage = 500
			_TimerService:SetTimerOnce(function() self:teleport() end, 0.9)
			self:AttackStateTimer(2.7)
			self.BossComponent.stateComponent:ChangeState("ATTACK1")
		elseif PtNo == 4 then
			self:Heal()
			self:AttackStateTimer(2.6)
			self.BossComponent.stateComponent:ChangeState("ATTACK5")
		elseif PtNo > 4 and PtNo <= 6 then
			--self.attackName = "spawnSpirit"
			_TimerService:SetTimerOnce(function() self:SpawnSpirit() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK6")
			self:AttackStateTimer(2.5)
		elseif PtNo > 6 then
			--self.attackName = "BoomStone"
			_TimerService:SetTimerOnce(function() self:SpawnExplosionStone() end, 0.9)
			self.BossComponent.stateComponent:ChangeState("ATTACK3")
			self:AttackStateTimer(2.5)
		end
	end
	::skip_attack::
}

