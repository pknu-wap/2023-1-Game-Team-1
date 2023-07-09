--Properties--

Entity ui


--Methods--

[Default]
void HideUI()
{
	self.ui.Enable = false;
}


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
	self:HideUI()
}

