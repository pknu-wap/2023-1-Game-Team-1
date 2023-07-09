--Properties--

Entity ui


--Methods--

[Client]
void ShowUI()
{
	self.ui.Enable = true
}


--Events--

[Default]
HandleTouchEvent(TouchEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TouchReceiveComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local TouchId = event.TouchId
	local TouchPoint = event.TouchPoint
	---------------------------------------------------------
	self:ShowUI()
}

