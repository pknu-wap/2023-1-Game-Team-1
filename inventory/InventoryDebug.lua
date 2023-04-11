--Properties--

Entity reset
Entity getElixir
Entity getPowerElixir
Entity getSword
Entity removeElixir


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.reset:ConnectEvent("ButtonClickEvent", self.ResetInventory)
	self.getElixir:ConnectEvent(ButtonClickEvent, function() self:GetItem("consume", "1") end)
	self.getPowerElixir:ConnectEvent(ButtonClickEvent, function() self:GetItem("consume", "2") end)
	self.getSword:ConnectEvent(ButtonClickEvent, function() self:GetItem("equip", "1") end)
	self.removeElixir:ConnectEvent(ButtonClickEvent, function() self:RemoveItem("consume", "1") end)
}

[Default]
void ResetInventory()
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:ResetInventory(id)
}

[Default]
void GetItem(string category, string code)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddItem(id, category, code)
}

[Default]
void RemoveItem(string category, string itemId)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:RemoveItem(id, category, itemId)
}


--Events--

