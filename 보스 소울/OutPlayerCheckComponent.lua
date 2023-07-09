--Properties--

Vector3 spawnPos = Vector3(0,0,0)


--Methods--


--Events--

[Default]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TriggerComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	---------------------------------------------------------
	log("플레이어 다시 돌아가123")
	if isvalid(TriggerBodyEntity.PlayerControllerComponent) then
		log("플레이어 다시 돌아가")
		TriggerBodyEntity.TransformComponent.Position = self.spawnPos;
	end
}

