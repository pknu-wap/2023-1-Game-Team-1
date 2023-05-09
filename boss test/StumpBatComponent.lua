--Properties--



--Methods--

[Default]
integer CalcDamage(Entity attacker, Entity defender, string attackInfo)
{
	return 300
}


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
	log("부딫힘")
	self.Entity:Destroy()
}

