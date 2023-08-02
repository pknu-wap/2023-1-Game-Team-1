--Properties--

Entity ui


--Methods--

[Client]
void ShowUI()
{
	--self.ui.Enable = true
	_UIWindowHandler:OpenWindow(_UIEnum.BossSelect, nil, nil)
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

