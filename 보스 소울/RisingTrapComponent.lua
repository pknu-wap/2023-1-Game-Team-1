--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local attackSize = Vector2(1, 2)
	local attackOffset = Vector2.zero
	_TimerService:SetTimerOnce(function() self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player) end, 1.9)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 3.1)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 100
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}

[Default]
void OnAttack(Entity defender)
{
	if self:IsServer() then return end
	_EffectService:PlayEffect("43b9f010df184c3f91dc3e25840f4bc0", self.Entity, defender.TransformComponent.Position, 0, Vector3.one, false)
}


--Events--

