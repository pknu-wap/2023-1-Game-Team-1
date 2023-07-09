--Properties--

number MaxHp = 2500
number Hp = 0
boolean isDead = false
number disharmonyFlag = 0
number usedExplosionAttack = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	local state = self.Entity.StateComponent
	self.Hp = self.MaxHp
	
	state:AddState("QUAKEATTACK", QuakeAttack)
	state:AddState("SCRATCHATTACK", ScratchAttack)
	state:AddState("SPAWNDISHARMONYSPIRIT", SpawnDisharmonySpirit)
	state:AddState("EXPLOSIONATTACK", ExplosionAttack)
	state:RemoveState("HIT")
	state:AddCondition("QUAKEATTACK", "IDLE")
	state:AddCondition("SCRATCHATTACK", "IDLE")
	state:AddCondition("SPAWNDISHARMONYSPIRIT", "IDLE")
	state:AddCondition("EXPLOSIONATTACK", "IDLE")
	
	_TimerService:SetTimerRepeat(self.SpawnRisingTrap, 4.5, 9)
	_TimerService:SetTimerRepeat(self.CheckUserAndDestroy, 10, 10)
}

[Server Only]
void UsePattern()
{
	math.randomseed(os.time())
	local select = math.random(1, 10)
	local state = self.Entity.StateComponent
	
	if self.usedExplosionAttack == 0 and self.Hp < self.MaxHp * 0.35 and state.CurrentStateName == "IDLE" then
		self.usedExplosionAttack = self.usedExplosionAttack + 1
		self.disharmonyFlag = 0
		state:ChangeState("EXPLOSIONATTACK")
		self:StartSpawnSphere()
	end
	
	if self.disharmonyFlag >= 2 and state.CurrentStateName == "IDLE" then
			self.disharmonyFlag = 0
			state:ChangeState("SPAWNDISHARMONYSPIRIT")
	end
	
	if state.CurrentStateName == "IDLE" then
		if select < 6 then
			self:TurnHead()
			state:ChangeState("QUAKEATTACK")
			self.disharmonyFlag = self.disharmonyFlag + 1
		else
			self:TurnHead()
			state:ChangeState("SCRATCHATTACK")
			self.disharmonyFlag = self.disharmonyFlag + 1
		end
	end
}

[Server Only]
Entity SearchTarget()
{
	local playersArr = _UserService:GetUsersByMapName(self.Entity.CurrentMapName)
	local agressiveTarget = playersArr[math.random(1, #playersArr)]
	return agressiveTarget
}

[Server Only]
void TurnHead()
{
	if self:SearchTarget().TransformComponent.Position.x > self.Entity.TransformComponent.Position.x then
		self.Entity.SpriteRendererComponent.FlipX = true
	else
		self.Entity.SpriteRendererComponent.FlipX = false
	end
}

[Server Only]
void QuakeAttack()
{
	local attackSize = Vector2(22, 0.15)
	local attackOffset = Vector2.zero
	local callBack = function()
		_SoundService:PlaySound("0684660ae2af4b0cad7769fc234caad0", 0.75, self.Entity.CurrentMap)
		self:Attack(attackSize, attackOffset, "quake", CollisionGroups.Player)
	end
	_TimerService:SetTimerOnce(callBack, 2.2)
}

[Server Only]
void ScratchAttack()
{
	local attackSize = Vector2(8.5, 3.5)
	local attackOffset = Vector2(-2, 0)
	if self.Entity.SpriteRendererComponent.FlipX == true then
		attackOffset = -attackOffset
	end
	
	local callBack = function()
		self:Attack(attackSize, attackOffset, "scratch", CollisionGroups.Player)
	end
	_TimerService:SetTimerOnce(callBack, 2.2)
}

[Server Only]
void SpawnSpiritOfDisharmony()
{
	_SoundService:PlaySound("031f57412ea945b6aadcea1fe953e435", 0.75, self.Entity.CurrentMap)
	_SpawnService:SpawnByModelId("model://9456b2fe-8478-4cb0-a9db-02874c5a9ec3", "SpiritOfDisharmony",
			Vector3(math.random(-9, 0), -1.718, 0), self.Entity.CurrentMap)
	_SpawnService:SpawnByModelId("model://9456b2fe-8478-4cb0-a9db-02874c5a9ec3", "SpiritOfDisharmony",
			Vector3(math.random(1, 10), -1.718, 0), self.Entity.CurrentMap)
}

[Server Only]
void ExplosionAttack()
{
	local effectId = 
	_EffectService:PlayEffectAttached("80aef397c5cb49e9b90d99558a941597", self.Entity, Vector3(0, 1, 0), 0, Vector3(4.5, 4.5, 4.5), true)
	
	_SpawnService:SpawnByModelId("model://2dda3e34-0496-4877-ac17-7ac5e3cb0cd4", "Fairy",
		Vector3(math.random(-7, 8), -1.57, 0), self.Entity.CurrentMap)
	
	local callBack = function()
		self:Attack(Vector2(25, 10), Vector2.zero, "explosion", CollisionGroups.Player)
		_SoundService:PlaySound("33454348353b45f8b4c3aad2a09a6f77", 0.75, self.Entity.CurrentMap)
		_EffectService:PlayEffectAttached("5dc8e6b9125540f89c0e806f7aeae6d7", self.Entity, Vector3.zero, 0, Vector3(3, 3, 3), false)
		_EffectService:RemoveEffect(effectId)
	end
	
	_TimerService:SetTimerOnce(callBack, 9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if attackInfo == "quake" then return 500
	elseif attackInfo == "scratch" then return 300
	elseif attackInfo == "explosion" then return 9999
	end	
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}

[Server Only]
void StartSpawnSphere()
{
	local callBack = function()
		if not self.isDead then 
			_SpawnService:SpawnByModelId("model://b05cb3ba-9cdf-4852-8f93-12d771fe5230", "Sphere",
				Vector3(math.random(-10, 11), 5, 0), self.Entity.CurrentMap)
		end
	end
	_TimerService:SetTimerRepeat(callBack, 1.0, 11)
}

[Server Only]
void SpawnRisingTrap()
{
	local select = math.random(1, 4)
	
	if not self.isDead and self.Entity.StateComponent.CurrentStateName ~= "EXPLOSIONATTACK" then
		if select == 1 then
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-9.5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-4.5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(1.5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(8.5, -1.73, 0), self.Entity.CurrentMap)
		
		elseif select == 2 then
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-3, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-0, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(6, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(10, -1.73, 0), self.Entity.CurrentMap)
		
		elseif select == 3 then
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-7, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(7, -1.73, 0), self.Entity.CurrentMap)
	
		else
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(-5.5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(2.5, -1.73, 0), self.Entity.CurrentMap)
			_SpawnService:SpawnByModelId("model://63ebca66-6bf4-4a09-a1e0-d946dd670d76", "RisingTrap",
				Vector3(7.5, -1.73, 0), self.Entity.CurrentMap)
		end
	end
}

[Server Only]
void Dead()
{
	self.isDead = true
	local state = self.Entity.StateComponent
	if state then
		state:ChangeState("DEAD")
		_SoundService:PlaySound("3387c7c7fb324cb58b2a0052f6d7ea10", 1.0, self.Entity.CurrentMap)
		self.Entity.SpriteRendererComponent.SpriteRUID = "1725b0727efe4797bd3c8251068fa035"
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
		self.Entity:Destroy()
	end
	
	_TimerService:SetTimerOnce(delayHide, 3.8)
	_DungeonClear:MoveUsersToLobby(self.Entity.Parent)
}

[Server Only]
void CheckUserAndDestroy()
{
	if _UserService:GetUserCount() == 0 then
		log("InstanceMap Destroyed")
		_EntityService:Destroy(self.Entity.Parent)
	end
}


--Events--

[Default]
HandleHitEvent(HitEvent event)
{
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	--------------------------------------------------------
	if self:IsClient() then return end
	
	local originalHp = self.Hp
	self.Hp = self.Hp - TotalDamage
	
	if self.Hp > 0 or originalHp <= 0 then
		return	
	end
	
	self:Dead()
}

[Server Only]
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
	if CurrentStateName == "IDLE" then 
		_TimerService:SetTimerOnce(self.UsePattern, 3.0)
	end
}

