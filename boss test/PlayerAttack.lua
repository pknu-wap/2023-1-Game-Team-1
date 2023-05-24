--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	self._T.shape = BoxShape(Vector2.zero, Vector2.one, 0)
}

[Server Only]
void AttackNormal()
{
	local playerController = self.Entity.PlayerControllerComponent
	local transform = self.Entity.TransformComponent
	if playerController and transform then
		local worldPosition = transform.WorldPosition
		local attackOffset = Vector2(worldPosition.x + 0.5 * playerController.LookDirectionX, worldPosition.y + 0.5)
		self._T.shape.Position = attackOffset
		
		self:AttackFast(self._T.shape, "Normal", CollisionGroups.Monster)
	end
}

[Default]
int CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 50
}

[Default]
boolean CalcCritical(Entity attacker, Entity defender, string attackInfo)
{
	return _UtilLogic:RandomDouble() < 0.3
}

[Default]
number GetCriticalDamageRate()
{
	return 2
}


--Events--

[Default]
HandlePlayerActionEvent(PlayerActionEvent event)
{
	-- Parameters
	local ActionName = event.ActionName
	local PlayerEntity = event.PlayerEntity
	--------------------------------------------------------
	if self:IsClient() then return end
	
	if ActionName == "Attack" then
		self:AttackNormal()
	end
}

