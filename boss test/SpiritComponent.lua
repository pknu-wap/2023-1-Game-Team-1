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
	self.Entity.SpriteRendererComponent.SpriteRUID = "0363d5b19d26454f81e1add4c0e09e9f"
	
	--_EffectService:PlayEffectAttached("00613b24f0c045deab14ba24cdb90187", self.Entity, Vector3.zero, 0, Vector3.one, false)
	-- sprite 사이즈를 가져와 공격 영역으로 사용한다
	local treeStart = function()
		self.Entity.SpriteRendererComponent.SpriteRUID = "01d0d3816cca4992bc4a71e7c93601e4"
		self.attackOn = true
		
		_ResourceService:PreloadAsync({self.Entity.SpriteRendererComponent.SpriteRUID}, function()
			local clip = _ResourceService:LoadAnimationClipAndWait(self.Entity.SpriteRendererComponent.SpriteRUID)
			local firstFrameSprite = clip.Frames[1].FrameSprite
			local firstSpriteSizeInPixel = Vector2(firstFrameSprite.Width, firstFrameSprite.Height)
			local ppu = firstFrameSprite.PixelPerUnit
		
			self._T.spriteSize = firstSpriteSizeInPixel / ppu
			self._T.positionOffset = (firstSpriteSizeInPixel / 2 - firstFrameSprite.PivotPixel:ToVector2()) / ppu
			
		end)
	end
	
	_TimerService:SetTimerOnce(treeStart, 2)
	
}

[Default]
void AttackNear()
{
	local transformComponent = self.Entity.TransformComponent
	
	if isvalid(transformComponent) then
		local worldPosition = transformComponent.WorldPosition
		local scaleX = transformComponent.Scale.x
		local scaleY = transformComponent.Scale.y
		local radian = math.rad(transformComponent.ZRotation)
		local offsetX = math.cos(radian) * self._T.positionOffset.x * scaleX - math.sin(radian) * self._T.positionOffset.y * scaleY
		local offsetY = math.sin(radian) * self._T.positionOffset.x * scaleX + math.cos(radian) * self._T.positionOffset.y * scaleY
		self._T.shape.Size = Vector2(self._T.spriteSize.x * math.abs(scaleX)-0.5, self._T.spriteSize.y * math.abs(scaleY))
		self._T.shape.Position = Vector2(worldPosition.x + offsetX, worldPosition.y + offsetY)
		self._T.shape.Angle = transformComponent.ZRotation
	end
	
	--local attackSize = Vector2(1, 0.1)
	--	local attackOffset = Vector2(0, 0)
		
	--	self:Attack(attackSize, attackOffset, nil, CollisionGroups.Player)
	
	self:AttackFast(self._T.shape, nil, CollisionGroups.Player)
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

