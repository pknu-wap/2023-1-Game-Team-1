--Properties--

Entity player
Component playerComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	wait(0.1)
	self.playerComponent = self.player.ExtendPlayerComponent
	self:ObjectAttack()
}

[Server]
void ObjectAttack()
{
	local sprite = self.Entity.SpriteRendererComponent
	local timerId = 0
	local attack = function()
		self:Attack(_WandSkill4.attackSize[1], _WandSkill4.attackOffset[1], "Attack", CollisionGroups.Monster)
		self:Attack(_WandSkill4.attackSize[1], _WandSkill4.attackOffset[1], "Heal", CollisionGroups.Player)
	end
	timerId = _TimerService:SetTimerRepeat(attack, 0.75, 0.5)
	_TimerService:SetTimerOnce(function() 
			sprite.SpriteRUID = _WandSkill4.effectRUID[3]
		end, 0.25)
	_TimerService:SetTimerOnce(function()
			_TimerService:ClearTimer(timerId) 
			sprite.SpriteRUID = _WandSkill4.effectRUID[4]
		end, 4.3)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 5.0)
}

[Default]
boolean IsAttackTarget(Entity defender, string attackInfo)
{
	if attackInfo == "Heal" then
		_WandSkill4:EnableBuff(defender)
		self.player.ExtendPlayerComponent:UpCharge(_WandSkill4.upChargeRate[1]) 
		return false
	else
		return true
	end
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_EffectService:PlayEffect(_WandSkill4.hitEffectRUID[1], defender.Parent, defender.TransformComponent.Position, 0, Vector3.one, false)
	_SoundService:PlaySound(_WandSkill4.hitSoundRUID[1], 1.0, self.player.Name)
	self.player.ExtendPlayerComponent:UpCharge(_WandSkill4.upChargeRate[1])
	return self.playerComponent.atkPoint^1.25 * _WandSkill4.coefficient[1]
}


--Events--

