--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local attackSize = Vector2(1.75, 5)
	local attackOffset = Vector2.zero
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 2.1)
	local callBack = function() 
		_SoundService:PlaySound("028fa39fa5044fa6a08ab11eeb190ff9", 0.75, self.Entity.CurrentMap) 
		self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	end
	_TimerService:SetTimerOnce(callBack, 1.1)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 300
}

[Default]
void OnAttack(Entity defender)
{
	if self:IsServer() then return end
	_EffectService:PlayEffect("6a38fd1b97974661aa4298bbd59e9ddb", self.Entity, defender.TransformComponent.Position, 0, Vector3.one, false)
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}


--Events--

