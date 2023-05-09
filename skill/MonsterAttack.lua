--Properties--

number attackInterval = 0.03


--Methods--

[Server Only]
void OnBeginPlay()
{
	local monster = self.Entity.Monster
	if not monster then
		return
	end
	
	self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
	
	-- sprite 사이즈를 가져와 공격 영역으로 사용한다
	_ResourceService:PreloadAsync({self.Entity.SpriteRendererComponent.SpriteRUID}, function()
		local clip = _ResourceService:LoadAnimationClipAndWait(self.Entity.SpriteRendererComponent.SpriteRUID)
		local firstFrameSprite = clip.Frames[1].FrameSprite
		local firstSpriteSizeInPixel = Vector2(firstFrameSprite.Width, firstFrameSprite.Height)
		local ppu = firstFrameSprite.PixelPerUnit
	
		self._T.spriteSize = firstSpriteSizeInPixel / ppu
		self._T.positionOffset = (firstSpriteSizeInPixel / 2 - firstFrameSprite.PivotPixel:ToVector2()) / ppu
		
		_TimerService:SetTimerRepeat(function() 
			if monster.IsDead == false then
				self:AttackNear()
			end
		end, self.attackInterval)
	end)
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
		self._T.shape.Size = Vector2(self._T.spriteSize.x * math.abs(scaleX), self._T.spriteSize.y * math.abs(scaleY))
		self._T.shape.Position = Vector2(worldPosition.x + offsetX, worldPosition.y + offsetY)
		self._T.shape.Angle = transformComponent.ZRotation
	end
	
	self:AttackFast(self._T.shape, nil, CollisionGroups.Player)
}

[Default]
boolean IsAttackTarget(Entity defender, string attackInfo)
{
	if isvalid(defender.PlayerComponent) == false then
		return false
	end
	
	return __base:IsAttackTarget(defender, attackInfo)
}


--Events--

