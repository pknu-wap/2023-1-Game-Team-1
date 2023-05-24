--Properties--



--Methods--


--Events--

[Default]
HandleUserEnterEvent(UserEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: UserService
	-- Space: Server
	---------------------------------------------------------
	
	-- Parameters
	local UserId = event.UserId
	---------------------------------------------------------
	log("User Enter ! " ..UserId)
	
	local boss = _EntityService:GetEntityByTag("Boss")
	--log("보스 이름 " ..boss.Name)
	
	boss.BossAIComponent:GetPlayer()
}

[Default]
HandleUserDisconnectEvent(UserDisconnectEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: UserService
	-- Space: Server
	---------------------------------------------------------
	
	-- Parameters
	local DisconnectMapName = event.DisconnectMapName
	local TimeNetworkClosed = event.TimeNetworkClosed
	local UserId = event.UserId
	---------------------------------------------------------
	local boss = _EntityService:GetEntityByTag("Boss")
	
	boss.BossAIComponent:RemovePlayer(UserId)
}

