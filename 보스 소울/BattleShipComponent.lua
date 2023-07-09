--Properties--

number MaxHp = 100
number CurrentHp = 0
number Damage = 200
number delayTime = 0.63
boolean attackOn = false
Component stateComponent
Component stateAnimationComponent
Component aiWanderComponent
Component spriteComponent
string spwanSpriteRUID = ""
string idleSpriteRUID = ""
string atkSpriteRUID = ""
string dieSpriteRUID = ""
Component transformComponent
boolean isDie = false


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.CurrentHp = self.MaxHp
	self.stateComponent = self.Entity.StateComponent
	self.stateAnimationComponent = self.Entity.StateAnimationComponent
	self.aiWanderComponent = self.Entity.AIWanderComponent
	self.spriteComponent = self.Entity.SpriteRendererComponent
	self.transformComponent = self.Entity.TransformComponent
	
	self:SetAnimation()
	
	self.spriteComponent.SpriteRUID = self.spwanSpriteRUID
	
	_TimerService:SetTimerOnce(function() 
			self.spriteComponent.SpriteRUID = self.idleSpriteRUID
			self.aiWanderComponent.Enable = true
			self.attackOn = true
			log(self.stateComponent.CurrentStateName)
			end, 0.5)
}

[Default]
void AttackNear()
{
	local attackSize = Vector2(2.368103, 1.416515)
	local attackOffset = Vector2(-1.152746, 0.6520061)
	
	if self.transformComponent.Scale.x == -1 then
		attackOffset.x = attackOffset.x * -1
	end
	
	self.spriteComponent.SpriteRUID = self.atkSpriteRUID
		
	self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	
	_TimerService:SetTimerOnce(function() 
			if self.isDie == false then
				self.spriteComponent.SpriteRUID = self.idleSpriteRUID
			end
			self.attackOn = true
	end, self.delayTime)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return self.Damage
	--return __base:CalcDamage(attacker,defender,attackInfo)
}

[Server Only]
void Dead()
{
	self.attackOn = false
	self.isDie = true
	self.spriteComponent.SpriteRUID = self.dieSpriteRUID
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:Destroy()
		--self.Entity:SetEnable(false)
	end
	
	_TimerService:SetTimerOnce(delayHide, 0.54)
}

[Default]
void SetAnimation()
{
	local num = _UtilLogic:RandomIntegerRange(1, 4)
	
	if num == 1 then
		self.spwanSpriteRUID = "021c405765bd4bd4b22634724f149955"
		self.idleSpriteRUID = "2f38017589454b8286b0453a8c916746"
		self.atkSpriteRUID = "401c171e025f406a9d8ff50a7be423e9"
		self.dieSpriteRUID = "a001442f03ba4f7caf78a3695340a8ee"
	elseif num == 2 then
		self.spwanSpriteRUID = "ac9d8274a5434c91b3b0bdbf260d1247"
		self.idleSpriteRUID = "031f4afa2ca944daa5f5f4dc32958f87"
		self.atkSpriteRUID = "f7bddd2904304735b881809565176bfe"
		self.dieSpriteRUID = "136a7d280c8c42959153d7db9a0a8c72"
	elseif num == 3 then
		self.spwanSpriteRUID = "8e068cbc91fe49099c7f8cc4b85abecb"
		self.idleSpriteRUID = "a8eb42346bfd46269061d4be765b21f6"
		self.atkSpriteRUID = "a4fbac3c7c9549c7b902cbd072328249"
		self.dieSpriteRUID = "082516f084214c5abef7a017a0a259ac"
	elseif num == 4 then
		self.spwanSpriteRUID = "7f5c780deb9c45e3808b13bf7a311679"
		self.idleSpriteRUID = "08600ae436704d89845df8bf58019fd8"
		self.atkSpriteRUID = "c2653c901068436eb670ab72c5020500"
		self.dieSpriteRUID = "5d5c0b1acba741d1b1265ed3c6e85a4b"
	end
	
	
}


--Events--

[Server Only]
HandleHitEvent(HitEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: HitComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	---------------------------------------------------------
	if self:IsClient() then return end
	
	self.CurrentHp = self.CurrentHp - TotalDamage
	
	if self.CurrentHp > 0 then
		return	
	end
	
	self:Dead()
}

[Default]
HandleTriggerStayEvent(TriggerStayEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TriggerComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	---------------------------------------------------------
	
	if isvalid(TriggerBodyEntity.PlayerComponent) and self.attackOn then
		self.attackOn = false
		if self.CurrentHp > 0 then
			self:AttackNear()
		end
	end
}

