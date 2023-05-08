--Properties--

Entity selected
number idx = nil
number itemId = 0
string group = ""


--Methods--

[Client Only]
void OnBeginPlay()
{
	local entity = self.Entity
	local children = entity.Children
	local equipped = children[3]
	self.selected = children[4]
	
	equipped.Enable = false
	self.selected.Enable = false
}


--Events--

[Client Only]
HandleButtonClickEvent(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	--local Entity = event.Entity
	---------------------------------------------------------
	if self.group == "inventory" then
		_InventorySlotHandler:Select(self.selected, self.idx)
	elseif self.group == "enforce" then
		_EnforceSlotHandler:Select(self.selected, self.idx, self.itemId)
	end
}

