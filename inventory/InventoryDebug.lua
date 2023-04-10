--Properties--

Entity reset
Entity getElixir
Entity getPowerElixir
Entity getSword


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.reset:ConnectEvent("ButtonClickEvent", self.ResetInventory)
	self.getElixir:ConnectEvent(ButtonClickEvent, function() self:GetItem("consume", "1") end)
	self.getPowerElixir:ConnectEvent(ButtonClickEvent, function() self:GetItem("consume", "2") end)
	self.getSword:ConnectEvent(ButtonClickEvent, function() self:GetItem("equip", "1") end)
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


--Events--

