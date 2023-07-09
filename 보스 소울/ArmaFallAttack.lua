--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local attackSize = Vector2(1.5, 1.25)
	local attackOffset = Vector2.zero
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 1.8)
	_SoundService:PlaySound("98e2301f61e748dcb7045673b3faabe8", 0.5, self.Entity.CurrentMap)
	_TimerService:SetTimerOnce(function() self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player) end, 1.0)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 200
}

[Default]
void OnAttack(Entity defender)
{
	if self:IsServer() then return end
	_EffectService:PlayEffect("44ab48eb38374993ba07115add6b7efc", self.Entity, defender.TransformComponent.Position, 0, Vector3.one, false)
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}


--Events--

