--Properties--

boolean isReverse = false
array<string> hittedPlayer


--Methods--

[Server Only]
void OnBeginPlay()
{
	if self.Entity.TransformComponent.Position.x < 0 then
		self.isReverse = false
	else
		self.isReverse = true
	end
	
	_SoundService:PlaySound("c5933d4bab484846bce9235e6b4f7a79", 0.75, self.Entity.CurrentMap)
}

[Server Only]
void OnUpdate(number delta)
{
	if self.isReverse and self.Entity.TransformComponent.Position.x > -3.5 then
		self.Entity.TransformComponent:Translate(-0.08, 0)
	elseif not self.isReverse and self.Entity.TransformComponent.Position.x < 3.5 then
		self.Entity.TransformComponent:Translate(0.08, 0)
	else
		_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 0.7)
		self.Entity.SpriteRendererComponent.SpriteRUID = "b14044d158664f13810e06965a5b8892"
	end
	self:Attack(Vector2(3, 10), Vector2.one, nil, CollisionGroups.Player)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 500
}

[Default]
void OnAttack(Entity defender)
{
	for i = 1, 4 do
		if self.hittedPlayer[i] == nil then self.hittedPlayer[i] = defender.Name end
	end
	if self:IsServer() then return end
	_EffectService:PlayEffect("ff0837bb4cba48719acfbd451ed0b946", self.Entity, defender.TransformComponent.Position, 0, Vector3.one, false)
}

[Default]
boolean IsAttackTarget(Entity defender, string attackInfo)
{
	for i = 1, 4 do
		if self.hittedPlayer[i] == defender.Name then return false end
	end
	return __base:IsAttackTarget(defender,attackInfo)
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return false
}


--Events--

