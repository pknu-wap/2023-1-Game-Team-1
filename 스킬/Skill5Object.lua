--Properties--

Vector2 attackSize = Vector2(4.2,4)
Vector2 attackOffset = Vector2(0,2)


--Methods--

[Server Only]
void OnBeginPlay()
{
	local sprite = self.Entity.SpriteRendererComponent
	local timerId = 0
	self:Attack(self.attackSize, self.attackOffset, "start", CollisionGroups.Monster)
	timerId = _TimerService:SetTimerRepeat(function() 
					self:Attack(self.attackSize, self.attackOffset, "idle", CollisionGroups.Monster)
					end, 0.5, 0.5)
	_SoundService:PlaySound("956eaa092b004be5b68297d534fa93e1", 0.75)
	_TimerService:SetTimerOnce(function()
			sprite.SpriteRUID = "4d034da3abeb42169d3955a1685bc474" 
			end, 1.1)
	_TimerService:SetTimerOnce(function()
			_TimerService:ClearTimer(timerId) 
			sprite.SpriteRUID = "bfeef1a8579a4e3e819ea99f97349046" 
			_SoundService:PlaySound("49e6b8d266754a128d449a3211b7c6b1", 0.75)
			end, 4.6)
	_TimerService:SetTimerOnce(function() self:Attack(self.attackSize, self.attackOffset, "end", CollisionGroups.Monster) end, 5.1)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 5.9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_EffectService:PlayEffect("0b89655e75cd4a5e92c13c008ab4e393", self.Entity.CurrentMap, defender.TransformComponent.Position, 0, Vector3.one, false)
	_SoundService:PlaySound("ea5d03c38c10410bae5794d7ad2e27b8", 1.0)
	if attackInfo == "start" then return 150 
	elseif attackInfo == "idle" then return 10 
	elseif attackInfo == "end" then return 150
	end
}

[Default]
int32 GetDisplayHitCount(string attackInfo)
{
	if attackInfo == "end" then return 3 end
	return __base:GetDisplayHitCount(attackInfo)
}


--Events--

