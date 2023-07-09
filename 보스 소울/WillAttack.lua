--Properties--

Vector2 attackSize = Vector2(1,7)
Vector2 attackOffset = Vector2(0,0)


--Methods--

[Server Only]
void OnBeginPlay()
{
	local attack = function()
		self:Attack(self.attackSize, self.attackOffset, nil, CollisionGroups.Player)
	end
	
	_TimerService:SetTimerOnce(attack, 1.35)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 1.8)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 1
}


--Events--

