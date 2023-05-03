--Properties--

Entity selected
number idx = nil


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
	_InventorySlotHandler:Select(self.selected, self.idx)
}

