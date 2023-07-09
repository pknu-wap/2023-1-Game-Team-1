--Properties--

string dungeonName = ""
Entity DungeonManager


--Methods--


--Events--

[Default]
HandleButtonClickEvent(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	--self.DungeonManager.DungeonManager.dungeonName = self.dungeonName
	--self.DungeonManager:SetEnable(false)
	--_UserService.LocalPlayer.Player.isReady = true
	--
	--log(self.dungeonName .."이름의 던전 버튼 클릭합니다")
	--self.DungeonManager.DungeonManager:enterDungeon(self.dungeonName, _UserService.LocalPlayer.Name)
}

