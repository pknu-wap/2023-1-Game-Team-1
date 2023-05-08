--Properties--

any skillData = nil


--Methods--

[Server Only]
void OnBeginPlay()
{
	self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
	self.skillData = _DataService:GetTable("SwordSkillData")
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
	if attackInfo == "Skill1" then
		_EffectService:PlayEffect("4bcca53c2d0041dea28a380004fac1a1", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("be2c331136bd4ab0aec6d3d5c4cb7238", 1.0, attacker.Name)
		return 70
	elseif attackInfo == "Skill2-1" then
		_EffectService:PlayEffect("b6aba5e7bdcf4aa8b5d6aa5fdf36d0d5", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("7e185cbffb9748a695c2fc6a5542d736", 1.0, attacker.Name)
		return 60
	elseif attackInfo == "Skill2-2" then
		_EffectService:PlayEffect("b6aba5e7bdcf4aa8b5d6aa5fdf36d0d5", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("7e185cbffb9748a695c2fc6a5542d736", 1.0, attacker.Name)  
		return 120
	elseif attackInfo == "Skill3" then
		_EffectService:PlayEffect("2ef064f22b8542a093e4d95becd2349a", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one * 3, false)
		_SoundService:PlaySound("a406ef8dca3b470893a9476609000b98", 1.0, attacker.Name)
		return 180
	elseif attackInfo == "Skill4-1" then
		_EffectService:PlayEffect("b043c874c97a427db43948f6d5f7c4d9", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("3a7c00b6bbc2416595543f6cc55c0d83", 1.0, attacker.Name)
		return 50
	elseif attackInfo == "Skill4-2" then
		_EffectService:PlayEffect("b79cbdf6d06b487382f03d625a1fc464", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("aa92fddf0e404d35bf6406cef6bc7ad5", 1.0, attacker.Name)
		return 60
	elseif attackInfo == "Skill4-3" then
		_EffectService:PlayEffect("b6aba5e7bdcf4aa8b5d6aa5fdf36d0d5", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
		_SoundService:PlaySound("aa92fddf0e404d35bf6406cef6bc7ad5", 1.0, attacker.Name)
		return 100
	elseif attackInfo == "UltimateSkill" then
		local timerId = 0
		local attackCount = 0
		local attackEffect = function()
			_EffectService:PlayEffect("2ef064f22b8542a093e4d95becd2349a", self.Entity.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
			_SoundService:PlaySound("f8840bbb6c5f46fba1afbb90270f15a3", 1.0, attacker.Name)
			attackCount = attackCount + 1
			if attackCount > 5 then _TimerService:ClearTimer(timerId) end
		end
		timerId = _TimerService:SetTimerRepeat(attackEffect, 0.11)
		return 350
	else return 50
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
	if attackInfo == "Skill4-2" then return 3 
	elseif attackInfo == "UltimateSkill" then return 6 end
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

