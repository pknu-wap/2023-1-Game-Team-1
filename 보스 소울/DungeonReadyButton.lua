--Properties--

boolean isReady = false


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
	if self.isReady == true then
		self.isReady = false
		self.Entity.TextComponent.Text = "Ready"
		_UserService.LocalPlayer.Player:OnCancelReady()
	else
		self.isReady = true
		self.Entity.TextComponent.Text = "Cancel"
		_UserService.LocalPlayer.Player:OnReady()
	end
}

