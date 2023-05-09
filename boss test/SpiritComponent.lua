--Properties--

number MaxHp = 100
number CurrentHp = 0
number Damage = 200
number delayTime = 0.03
boolean attackOn = false


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.CurrentHp = self.MaxHp
	
	self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
	self.Entity.SpriteRendererComponent.SpriteRUID = "015d476c71a3403ca6bab62c26888d4b"
	
	local treeStart = function()
		self.Entity.SpriteRendererComponent.SpriteRUID = "01d0d3816cca4992bc4a71e7c93601e4"
		local y = self.Entity.TransformComponent.Position.y + 0.5
		self.Entity.TransformComponent.Position.y = y
		
		self.attackOn = true
	end
	
	_TimerService:SetTimerOnce(treeStart, 2)
	
}

[Default]
void AttackNear()
{
	local attackSize = Vector2(1, 0.1)
	local attackOffset = Vector2(0, 0)
		
	self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	
	--self:AttackFast(self._T.shape, nil, CollisionGroups.Player)
}

[Server]
void Destroy()
{
	local stateComponent = self.Entity.StateComponent
	if stateComponent then
		stateComponent:ChangeState("DEAD")
		log("monster change state to DEAD")
	end
	
	local delayHide = function()
		self.Entity:SetVisible(false)
		self.Entity:SetEnable(false)
		
	end
	
	_TimerService:SetTimerOnce(delayHide, 0.5)
}

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return self.Damage
	--return __base:CalcDamage(attacker,defender,attackInfo)
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
	
	--self:Destroy()
	self.Entity:Destroy()
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
		_TimerService:SetTimerRepeat(function() 
				if self.CurrentHp > 0 then
					self:AttackNear()
				end
			end, self.delayTime)
	end
}

