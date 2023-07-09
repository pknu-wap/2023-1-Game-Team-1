--Properties--



--Methods--

[Default]
void Function1()
{
	_Debug:OpenInventoryPage()
}


--Events--

[Default]
HandleKeyDownEvent(KeyDownEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: InputService
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local key = event.key
	---------------------------------------------------------
	if key == KeyboardKey.E then
		self:Function1()
	end
}

