--Properties--

Entity getElixer
Entity getPowerElixer
Entity getSword
Entity rmElixer
Entity rmPowerElixer
Entity rmPowerElixer3
Entity reset
Entity addSoulButton
Entity subSoulButton
Entity soulCopyButton
Entity enforceButton
Entity enforcePopupButton
Entity inventoryPopupButton
Entity tmpButton
string userId = ""
number soulValue = 100


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
	
	--woo : enforce 버튼
	self.addSoulButton:ConnectEvent(ButtonClickEvent, function() self:AddSoul() end)
	self.subSoulButton:ConnectEvent(ButtonClickEvent, function() self:SubSoul() end)
	self.soulCopyButton:ConnectEvent(ButtonClickEvent, function() self:SoulCopy() end)
	self.enforceButton:ConnectEvent(ButtonClickEvent, function() self:Enforce() end)
	self.enforcePopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenEnforcePopup() end)
	self.inventoryPopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenInventoryPopup() end)
	self.tmpButton:ConnectEvent(ButtonClickEvent, function() self:Tmp() end)
	
	--woo : 이거 미리 선언해둔걸로 바꿨어용
	self.userId = _UserService.LocalPlayer.Name 
}

[Default]
void AddItem(string category, string itemCode)
{
	--local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddItem(self.userId, category, itemCode)
}

[Default]
void RemoveItem(string category, string itemId)
{
	--local id = _UserService.LocalPlayer.Name
	_InventoryServer:RemoveItem(self.userId, category, itemId)
}

[Default]
void RmItems(string category, string itemCode, number cnt)
{
	--local id = _UserService.LocalPlayer.Name
	_InventoryServer:RemoveMultipleItems(self.userId, category, itemCode, cnt)
}

[Default]
void Reset()
{
	--local id = _UserService.LocalPlayer.Name
	_InventoryServer:ResetInventory(self.userId)
}

[Client Only]
void AddSoul()
{
	_InventoryServer:AddSoul(self.userId, self.soulValue)
}

[Client Only]
void SubSoul()
{
	_InventoryServer:SubSoul(self.userId, self.soulValue)
}

[Client Only]
void SoulCopy()
{
	_InventoryServer:SetSoul(self.userId, 10000)
}

[Client Only]
void Enforce()
{
	
}

[Client Only]
void OpenEnforcePopup()
{
	_PopupHandler:OpenPage("enforce")
}

[Client Only]
void OpenInventoryPopup()
{
	_PopupHandler:OpenPage("inventory")
}

[Default]
void Tmp()
{
	_EnforceClient:LoadWeaponPage()
}


--Events--

