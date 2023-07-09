--Properties--



--Methods--

[Server Only]
void SpiritProtection(Entity player)
{
	if player.HitComponent then
		player.HitComponent.Enable = false
		_EffectService:PlayEffectAttached("0c975192bb5c48068b18c88d056a33b4", player, Vector3.zero, 0, Vector3.one, false)
		_TimerService:SetTimerOnce(function() player.HitComponent.Enable = true end, 7.0)
	end
}


--Events--

[Default]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	--------------------------------------------------------
	if TriggerBodyEntity.ExtendPlayerComponent then 
		self:SpiritProtection(TriggerBodyEntity)
	end
}

