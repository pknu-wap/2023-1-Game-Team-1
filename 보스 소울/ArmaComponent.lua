--Properties--

number reverseFlag = 0
number MaxHp = 2500
number Hp = 0
boolean isDead = false
number usedErdaFall = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	local state = self.Entity.StateComponent
	self.Hp = self.MaxHp
	
	state:AddState("FALLINGATTACK", FallingAttack)
	state:AddState("BITEATTACK", BiteAttack)
	state:AddState("STORMREADY", StormReady)
	state:AddState("STORMATTACK", StormAttack)
	state:AddState("ERDAFALL", ErdaFall)
	state:RemoveState("HIT")
	state:AddCondition("FALLINGATTACK", "IDLE")
	state:AddCondition("BITEATTACK", "IDLE")
	state:AddCondition("STORMREADY", "STORMATTACK")
	state:AddCondition("STORMATTACK", "IDLE")
	state:AddCondition("ERDAFALL", "IDLE")
	
	_TimerService:SetTimerRepeat(self.CheckUserAndDestroy, 10, 10)
}

[Server Only]
void UsePattern()
{
	math.randomseed(os.time())
	local select = math.random(1, 10)
	local state = self.Entity.StateComponent
	
	if self.usedErdaFall == 0 and self.Hp < self.MaxHp * 0.6 and state.CurrentStateName == "IDLE" then
		self.usedErdaFall = self.usedErdaFall + 1
		state:ChangeState("ERDAFALL")
	end
	
	if self.usedErdaFall == 1 and self.Hp < self.MaxHp * 0.3 and state.CurrentStateName == "IDLE" then
		self.usedErdaFall = self.usedErdaFall + 1
		state:ChangeState("ERDAFALL")
		self:ErdaFallLightening()
	end
	
	if state.CurrentStateName == "IDLE" then
		if select <= 4 then 
			state:ChangeState("FALLINGATTACK")
		
		elseif select <= 8 then
			state:ChangeState("BITEATTACK")
		
		elseif select <= 10 then
			state:ChangeState("STORMREADY")
		end
	end
}

[Server Only]
void SpawnFalling()
{
	local playerArr = _UserService:GetUsersByMapName(self.Entity.CurrentMapName)
	
	if self.Entity.StateComponent.CurrentStateName ~= "FALLINGATTACK" then return end
	local callBack = function()
		local target = playerArr[math.random(1, #playerArr)]
		_SpawnService:SpawnByModelId("model://556a1ed2-a561-492c-81ab-369e6136ec29", "Falling",
		Vector3(target.TransformComponent.Position.x, target.TransformComponent.Position.y, 0), self.Entity.CurrentMap) 
	end
	callBack()
	
	if self.Hp < self.MaxHp*0.6 then
	_TimerService:SetTimerOnce(callBack, 0.8) 
	end
	
	if self.Hp < self.MaxHp*0.3 then
	_TimerService:SetTimerOnce(callBack, 1.6)
	end
}

[Server Only]
void SpawnBite()
{
	if self.Entity.StateComponent.CurrentStateName ~= "BITEATTACK" then return end
	
	for i = 0, math.random(2, 3) do
		_SpawnService:SpawnByModelId("model://320e15d4-410b-42be-ae04-8c2bb81e2a25", "Bite",
		Vector3(math.random(-5.5, 5.5), -1.262, 0), self.Entity.CurrentMap)
	end
}

[Server Only]
void StormReady()
{
	self.reverseFlag = math.random(0, 1)
	local pn = 0
	
	if self.reverseFlag == 0 then
		pn = _ParticleService:PlayAreaParticle(AreaParticleType.Windlines, Vector2(1, 6), self.Entity.CurrentMap, 
		Vector3(-7.3, 1, 0), 0, Vector3.one)
	elseif self.reverseFlag == 1 then
		pn = _ParticleService:PlayAreaParticle(AreaParticleType.Windlines, Vector2(1, 6), self.Entity.CurrentMap, 
		Vector3(7.3, 1, 0), 180, Vector3.one)
	end
	
	_TimerService:SetTimerOnce(function() _ParticleService:RemoveParticle(pn) end, 5.0)
}

[Server Only]
void SpawnStorm()
{
	if self.reverseFlag == 0 then 
		_SpawnService:SpawnByModelId("model://7db9eb0c-241f-4a79-91ec-9c8c2140cb7c", "Storm", 
		Vector3(-5.5, -1.1, 0), self.Entity.CurrentMap)
	elseif self.reverseFlag == 1 then
		_SpawnService:SpawnByModelId("model://7db9eb0c-241f-4a79-91ec-9c8c2140cb7c", "Storm", 
		Vector3(5.5, -1.1, 0), self.Entity.CurrentMap)
	end
}

[Server Only]
void ErdaFall()
{
	local rain = _EntityService:GetEntity("c51472c6-1e0c-439a-b450-15256e8a61cd")
	rain.Enable = true
	_SoundService:PlaySound("7cdef97a92a24979b3ff78eda8bb37b7", 0.75, self.Entity.CurrentMap)
	local callBack = function()
		rain.Enable = false
		_SpawnService:SpawnByModelId("model://2fd4775c-2a1b-4ede-b8ce-ef726c71af6d", "WaterFall", Vector3(0, 0, 0), self.Entity.CurrentMap)
	end
	_TimerService:SetTimerOnce(callBack, 5.0)
}

[Server Only]
void ErdaFallLightening()
{
	local attackPos = {math.random(1, 2), math.random(1, 2), math.random(1, 2), math.random(1, 2)}
	local callBack = function(i)
		if attackPos[i] == 1 then
			_SpawnService:SpawnByModelId("model://29440a0f-df67-4384-a805-760492940637", "Warning", Vector3(-4.11, -1.26, 0), self.Entity.CurrentMap)
			_TimerService:SetTimerOnce(function()
					_SpawnService:SpawnByModelId("model://6a1ce91b-8942-4d33-bc67-048f4511e85a", "Lightening", Vector3(-4.09, -1.18, 0), self.Entity.CurrentMap)
				end, 4.75)
		else
			_SpawnService:SpawnByModelId("model://29440a0f-df67-4384-a805-760492940637", "Warning", Vector3(-2.19, -1.26, 0), self.Entity.CurrentMap)
			_TimerService:SetTimerOnce(function()
					_SpawnService:SpawnByModelId("model://6a1ce91b-8942-4d33-bc67-048f4511e85a", "Lightening", Vector3(-1.98, -1.18, 0), self.Entity.CurrentMap)
				end, 4.75)
		end
	end
	
	_TimerService:SetTimerOnce(function() callBack(1) end, 0.85)
	_TimerService:SetTimerOnce(function() callBack(2) end, 1.75)
	_TimerService:SetTimerOnce(function() callBack(3) end, 2.65)
	_TimerService:SetTimerOnce(function() callBack(4) end, 3.55)
	
	_TimerService:SetTimerRepeat(self.Lightening, 7.0)
}

[Server Only]
void Lightening()
{
	local state = self.Entity.StateComponent
	if state.CurrentStateName == "STORMREADY" or state.CurrentStateName == "SpawnStorm" 
		or state.CurrentStateName == "ERDAFALL" or state.CurrentStateName == "DEAD" then 
		return 
	end
	local attackPos = math.random(-5.9, 5.4)
	_SpawnService:SpawnByModelId("model://29440a0f-df67-4384-a805-760492940637", "Warning",
		Vector3(attackPos, -1.26, 0), self.Entity.CurrentMap)
	_TimerService:SetTimerOnce(function()
			_SpawnService:SpawnByModelId("model://6a1ce91b-8942-4d33-bc67-048f4511e85a", "Lightening",
			Vector3(attackPos, -1.18, 0), self.Entity.CurrentMap)
		end, 2.5)
}

[Server Only]
void Dead()
{
	self.isDead = true
	local state = self.Entity.StateComponent
	if state then
		state:ChangeState("DEAD")
		_SoundService:PlaySound("2d4e8187d84f42b7a071d8642e12e103", 1.0, self.Entity.CurrentMap)
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
		self.Entity:Destroy()
	end
	
	_TimerService:SetTimerOnce(delayHide, 4.0)
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

