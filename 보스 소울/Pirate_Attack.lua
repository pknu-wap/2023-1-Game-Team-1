--Properties--

Component BossComponent
Component BossAIComponent
number speed = 2
string attackName = ""
Component HitComponent
number phaseNum = 1
boolean teleportCool = true
number nautilTimer = 0
number nautilCool = 60
number effectNum = 0
number shield = 0
boolean nautilCan = false
string bulletAttackAnim = ""
Vector2 bulletAttackOffset = Vector2(0,0)
number bulletAttackPosXOffset = 0
Vector2 bulletAttackSize = Vector2(5, 0.8)


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.BossComponent = self.Entity.Boss
	self.BossAIComponent = self.Entity.BossAIComponent
	self.HitComponent = self.Entity.Pirate_Hit
	
	self.BossComponent.MaxHp = 300
	self.BossComponent.Hp = 300
	self.BossComponent.isHide = false
	
	self.BossAIComponent.detectDistance = 2
	
	self.BossComponent.stateComponent:AddState("CHASE", chase)
	self.BossComponent.stateComponent:AddState("ATTACK1", attack1)
	self.BossComponent.stateComponent:AddState("ATTACK2", attack2)
	self.BossComponent.stateComponent:AddState("ATTACK3", attack3)
	self.BossComponent.stateComponent:AddState("ATTACK4", attack4)
	self.BossComponent.stateComponent:AddState("ATTACK5", attack5)
	self.BossComponent.stateComponent:AddState("ATTACK6", attack6)
	self.BossComponent.stateComponent:AddState("JUMP", jump)
	self.BossComponent.stateComponent:AddState("DIE", die)
	self.BossComponent.stateComponent:AddState("HIT", hit)
	self.BossComponent.stateComponent:AddState("CANCEL", cancel)
	
	self.Entity.MovementComponent.InputSpeed = self.speed
	self.BossComponent.speed = self.speed
	
	self.bulletAttackAnim = "41e5292467744f7684bf7fcafae89f90"
	self.bulletAttackOffset = Vector2(-2.2, 0.4)
	self.bulletAttackPosXOffset = 0.5
	self.bulletAttackSize = Vector2(5, 0.8)
	
	self:Phase3State()
	_TimerService:SetTimerOnce(function() self.nautilCan = true end, self.nautilCool)
}

[Server Only]
void OnUpdate(number delta)
{
	if self.attackName == "Nautilus" and self.shield > 0 then
		self.nautilTimer = self.nautilTimer + delta
		if self.nautilTimer > 10 then
			self.nautilTimer = 0
			self:NautilusAttack()
		end
	elseif self.attackName == "Nautilus" and self.shield <= 0 then
		self.attackName = ""
		_EffectService:RemoveEffect(self.effectNum)
		self.BossComponent.stateComponent:ChangeState("CANCEL")
		self:AttackStateTimer(3)
	end
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
void Phase2State()
{
	log("해적 페이즈 2")
	self.phaseNum = 2
	self.speed = 0.7
	self.BossComponent.speed = self.speed
	self.BossComponent.MaxHp = 500
	self.BossComponent.Hp = self.BossComponent.MaxHp
	
	self.Entity.MovementComponent.InputSpeed = 0
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.HitComponent.Enable = false;
		
		self.bulletAttackAnim = "ba9e242e91d14d57b8a275331718dc5b"
		self.bulletAttackOffset = Vector2(-2.2, 0.4)
		self.bulletAttackPosXOffset = 0
		self.bulletAttackSize = Vector2(4.5, 2)
		
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("move")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("stand")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack1")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack2")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack3")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack4")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack5")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("jump")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("hit")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("die")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("chase")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("cancel")
		
		self.BossComponent.stateAnimationComponent:SetActionSheet("move", "6086a0c15fc3464ca99ed70272327088")
		self.BossComponent.stateAnimationComponent:SetActionSheet("stand", "38169379ec9146328be3bf9267eaa4f6")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack1", "0a13b0bc8a494b69a485a446e41832a0")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack2", "42cbd6355a8144aa95a4303dea253c97")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack3", "dda106f024414af998440716158fc175")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack4", "5547843e602e4e8aa17c14bc0f3d41fe")
		self.BossComponent.stateAnimationComponent:SetActionSheet("jump", "e8d7cd4f380e47d7bb595128b843f74f")
		self.BossComponent.stateAnimationComponent:SetActionSheet("hit", "1c02f4efeca1429e8a747a36fae4d00a")
		self.BossComponent.stateAnimationComponent:SetActionSheet("die", "7b9a77816c9a4ec0a141273273c7ae87")
		self.BossComponent.stateAnimationComponent:SetActionSheet("cancel", "15b73e38ddbc46709f3399da6a5752ba")
		
		local visibleOn = function()
			self.BossComponent.stateComponent:ChangeState("IDLE")
			self.Entity:SetVisible(true)
			self.HitComponent.Enable = true
		end
		
		_TimerService:SetTimerOnce(visibleOn, 2)
	end
	
	_TimerService:SetTimerOnce(delayHide, 0.6)
}

[Default]
void Phase3State()
{
	log("해적 페이즈 3")
	self.phaseNum = 3
	self.speed = 0.7
	self.BossComponent.speed = self.speed
	self.BossComponent.MaxHp = 500
	self.BossComponent.Hp = self.BossComponent.MaxHp
	self.BossComponent.LastPhase = true
	
	self.Entity.MovementComponent.InputSpeed = 0
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.HitComponent.Enable = false;
		
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("move")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("stand")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack1")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack2")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack3")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack4")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("attack5")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("jump")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("hit")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("die")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("chase")
		self.BossComponent.stateAnimationComponent:RemoveActionSheet("cancel")
		
		self.BossComponent.stateAnimationComponent:SetActionSheet("move", "e8ede9c1ccf44379ad0aff70af51680c")
		self.BossComponent.stateAnimationComponent:SetActionSheet("stand", "554117e1127f47aba88ce91314437bd6")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack1", "53e0411a14e449b992763090e37e4251")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack2", "f24a85d24f02474fb9dbace7148fbf6b")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack3", "c01ce3bfe325435ebb8166c34612553f")
		self.BossComponent.stateAnimationComponent:SetActionSheet("attack4", "1d8e64e6743b4e53b32a681c81a8e46c")
		self.BossComponent.stateAnimationComponent:SetActionSheet("jump", "d99902c30e5042f586f0078c1bcf6ff2")
		self.BossComponent.stateAnimationComponent:SetActionSheet("hit", "554117e1127f47aba88ce91314437bd6")
		self.BossComponent.stateAnimationComponent:SetActionSheet("die", "73b1841e26f049e1a6aa160beb03f1d7")
		self.BossComponent.stateAnimationComponent:SetActionSheet("cancel", "15b73e38ddbc46709f3399da6a5752ba")
		
		local visibleOn = function()
			self.BossComponent.stateComponent:ChangeState("IDLE")
			self.Entity:SetVisible(true)
			self.HitComponent.Enable = true
		end
		
		_TimerService:SetTimerOnce(visibleOn, 2)
	end
	
	_TimerService:SetTimerOnce(delayHide, 0.6)
}

[Default]
void Phase1Attack(number PtNo)
{
	local target = self.BossAIComponent.target
	
	if target.TransformComponent.Position.y > 1.7 or target.TransformComponent.Position.y <= -1.225 and self.teleportCool == true then
		self:Teleport()
	end
	
	if self.nautilCan == true then
		self.nautilCan = false
		_TimerService:SetTimerOnce(function() self.nautilCan = true end, self.nautilCool + 10)
		self:CallNautilus()
		return
	end
	
	if PtNo < 3 then
		self:SpawnBattleShip()
	elseif PtNo >= 3 and PtNo < 6 then
		self:bulletAttack()
	elseif PtNo >=6 then
		self:LazerAttack()
	end
}

[Default]
void Phase2Attack(number PtNo)
{
	local target = self.BossAIComponent.target
	
	if target.TransformComponent.Position.y > 1.7 or target.TransformComponent.Position.y <= -1.225 and self.teleportCool == true then
		self:Teleport()
	end
	
	if PtNo < 2 then
		self:SpawnBattleShip()
	elseif PtNo >= 2 and PtNo < 5 then
		self:bulletAttack()
	elseif PtNo >= 5 and PtNo < 8 then
		self:ShockwaveAttack()
	elseif PtNo >= 8 then
		self:PileKick()
	end
}

[Default]
void Phase3Attack(number PtNo)
{
	local target = self.BossAIComponent.target
	
	if target.TransformComponent.Position.y > 1.7 or target.TransformComponent.Position.y <= -1.225 and self.teleportCool == true then
		self:Teleport()
	end
	
	if PtNo < 2 then
		self:SpawnBattleShip()
	elseif PtNo >= 2 and PtNo < 5 then
		self:Pist()
	elseif PtNo >= 5 and PtNo < 8 then
		self:Slash()
	elseif PtNo >= 8 then
		self:HammerSmash()
	end
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if self.attackName == "bulletAttack" then
		_EffectService:PlayEffect("8222987d483a43c8ac00de2f191d900a", defender, defender.TransformComponent.Position + Vector3(0, 0.5, 0), 0, Vector3.one * 2, false)
		return 500
	elseif self.attackName == "LazerAttack" then
		return 300
	elseif self.attackName == "WaveAttack" then
		return 300
	elseif self.attackName == "Shockwave" then
		return 300
	elseif self.attackName == "pileKick" then
		return 500
	elseif self.attackName == "Pist" then
		return 500
	elseif self.attackName == "Nautilus" then
		return 20000
	end
	
	return __base:CalcDamage(attacker,defender,attackInfo)
}

[Default]
void bulletAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK1")
	self.attackName = "bulletAttack"
	local scale = Vector3.one
	local pos = self.BossComponent.BossTransformComponent.Position
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		pos.x = pos.x + self.bulletAttackPosXOffset
		self.bulletAttackOffset.x = self.bulletAttackOffset.x * -1
	else
		pos.x = pos.x - self.bulletAttackPosXOffset
	end
	
	_EffectService:PlayEffect(self.bulletAttackAnim, self.Entity, pos, 0, scale, false)
	
	_TimerService:SetTimerOnce(function() 
				local attackSize = Vector2(5, 0.8)
				self:Attack(attackSize, self.bulletAttackOffset, nil, CollisionGroups.Player) 
				end, 0.45)
	
	self:AttackStateTimer(1.08)
}

[Default]
void Teleport()
{
	self.teleportCool = false
	
	_EffectService:PlayEffect("288b2ca13ae34efc987c49ac0bb22f79", self.Entity, self.Entity.TransformComponent.Position, 0, Vector3.one, false)
	
	local target = self.BossAIComponent.target
	local pos = Vector2(target.TransformComponent.Position.x, target.TransformComponent.Position.y)
	
	self.BossComponent.stateComponent:ChangeState("JUMP")
	self.BossComponent.BossMovementComponent:SetPosition(pos)
	
	_TimerService:SetTimerOnce(function() self.teleportCool = true end, 5)
}

[Default]
void LazerAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK2")
	self.attackName = "LazerAttack"
	
	local scale = Vector3.one
	local pos = self.BossComponent.BossTransformComponent.Position
	local offset = Vector2(-5.5, 0.002)
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		pos.x = pos.x + 0.35
		pos.y = pos.y + 0.3
		offset.x = offset.x * -1
	else
		pos.x = pos.x - 0.35
		pos.y = pos.y + 0.3
	end
	
	_TimerService:SetTimerOnce(function() 
			_EffectService:PlayEffect("4cbd95d90dc54cf481cec1bb3cc04cea", self.Entity, pos, 0, scale, false)
			
			_TimerService:SetTimerOnce(function() 
				local attackSize = Vector2(10.8, 1)
				self:Attack(attackSize, offset, nil, CollisionGroups.Player) 
			end, 0.12)
		end, 0.63)
	
	self:AttackStateTimer(1.08)
}

[Default]
void SpawnBattleShip()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK3")
	
	_EffectService:PlayEffect("140c74a7ebd34deaacc7ae016f211aef", self.Entity, self.BossComponent.BossTransformComponent.Position, 0, Vector3.one, false)
	
	_SpawnService:SpawnByModelId("model://b6fe216c-6ab3-4c70-a4c2-25afb92babd2", self.battleShip, self.BossComponent.BossTransformComponent.Position, self.Entity.Parent)
	
	self:AttackStateTimer(1.08)
}

[Default]
void CallNautilus()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK4")
	self.attackName = "Nautilus"
	
	self.nautilTimer = 0
	self.shield = self.BossComponent.MaxHp - (self.BossComponent.MaxHp / 2)
	log("쉴드 량 " ..self.shield)
	
	self.effectNum = _EffectService:PlayEffect("2bd51be3d3f4479a91ab02508b1ae94f", self.Entity, self.BossComponent.BossTransformComponent.Position, 0, Vector3.one, true)
	
	_TimerService:SetTimerOnce(function() end, 5)
}

[Default]
void NautilusAttack()
{
	_EffectService:RemoveEffect(self.effectNum)
	_EffectService:PlayEffect("4f99a4560f7f47ee8040328496cfd99e", self.Entity, Vector3.zero, 0, Vector3.one * 2, false)
	_EffectService:PlayEffect("89a3c816c7034948abdbca29fdbd9aac", self.Entity, Vector3.zero, 0, Vector3.one * 2, false)
	
	local attackSize = Vector2(40, 40)
	_TimerService:SetTimerOnce(function() self:Attack(attackSize, Vector2.zero, nil, CollisionGroups.Player)  end, 1.8)
	
	self:AttackStateTimer(3)
}

[Default]
void ShockwaveAttack()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK3")
	self.attackName = "Shockwave"
	
	local scale = Vector3.one
	local pos = self.BossComponent.BossTransformComponent.Position
	local offset = Vector2(-1, 0.5)
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		offset.x = offset.x * -1
	end
	
	_TimerService:SetTimerOnce(function() 
			_EffectService:PlayEffect("89218a3294cf49d6b4e4200944966322", self.Entity, pos, 0, scale, false)
			
			_TimerService:SetTimerOnce(function() 
				local attackSize = Vector2(6, 1.5)
				self:Attack(attackSize, offset, nil, CollisionGroups.Player) 
			end, 0.12)
		end, 0.6)
	
	self:AttackStateTimer(1.08)
}

[Default]
void PileKick()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK4")
	self.attackName = "pileKick"
	
	local scale = Vector3.one
	local offset = Vector2(-1.5, 1)
	local pos = self.Entity.TransformComponent.Position
	log("파일 킥!! ")
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		offset.x = offset.x * -1
		pos.x = pos.x -1
	else
		pos.x = pos.x +1
	end
	
	_EffectService:PlayEffect("c96871ca561f4e62a22d400fab60f920", self.Entity, pos, 0, scale) 
	
	_TimerService:SetTimerOnce(function() 
		local attackSize = Vector2(3, 2)
		self:Attack(attackSize, offset, nil, CollisionGroups.Player)
	end, 0.27) 
	
	self:AttackStateTimer(2.55)
}

[Default]
void Pist()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK1")
	self.attackName = "Pist"
	
	local scale = Vector3.one
	local offset = Vector2(-1, 0.5)
	local pos = self.Entity.TransformComponent.Position
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		offset.x = offset.x * -1
		pos.x = pos.x
	else
		pos.x = pos.x
	end
	
	_TimerService:SetTimerOnce(function() _EffectService:PlayEffect("21f41a81d1e4469091c5bf9cce4db6e7", self.Entity, pos, 0, scale) end, 0.45)
	
	_TimerService:SetTimerOnce(function() 
		local attackSize = Vector2(3, 1)
		self:Attack(attackSize, offset, nil, CollisionGroups.Player)
	end, 0.5) 
	
	self:AttackStateTimer(2.85)
}

[Default]
void Slash()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK2")
	self.attackName = "Slash"
	
	local scale = Vector3.one
	local offset = Vector2(-3, 2)
	local pos = self.Entity.TransformComponent.Position
	local effectpos = self.Entity.TransformComponent.Position
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		offset.x = offset.x * -1
		pos.x = pos.x
		effectpos.x = effectpos.x
	else
		pos.x = pos.x
		effectpos.x = effectpos.x
	end
	
	_TimerService:SetTimerOnce(function() _EffectService:PlayEffect("8e982734541e41618f898115f9885e91", self.Entity, pos, 0, scale) end, 0.27)
	_TimerService:SetTimerOnce(function() _EffectService:PlayEffect("8d996cbfc0474c3997f9864079749732", self.Entity, effectpos, 0, scale) end, 0.12)
	
	_TimerService:SetTimerOnce(function() 
		local attackSize = Vector2(6, 4)
		self:Attack(attackSize, offset, nil, CollisionGroups.Player)
	end, 0.5) 
	
	self:AttackStateTimer(2.79)
}

[Default]
void HammerSmash()
{
	self.BossComponent.stateComponent:ChangeState("ATTACK4")
	self.attackName = "hammerSmash"
	
	local scale = Vector3.one
	local offset = Vector2(-1, 1.15)
	local pos = self.Entity.TransformComponent.Position
	
	if self.BossComponent.BossTransformComponent.Scale.x == -1 then
		scale.x = -1
		offset.x = offset.x * -1
		pos.x = pos.x
	else
		pos.x = pos.x
	end
	
	_TimerService:SetTimerOnce(function() _EffectService:PlayEffect("02d611fcbec94810a2e75d6f7a104680", self.Entity, pos, 0, scale) end, 0.93)
	
	_TimerService:SetTimerOnce(function() 
		local attackSize = Vector2(3.3, 2.3)
		self:Attack(attackSize, offset, nil, CollisionGroups.Player)
	end, 1.29) 
	
	self:AttackStateTimer(2.88)
}


--Events--

[Default]
HandlePattern_Event(Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	if self.phaseNum == 1 then
		self:Phase1Attack(PtNo)
	elseif self.phaseNum == 2 then
		self:Phase2Attack(PtNo)
	elseif self.phaseNum == 3 then
		self:Phase3Attack(PtNo)
	end
	
	--if self.phaseNum == 1 then
	--	self:Phase1Attack(PtNo)
	--elseif self.phaseNum == 2 then
	--	self:Phase1Attack(PtNo)
	--end
}

