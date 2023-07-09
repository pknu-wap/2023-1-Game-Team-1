--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	_TimerService:SetTimerOnce(function() self.Entity.Visible = false self.Entity.TriggerComponent.Enable = false end, 12.0)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 13.5)
}


--Events--

[Server Only]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	--------------------------------------------------------
	if TriggerBodyEntity.ExtendPlayerComponent then 
		TriggerBodyEntity.MovementComponent.InputSpeed = 0.75
		TriggerBodyEntity.MovementComponent.JumpForce = 0.5
	end
}

[Default]
HandleTriggerLeaveEvent(TriggerLeaveEvent event)
{
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	--------------------------------------------------------
	if TriggerBodyEntity.ExtendPlayerComponent then 
		TriggerBodyEntity.MovementComponent.InputSpeed = 1.5
		TriggerBodyEntity.MovementComponent.JumpForce = 1.0
	end
}

