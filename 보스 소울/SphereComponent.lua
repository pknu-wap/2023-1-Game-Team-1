--Properties--



--Methods--


--Events--

[Server Only]
HandleFootholdCollisionEvent(FootholdCollisionEvent event)
{
	-- Parameters
	local FootholdNormal = event.FootholdNormal
	local ImpactDir = event.ImpactDir
	local ImpactForce = event.ImpactForce
	local ReflectDir = event.ReflectDir
	local Rigidbody = event.Rigidbody
	--------------------------------------------------------
	self.Entity:Destroy()
}

[Server Only]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	--------------------------------------------------------
	if TriggerBodyEntity.ExtendPlayerComponent then
		if TriggerBodyEntity.StateComponent.CurrentStateName ~= "DEAD" then
			TriggerBodyEntity.HitComponent:OnHit(self.Entity, 100, false, nil, 1)
			self.Entity:Destroy()
		end
	end
}

