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
	log("보스 이름 " ..boss.Name)
	
	boss.BossAIComponent:GetPlayer()
}

