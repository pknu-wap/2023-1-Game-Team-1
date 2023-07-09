--Properties--

Component BossComponent
Component BossAIComponent
number speed = 0
string attackName = ""
Component HitComponent
boolean godMode = false
number swordDamage = 0
number lazerDamage = 0
number waveDamage = 0
number boomDamage = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
	self.HitComponent = self.Entity.KnightStatue_HitComponent
	self.BossComponent.LastPhase = true
	
	if self.BossComponent.BossLevel == 1 then
		self.BossComponent.MaxHp = 5000 * 40
		self.BossComponent.Hp = self.BossComponent.MaxHp
		
		self.swordDamage = 200
		self.lazerDamage = 800
		self.waveDamage = 300
		self.boomDamage = 300
	elseif self.BossComponent.BossLevel == 2 then
		self.BossComponent.MaxHp = 25000
		self.BossComponent.Hp = self.BossComponent.MaxHp
		
		self.swordDamage = 1600
		self.lazerDamage = 10000
		self.waveDamage = 5000
		self.boomDamage = 7000
	elseif self.BossComponent.BossLevel == 3 then
		self.BossComponent.MaxHp = 75000
		self.BossComponent.Hp = self.BossComponent.MaxHp
		
		self.swordDamage = 5000
		self.lazerDamage = 200000
		self.waveDamage = 8000
		self.boomDamage = 12000
	end
	
	log("기사석상 데미지들 " ..self.swordDamage ..self.lazerDamage ..self.waveDamage)
	
	self.BossAIComponent.detectDistance = 2
	
	self.BossComponent.stateComponent:AddState("CHASE", chase)
	self.BossComponent.stateComponent:AddState("ATTACK1", attack1)
	self.BossComponent.stateComponent:AddState("ATTACK2", attack2)
	self.BossComponent.stateComponent:AddState("ATTACK3", attack3)
	self.BossComponent.stateComponent:AddState("ATTACK4", attack4)
	self.BossComponent.stateComponent:AddState("ATTACK5", attack5)
	self.BossComponent.stateComponent:AddState("HIT")
	
	self.Entity.MovementComponent.InputSpeed = self.speed
	self.BossComponent.speed = self.speed
	self.godMode = false
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
void GodTime()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK1")
	
	--local randomPosX = math.random(-6, 0)
	local pos = Vector3(0, self.BossComponent.BossTransformComponent.Position.y, 1)
	
	_SpawnService:SpawnByModelId("model://09e22bd5-1ec3-43fe-a554-9c2bfe0929ea", "GaurdStone", pos, self.Entity.Parent)
	
	self.godMode = true
	
	self:AttackStateTimer(2.5)
}

[Default]
void SwordAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK4")
	self.attackName = "swordAttack"
	
	local playersArr = _UserService:GetUsersByMapName(self.Entity.CurrentMap.Name)
	
	for i, p in pairs(playersArr) do
		if isvalid(p) then
			local swordAtk = function()
				local target = p
				local pos = Vector3(target.TransformComponent.Position.x, self.BossComponent.BossTransformComponent.Position.y, 0)
				_EffectService:PlayEffect("50ac41f6cdb44765b3966a50a7adfcc3", self.Entity, pos, 0, Vector3.one, false)
				
				_TimerService:SetTimerOnce(function() 
					local attackSize = Vector2(0.45, 1.15)
					self:AttackFrom(attackSize, Vector2(pos.x, pos.y), nil, CollisionGroups.Player) 
					end, 0.45)
			end
			_TimerService:SetTimerOnce(function() _SoundService:PlaySound("0051f5688445447aa6cc9ccbd8e8fdb5",1) end, 1)
			_TimerService:SetTimerOnce(swordAtk, 1.44)
		end
	end
	
	self:AttackStateTimer(4)
}

[Default]
void LazerAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK2")
	self.attackName = "LazerAttack"
	_SoundService:PlaySound("63016e3cd69f41dea5a1c27daa545477", 1)
	
	_TimerService:SetTimerOnce(function() 
			_EffectService:PlayEffect("50feb8313d0b4a958161980726e4b2e9", self.Entity, self.BossComponent.BossTransformComponent.Position + Vector3(1, 1, 0), 0, Vector3.one + Vector3(1, 3, 1), false)
			local attackSize = Vector2(11, 1.7)
			self:Attack(attackSize, Vector2(-6, 1.5), nil, CollisionGroups.Player)
		end, 1)--0.55)
	
	self:AttackStateTimer(2.43)
}

[Default]
void WaveAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK3")
	self.attackName = "WaveAttack"
	_SoundService:PlaySound("c979909b41f445769ecccddd072f7991", 1)
	
	_TimerService:SetTimerOnce(function() 
			_EffectService:PlayEffect("003698afe94c48c0af40a16c126be607", self.Entity, self.BossComponent.BossTransformComponent.Position + Vector3(0,1,0), 0, Vector3.one, false)
			local attackSize = Vector2(5.3, 5.2)
			local attackOffset = Vector2(0, 0)
			
			_EffectService:PlayEffect("003698afe94c48c0af40a16c126be607", self.Entity, self.BossComponent.BossTransformComponent.Position + Vector3(0, 1, 0), 0, Vector3.one, false)
			
			self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
		end, 1.6)
	
	self:AttackStateTimer(2.7)
}

[Default]
void SwordBoom()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK5")
	self.attackName = "SwordBoom"
	_SoundService:PlaySound("89f6720c99b74af7844f9c1d285b3ea4", 1)
	
	_TimerService:SetTimerOnce(function() 
			_EffectService:PlayEffect("085442b6a1cc46b98c56323b71af698a", self.Entity, self.BossComponent.BossTransformComponent.Position + Vector3(0, 3, 0), 0, Vector3.one, false)
			
			_TimerService:SetTimerOnce(function() 
				_EffectService:PlayEffect("23b517d737454e578f62e0010c8ee95e", self.Entity, self.BossComponent.BossTransformComponent.Position + Vector3(0, 3, 0), 0, Vector3.one, false)
			end, 0.33)
			
			local target = self.BossAIComponent.target
			local pos = Vector3(target.TransformComponent.Position.x, self.BossComponent.BossTransformComponent.Position.y, 0)
			_TimerService:SetTimerOnce(function() 
				_EffectService:PlayEffect("1565dd627dfa4184a0f52aa8e184ade6", self.Entity, pos, 0, Vector3.one, false)
					local attackSize = Vector2(2.4, 1.4)
					
				_TimerService:SetTimerOnce(function() self:AttackFrom(attackSize, Vector2(pos.x, pos.y), nil, CollisionGroups.Player) end, 0.27)
			end, 1)
		end, 0.9)
	
	self:AttackStateTimer(2.4)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if self.attackName == "swordAttack" then
		return self.swordDamage
	elseif self.attackName == "LazerAttack" then
		return self.lazerDamage
	elseif self.attackName == "WaveAttack" then
		_SoundService:PlaySound("8faba700d24b4d16bea40a13cf71918f", 1, defender)
		return self.waveDamage
	elseif self.attackName == "SwordBoom" then
		return self.boomDamage
	end
	
	return __base:CalcDamage(attacker,defender,attackInfo)
}


--Events--

[Default]
HandlePattern_Event(Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	log("PtNo : " ..PtNo)
	
	if PtNo < 5 then
		self:SwordAttack()
	elseif PtNo == 5 then
		if self.godMode == false then
			self:GodTime()
		else
			self:SwordAttack()
		end
	elseif PtNo == 6 then
		self:SwordBoom()
	elseif self.BossComponent.InRange == true then
		self:WaveAttack()
	else
		self:LazerAttack()
	end
	
}

