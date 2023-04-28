--Properties--

string visitedKey = "Visited"


--Methods--

[Default]
void ResetInventory(string userId)
{
	_InventoryServer:ResetInventory(userId)
}


--Events--

[Server Only]
HandleUserEnterEvent(UserEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: UserService
	-- Space: Server
	---------------------------------------------------------
	
	-- Parameters
	local UserId = event.UserId
	---------------------------------------------------------
	local db = _DataStorageService:GetUserDataStorage(UserId)
	local _, visited = db:GetAndWait(self.visitedKey)
	
	--if not visited then
		log("Newbie entered")
		self:ResetInventory(UserId)
		db:SetAndWait(self.visitedKey, "true")
	--end
}

