--Properties--

boolean isReady = false
number roomIdx = 0
Entity readyButton


--Methods--

[Client Only]
void OnBeginPlay()
{
	wait(1)
	
	if _UserService.LocalPlayer.CurrentMapName ~= "Match" then
		--self.readyButton.Enbale = false
	end
}

[Server]
void OnReady()
{
	self.isReady = true
}

[Server]
void OnCancelReady()
{
	self.isReady = false
}


--Events--

