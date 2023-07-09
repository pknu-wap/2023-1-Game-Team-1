--Properties--

number MaxHp = 150
number Hp = 0
boolean isDead = false


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.Hp = self.MaxHp
	self.Entity.StateComponent:RemoveState("HIT")
	local callBack = function()
		self.Entity.HitComponent.Enable = true
		self.Entity.SpriteRendererComponent.SpriteRUID = "c450cf88e3a34f7488f16690e6a17896"
	end
	
	_TimerService:SetTimerOnce(callBack, 1.5)
	
	if not self.isDead then
		_TimerService:SetTimerOnce(self.Vomit, 12.0)
	end
}

[Server Only]
void Vomit()
{
	self.Entity.HitComponent.Enable = false
	self.Entity.SpriteRendererComponent.SpriteRUID = "e809a087d06a4384886b7e07c97a2816"
	_SoundService:PlaySound("eb7f504670a14802a48cc94f4eb66848", 0.75, self.Entity.CurrentMap)
	local callBack = function()
		_SpawnService:SpawnByModelId("model://e228edbf-d989-4bad-b4a6-cb7b49faa027", "PoisonSmoke", 
			self.Entity.TransformComponent.Position, self.Entity.CurrentMap)
		self.Entity:Destroy()
	end
	_TimerService:SetTimerOnce(callBack, 1.35)
}

[Server Only]
void Dead()
{
	self.isDead = true
	local state = self.Entity.StateComponent
	if state then
		state:ChangeState("DEAD")
		self.Entity.SpriteRendererComponent.SpriteRUID = "aa11c9f39cd143b3b6a651bed2d1b573"
		_SoundService:PlaySound("0678e0e681164c56a5341ce150c79c27", 0.75, self.Entity.CurrentMap)
	end
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
		self.Entity:Destroy()
	end
	
	_TimerService:SetTimerOnce(delayHide, 1.8)
}


--Events--

[Default]
HandleHitEvent(HitEvent event)
{
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	--------------------------------------------------------
	if self:IsClient() then return end
	
	local originalHp = self.Hp
	self.Hp = self.Hp - TotalDamage
	
	if self.Hp > 0 or originalHp <= 0 then
		return	
	end
	
	self:Dead()
}

