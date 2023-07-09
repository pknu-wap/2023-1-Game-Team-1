--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	_SoundService:PlayLoopSound("05b0809081fc499ab12e0a18c7f03086", 0.75, self.Entity.CurrentMap)
	local callBack = function() 
		_SoundService:StopSound("05b0809081fc499ab12e0a18c7f03086", self.Entity.CurrentMap)
		self.Entity:Destroy() 
		end
	_TimerService:SetTimerOnce(callBack, 4.2)
}

[Server Only]
void OnUpdate(number delta)
{
	self:WaterFallAtack()
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 1000
}

[Default]
void WaterFallAtack()
{
	self:AttackFrom(Vector2(8, 15), Vector2(3, -0.73), nil, CollisionGroups.Player)
	self:AttackFrom(Vector2(5, 10), Vector2(-3.25, 5.5), nil, CollisionGroups.Player)
	self:AttackFrom(Vector2(1.8, 15), Vector2(-6, 0.73), nil, CollisionGroups.Player)
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}


--Events--

