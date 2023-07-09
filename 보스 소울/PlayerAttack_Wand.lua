--Properties--

Component playerComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
	self.playerComponent = self.Entity.ExtendPlayerComponent
}

[Server Only]
void AttackNormal()
{
	local playerController = self.Entity.PlayerControllerComponent
	local transform = self.Entity.TransformComponent
	if playerController and transform then
		local worldPosition = transform.WorldPosition
		local attackOffset = Vector2(worldPosition.x + 0.5 * playerController.LookDirectionX, worldPosition.y + 0.5)
		self._T.shape.Position = attackOffset
		
		self:AttackFast(self._T.shape, nil, CollisionGroups.Monster)
	end
}

[Default]
boolean IsAttackTarget(Entity defender, string attackInfo)
{
	if attackInfo == "wa2" then
		_WandSkill2:EnableBuff(defender)
		self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill2.upChargeRate[1])
		return false
	elseif attackInfo == "wa3" then
		_WandSkill3:EnableBuff(defender)
		self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill3.upChargeRate[1])
		return false
	elseif attackInfo == "wa6" then
		_WandSkill6:EnableBuff(defender)
		self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill6.upChargeRate[1])
		return false
	elseif attackInfo == "waU-Buff" then
		_WandUltimateSkill:EnableBuff(defender)
		return false
	else 
		return true
	end
}

[Default]
int CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	if attackInfo == "wa1" then
		_EffectService:PlayEffect(_WandSkill1.hitEffectRUID[1], defender.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_WandSkill1.hitSoundRUID[1], 1.0, attacker.Name)
		attacker.ExtendPlayerComponent:UpCharge(_WandSkill1.upChargeRate[1])
		return self.playerComponent.atkPoint^1.25 * _WandSkill1.coefficient[1]
	elseif attackInfo == "wa5" then
		_EffectService:PlayEffect(_WandSkill5.hitEffectRUID[1], defender.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_WandSkill5.hitSoundRUID[1], 1.0, attacker.Name)
		attacker.ExtendPlayerComponent:UpCharge(_WandSkill5.upChargeRate[1])
		return self.playerComponent.atkPoint^1.25 * _WandSkill5.coefficient[1]
	elseif attackInfo == "waU-Attack" then
		_EffectService:PlayEffect(_WandUltimateSkill.hitEffectRUID[2], defender.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_WandUltimateSkill.hitSoundRUID[1], 1.0, attackerName)
		return self.playerComponent.atkPoint^1.25 * _WandUltimateSkill.coefficient[1]
	else			
	return 50
	end
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return _UtilLogic:RandomDouble() < 0.3
}

[Default]
number GetCriticalDamageRate()
{
	return 2
}

[Default]
int32 GetDisplayHitCount(string attackInfo)
{
	return __base:GetDisplayHitCount(attackInfo)
}


--Events--

[Default]
HandlePlayerActionEvent(PlayerActionEvent event)
{
	-- Parameters
	local ActionName = event.ActionName
	local PlayerEntity = event.PlayerEntity
	--------------------------------------------------------
	if self:IsClient() then return end
	
	if ActionName == "Attack" then
		self:AttackNormal()
	end
}

[Default]
HandleKeyDownEvent(KeyDownEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: InputService
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local key = event.key
	---------------------------------------------------------
	if key == KeyboardKey.X then
		_WandDash:PreSkill()
	end
}

