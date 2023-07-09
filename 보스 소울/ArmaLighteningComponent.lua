--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local attackSize = Vector2(2.0, 5.0)
	local attackOffset = Vector2.zero
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 0.9)
	_SoundService:PlaySound("f50138f681e24f0695bcd691b32ba78e", 1.0, self.Entity.CurrentMap)
	self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 500
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}


--Events--

