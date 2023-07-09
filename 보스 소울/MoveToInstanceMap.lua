--Properties--

string map = nil
number key = 0


--Methods--

[Server]
void MoveToMap(string userId)
{
	_RoomService:MoveUserToInstanceRoom(tostring(self.key), userId, self.map)
	self.key = self.key + 1
}


--Events--

[Default]
HandlePortalUseEvent(PortalUseEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: PortalComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local PortalUser = event.PortalUser
	---------------------------------------------------------
	--self:MoveToMap(PortalUser.Name)
}

