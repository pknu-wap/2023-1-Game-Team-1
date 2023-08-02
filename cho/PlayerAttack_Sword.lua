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
int CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	local dmg = 0
	
	if attackInfo == nil then
		dmg = self.playerComponent.atkPoint^1.25
	
	elseif attackInfo == "sw2-2" then
		_EffectService:PlayEffect(_SwordSkill2.hitEffectRUID[2], attacker.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_SwordSkill2.hitSoundRUID[2], 1.0, attacker.Name)
		self.playerComponent:UpCharge(_SwordSkill2.upChargeRate[2])
		dmg = self.playerComponent.atkPoint^1.25 * _SwordSkill2.coefficient[2]
		
	elseif attackInfo == "sw4-2" then
		_EffectService:PlayEffect(_SwordSkill4.hitEffectRUID[2], attacker.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_SwordSkill4.hitSoundRUID[2], 1.0, attacker.Name)
		self.playerComponent:UpCharge(_SwordSkill4.upChargeRate[2])
		dmg = self.playerComponent.atkPoint^1.25 * _SwordSkill4.coefficient[2]
		
	elseif attackInfo == "sw4-3" then 
		_EffectService:PlayEffect(_SwordSkill4.hitEffectRUID[3], attacker.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(_SwordSkill4.hitSoundRUID[3], 1.0, attacker.Name)
		attacker.ExtendPlayerComponent:UpCharge(_SwordSkill4.upChargeRate[3])
		dmg = self.playerComponent.atkPoint^1.25 * _SwordSkill4.coefficient[3]
		
	else
		local skill = _SkillManager.skillDictionary["sword"][attackInfo]
		_EffectService:PlayEffect(skill.hitEffectRUID[1], attacker.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound(skill.hitSoundRUID[1], 1.0, attacker.Name)
		self.playerComponent:UpCharge(skill.upChargeRate[1])
		dmg = self.playerComponent.atkPoint^1.25 * skill.coefficient[1]
	end
	
	dmg = math.floor(dmg)
	return dmg
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
	if attackInfo == "sw4-2" or attackInfo == "sw6" then return 3 
	elseif attackInfo == "swU" then return 6 end
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
	if key == KeyboardKey.LeftShift then
		_SwordDash:PreSkill()
	end
}

