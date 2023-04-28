--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local sprite = self.Entity.SpriteRendererComponent
	_SoundService:PlaySound("956eaa092b004be5b68297d534fa93e1", 0.75)
	_TimerService:SetTimerOnce(function() sprite.SpriteRUID = "4d034da3abeb42169d3955a1685bc474" end, 1.1)
	_TimerService:SetTimerOnce(function() 
			sprite.SpriteRUID = "bfeef1a8579a4e3e819ea99f97349046" 
			_SoundService:PlaySound("49e6b8d266754a128d449a3211b7c6b1", 0.75)
			end, 4.6)
	_TimerService:SetTimerOnce(function() self:Attack(Vector2(4.2, 4), Vector2(0, 2), nil, CollisionGroups.Monster) end, 5.1)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 5.9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_EffectService:PlayEffect("0b89655e75cd4a5e92c13c008ab4e393", self.Entity.CurrentMap, defender.TransformComponent.Position, 0, Vector3.one, false)
	_SoundService:PlaySound("ea5d03c38c10410bae5794d7ad2e27b8", 1.0)
	return 200
}

[Default]
int32 GetDisplayHitCount(string attackInfo)
{
	return 3
}


--Events--

