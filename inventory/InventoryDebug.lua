--Properties--

Entity getElixer
Entity getPowerElixer
Entity getSword
Entity rmElixer
Entity rmPowerElixer
Entity rmPowerElixer3
Entity reset


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.getElixer:ConnectEvent(ButtonClickEvent, function() self:AddItem("CategoryConsume", "1") end)
	self.getPowerElixer:ConnectEvent(ButtonClickEvent, function() self:AddItem("CategoryConsume", "2") end)
	self.getSword:ConnectEvent(ButtonClickEvent, function() self:AddItem("CategoryEquip", "1") end)
	self.rmElixer:ConnectEvent(ButtonClickEvent, function() self:RemoveItem("CategoryConsume", "1") end)
	self.rmPowerElixer:ConnectEvent(ButtonClickEvent, function() self:RemoveItem("CategoryConsume", "2") end)
	self.rmPowerElixer3:ConnectEvent(ButtonClickEvent, function() self:RmItems("CategoryConsume", "2", 3) end)
	self.reset:ConnectEvent(ButtonClickEvent, function() _InventoryServer:ResetInventory(_UserService.LocalPlayer.Name) end)
}

[Default]
void AddItem(string category, string itemCode)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddItem(id, category, itemCode)
}

[Default]
void RemoveItem(string category, string itemId)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:RemoveItem(id, category, itemId)
}

[Default]
void RmItems(string category, string itemCode, number cnt)
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:RemoveMultipleItems(id, category, itemCode, cnt)
}

[Default]
void Reset()
{
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:ResetInventory(id)
}


--Events--

