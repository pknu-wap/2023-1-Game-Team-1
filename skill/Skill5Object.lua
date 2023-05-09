--Properties--

Entity player
table coefficient
Vector2 attackSize = Vector2(0,0)
Vector2 attackOffset = Vector2(0,0)
table effectRUID
string hitEffectRUID = ""
table soundRUID
string hitSoundRUID = ""


--Methods--

[Server Only]
void OnBeginPlay()
{
	local skillData = _DataService:GetTable("SwordSkillData")
	local row = skillData:FindRow("Name", "Skill5")
	self.coefficient = _DataSetToTable:GetNumberTable(row:GetItem("Coefficient"))
	self.attackSize = Vector2(tonumber(row:GetItem("AttackSize.x")), tonumber(row:GetItem("AttackSize.y")))
	self.attackOffset = Vector2(tonumber(row:GetItem("AttackOffset.x")), tonumber(row:GetItem("AttackOffset.y")))
	self.effectRUID = _DataSetToTable:GetStringTable(row:GetItem("EffectRUID"))
	self.hitEffectRUID = row:GetItem("HitEffectRUID")
	self.soundRUID = _DataSetToTable:GetStringTable(row:GetItem("SoundRUID"))
	self.hitSoundRUID = row:GetItem("HitSoundRUID")
	
	self:ObjectAttack()
}

[Server]
void ObjectAttack()
{
	local sprite = self.Entity.SpriteRendererComponent
	local timerId = 0
	
	self:Attack(self.attackSize, self.attackOffset, "start", CollisionGroups.Monster)
	timerId = _TimerService:SetTimerRepeat(function() 
					self:Attack(self.attackSize, self.attackOffset, "idle", CollisionGroups.Monster)
					end, 0.5, 0.5)
	_SoundService:PlaySound(self.soundRUID[2], 0.75)
	_TimerService:SetTimerOnce(function()
			sprite.SpriteRUID = self.effectRUID[3]
			end, 1.1)
	_TimerService:SetTimerOnce(function()
			_TimerService:ClearTimer(timerId) 
			sprite.SpriteRUID = self.effectRUID[4] 
			_SoundService:PlaySound(self.soundRUID[3], 0.75)
			end, 4.6)
	_TimerService:SetTimerOnce(function() self:Attack(self.attackSize, self.attackOffset, "end", CollisionGroups.Monster) end, 5.1)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 5.9)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	_EffectService:PlayEffect(self.hitEffectRUID, self.Entity.CurrentMap, defender.TransformComponent.Position, 0, Vector3.one, false)
	_SoundService:PlaySound(self.hitSoundRUID, 1.0)
	if attackInfo == "start" then return self.coefficient[1] 
	elseif attackInfo == "idle" then return self.coefficient[2]
	elseif attackInfo == "end" then return self.coefficient[3]
	end
}

[Default]
int32 GetDisplayHitCount(string attackInfo)
{
	if attackInfo == "end" then return 3 end
	return __base:GetDisplayHitCount(attackInfo)
}


--Events--

