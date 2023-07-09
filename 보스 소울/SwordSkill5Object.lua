--Properties--

Entity player
Component playerComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	wait(0.1)
	self:ObjectAttack()
	self.playerComponent = self.player.ExtendPlayerComponent
}

[Server]
void ObjectAttack()
{
	local sprite = self.Entity.SpriteRendererComponent
	local timerId = 0
	
	--self:Attack(_SwordSkill5.attackSize[1], _SwordSkill5.attackOffset[1], "start", CollisionGroups.Monster)
	timerId = _TimerService:SetTimerRepeat(function() 
					self:Attack(_SwordSkill5.attackSize[1], _SwordSkill5.attackOffset[1], "idle", CollisionGroups.Monster)
					end, 0.5, 0.5)
	_SoundService:PlaySound(_SwordSkill5.soundRUID[2], 0.75)
	_TimerService:SetTimerOnce(function()
			sprite.SpriteRUID = _SwordSkill5.effectRUID[3]
			end, 1.1)
	_TimerService:SetTimerOnce(function()
			_TimerService:ClearTimer(timerId) 
			sprite.SpriteRUID = _SwordSkill5.effectRUID[4] 
			_SoundService:PlaySound(_SwordSkill5.soundRUID[3], 0.75)
			end, 4.6)
	_TimerService:SetTimerOnce(function() self:Attack(_SwordSkill5.attackSize[1], _SwordSkill5.attackOffset[1], "end", CollisionGroups.Monster) end, 5.1)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 5.9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_EffectService:PlayEffect(_SwordSkill5.hitEffectRUID[1], self.Entity.CurrentMap, defender.TransformComponent.Position, 0, Vector3.one, false)
	_SoundService:PlaySound(_SwordSkill5.hitSoundRUID[1], 1.0)
	if attackInfo == "start" then
		self.player.ExtendPlayerComponent:UpCharge(_SwordSkill5.upChargeRate[1]) 
		return self.playerComponent.atkPoint^1.25 * _SwordSkill5.coefficient[1]
	elseif attackInfo == "idle" then 
		self.player.ExtendPlayerComponent:UpCharge(_SwordSkill5.upChargeRate[2]) 
		return self.playerComponent.atkPoint^1.25 * _SwordSkill5.coefficient[2]
	elseif attackInfo == "end" then
		self.player.ExtendPlayerComponent:UpCharge(_SwordSkill5.upChargeRate[3])  
		return self.playerComponent.atkPoint^1.25 * _SwordSkill5.coefficient[3]
	end
}

[Default]
int32 GetDisplayHitCount(string attackInfo)
{
	if attackInfo == "end" then return 3 end
	return __base:GetDisplayHitCount(attackInfo)
}


--Events--

