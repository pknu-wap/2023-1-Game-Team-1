--Properties--

Entity reset
Entity getElixir
Entity getPowerElixir
Entity getSword


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.reset:ConnectEvent("ButtonClickEvent", self.Reset)
	self.getElixir:ConnectEvent(ButtonClickEvent, function() self:Get("2") end)
	self.getPowerElixir:ConnectEvent(ButtonClickEvent, function() self:Get("3") end)
	self.getSword:ConnectEvent(ButtonClickEvent, function() self:GetEquip("10002") end)
}

[Default]
void Reset()
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:ResetInventory(id)
}

[Default]
void Get(string code)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddItem(id, code)
}

[Default]
void GetEquip(string code)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddEquip(id, code)
}


--Events--

