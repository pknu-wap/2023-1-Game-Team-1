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
	--if attackInfo == "wa2" then
	--    _WandSkill2:EnableBuff(defender)
	--    self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill2.upChargeRate[1])
	--    return false
	--elseif attackInfo == "wa3" then
	--    _WandSkill3:EnableBuff(defender)
	--    self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill3.upChargeRate[1])
	--    return false
	--elseif attackInfo == "wa6" then
	--    _WandSkill6:EnableBuff(defender)
	--    self.Entity.ExtendPlayerComponent:UpCharge(_WandSkill6.upChargeRate[1])
	--    return false
	--elseif attackInfo == "waU-Buff" then
	--    _WandUltimateSkill:EnableBuff(defender)
	--    return false
	--else 
	--    return true
	--end
	
	if defender.PlayerComponent then
	    local skill = _SkillManager.skillDictionary["wand"][attackInfo]
	    skill:EnableBuff(defender)
	    self.playerComponent:UpCharge(skill.upChargeRate[1])
	    return false
	else
	    return true
	end
}

[Default]
int CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	local dmg = 0
	
	if attackInfo == nil then 
		dmg = self.playerComponent.atkPoint^1.25
	else
		local skill = _SkillManager.skillDictionary["wand"][attackInfo]
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
		_WandDash:PreSkill()
	end
}

