--Properties--

Component BossComponent
Component BossAIComponent
number speed = 0.5
string attackName = ""
Component StateAnimationComponent
string curState = ""
boolean isChangeState = false
number fireOnSerial = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
	
	self.BossAIComponent.detectDistance = 1
	
	self.BossComponent.stateComponent:AddState("CHASE", chase)
	self.BossComponent.stateComponent:AddState("skill", attack1)
	
	self.Entity.MovementComponent.InputSpeed = self.speed
	self.StateAnimationComponent = self.Entity.StateAnimationComponent
	
	self.curState = "스톤골렘"
	self:StoneGolemState()
	
	_TimerService:SetTimerOnce(function() self.isChangeState = true end, 30)
}

[Server Only]
void OnUpdate(number delta)
{
	if self.curState == "파이어골렘" then
		
	else
		
	end
}

[Default]
void AttackStateTimer(number timer)
{
	local changeAttackState = function()
		log("어택 끝입니다")
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
void ChangeState()
{
	math.randomseed(os.time())
	local randomNum = math.random(1, 2)
	
	if self.curState == "스톤골렘" then
		if randomNum == 1 then
			self:IceGolemState()
		elseif randomNum == 2 then
			self:FireGolemState()
		end
	elseif self.curState == "아이스골렘" then
		if randomNum == 1 then
			self:StoneGolemState()
		elseif randomNum == 2 then
			self:FireGolemState()
		end
	elseif self.curState == "파이어골렘" then
		--log("제거할래요!! " ..self.fireOnSerial)
		--_EffectService:RemoveEffect(self.fireOnSerial)
		if randomNum == 1 then
			self:StoneGolemState()
		elseif randomNum == 2 then
			self:IceGolemState()
		end
	end
	
	self:AttackStateTimer(0.1)
	_TimerService:SetTimerOnce(function() self.isChangeState = true end, 10)
}

[Default]
void StoneGolemState()
{
	log("스톤골렘 상태")
	self.curState = "스톤골렘"
	self.StateAnimationComponent:RemoveActionSheet("move")
	self.StateAnimationComponent:RemoveActionSheet("stand")
	self.StateAnimationComponent:RemoveActionSheet("skill")
	self.StateAnimationComponent:RemoveActionSheet("die")
	self.StateAnimationComponent:RemoveActionSheet("chase")
	
	self.StateAnimationComponent:SetActionSheet("move", "9477f9f02afc4b92b46499e88f6fc472")
	self.StateAnimationComponent:SetActionSheet("stand", "35b81333e60440c99196851e1de5d990")
	self.StateAnimationComponent:SetActionSheet("skill", "192cf926eeb84448aa62b52759d7c462")
	self.StateAnimationComponent:SetActionSheet("die", "fde5d2f6f09e4f3a831b57c6104d3c06")
	self.StateAnimationComponent:SetActionSheet("chase", "9477f9f02afc4b92b46499e88f6fc472")
}

[Default]
void IceGolemState()
{
	log("아이스골렘 상태")
	self.curState = "아이스골렘"
	self.StateAnimationComponent:RemoveActionSheet("move")
	self.StateAnimationComponent:RemoveActionSheet("stand")
	self.StateAnimationComponent:RemoveActionSheet("skill")
	self.StateAnimationComponent:RemoveActionSheet("die")
	self.StateAnimationComponent:RemoveActionSheet("chase")
	
	self.StateAnimationComponent:SetActionSheet("move", "93e645dcfa1d4b8cadf3c64240f40eba")
	self.StateAnimationComponent:SetActionSheet("stand", "3faa2c0a65754f14b4de57c76bffde8b")
	self.StateAnimationComponent:SetActionSheet("skill", "7745782e2d504c3ca2aea25261884244")
	self.StateAnimationComponent:SetActionSheet("die", "5540ed61e8d84d3bb9a2b338bc2b5623")
	self.StateAnimationComponent:SetActionSheet("chase", "93e645dcfa1d4b8cadf3c64240f40eba")
}

[Default]
void FireGolemState()
{
	log("파이어골렘 상태")
	self.curState = "파이어골렘"
	
	self.StateAnimationComponent:RemoveActionSheet("move")
	self.StateAnimationComponent:RemoveActionSheet("stand")
	self.StateAnimationComponent:RemoveActionSheet("skill")
	self.StateAnimationComponent:RemoveActionSheet("die")
	self.StateAnimationComponent:RemoveActionSheet("chase")
	
	self.StateAnimationComponent:SetActionSheet("move", "ab541ad30d4a409484377dfe112740af")
	self.StateAnimationComponent:SetActionSheet("stand", "c2a3c3ba031440c9bb41884706d71ebc")
	self.StateAnimationComponent:SetActionSheet("skill", "3ed454eeff394d3f8db37bb80a553aa7")
	self.StateAnimationComponent:SetActionSheet("die", "7a5f84d6172f41ee99290d3ab87b8c30")
	self.StateAnimationComponent:SetActionSheet("chase", "ab541ad30d4a409484377dfe112740af")
	
	--if self.fireOnSerial ~= _EffectService:PlayEffectAttached("5596e3b3188b4cbb926e9dc28db223f5", self.Entity, Vector3.zero, 0, Vector3.one, true)	then
	--	self.fireOnSerial = _EffectService:PlayEffectAttached("5596e3b3188b4cbb926e9dc28db223f5", self.Entity, Vector3.zero, 0, Vector3.one, true)
	--	log(self.fireOnSerial .."파이어 번호!")
	--end
}

[Default]
void StoneGolemAttack(number PtNo)
{
	-- -9 ~ 8
	self.BossComponent.stateComponent:ChangeState("SKILL")
	
	for i = 1, 9 do
		local randomNum = math.random()
		if randomNum <= 0.5 then
			local spawnPos = Vector3(-10 +(i*2), 6, 1)
			
			_SpawnService:SpawnByModelId("model://797e2c75-988c-4f6d-8eb8-bcb553668b45", "FallStone", spawnPos, self.Entity.Parent)
		end
	end
	
	self:AttackStateTimer(2.7)
}

[Default]
void IceGolemAttack(number PtNo)
{
	self.BossComponent.stateComponent:ChangeState("SKILL")
	
	if PtNo < 5 then
		if self.BossComponent.BossTransformComponent.Scale.x < 0 then
			local startPos = self.BossComponent.BossTransformComponent.Position + Vector3(1, 0, 0)
			
			while(startPos.x < 8) do
				_SpawnService:SpawnByModelId("model://eaceb758-e0af-4dea-bcc9-0e9367f72b69", "Ice", startPos, self.Entity.Parent)
				startPos = startPos + Vector3(0.5, 0, 0)
			end
		else
			local startPos = self.BossComponent.BossTransformComponent.Position + Vector3(-1, 0, 0)
			
			while(startPos.x > -9.5) do
				_SpawnService:SpawnByModelId("model://eaceb758-e0af-4dea-bcc9-0e9367f72b69", "Ice", startPos, self.Entity.Parent)
				startPos = startPos + Vector3(-0.5, 0, 0)
			end
		end
		self:AttackStateTimer(3.42)
	else
		local pos = Vector3.zero
		
		if self.BossComponent.BossTransformComponent.Scale.x < 0 then
			pos = Vector3(self.BossComponent.BossTransformComponent.Position.x+0.5, self.BossComponent.BossTransformComponent.Position.y + 0.45, self.BossComponent.BossTransformComponent.Position.z)
		else
			pos = Vector3(self.BossComponent.BossTransformComponent.Position.x-0.5, self.BossComponent.BossTransformComponent.Position.y + 0.45, self.BossComponent.BossTransformComponent.Position.z)
		end
		
		_SpawnService:SpawnByModelId("model://0552d888-ab72-4931-9c3f-3cdabea2d64c", "icebolt" ,pos, self.Entity.Parent)
		
		self:AttackStateTimer(1.14)
	end
}

[Default]
void FireGolemAttack(number PtNo)
{
	self.BossComponent.stateComponent:ChangeState("SKILL")
	
	for i = 1,3 do
		local randomNum = math.random(-9, 8)
		
		local pos = Vector3(randomNum, -0.2, 0)
		
		_SpawnService:SpawnByModelId("model://67887212-d8fb-4acc-aa35-2b9a14d1cd87", "meteor", pos, self.Entity.Parent)
	end
	
	self:AttackStateTimer(3.42)
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


--Events--

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
	--log("골렘 스테이트" ..CurrentStateName ..PrevStateName)
}

[Default]
HandleGolem_Pattern_Event(Golem_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	log("PtNo : " ..PtNo)
	if self.isChangeState == true then
		self.isChangeState = false
		self:ChangeState()
	else
		if self.curState == "스톤골렘" then
			self:StoneGolemAttack(PtNo)
		elseif self.curState == "아이스골렘" then
			self:IceGolemAttack(PtNo)
		elseif self.curState == "파이어골렘" then
			self:FireGolemAttack(PtNo)
		end
	end
	
}

[Default]
HandlePattern_Event(Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	log("PtNo : " ..PtNo)
	if self.isChangeState == true then
		self.isChangeState = false
		self:ChangeState()
	else
		if self.curState == "스톤골렘" then
			self:StoneGolemAttack(PtNo)
		elseif self.curState == "아이스골렘" then
			self:IceGolemAttack(PtNo)
		elseif self.curState == "파이어골렘" then
			self:FireGolemAttack(PtNo)
		end
	end
}

