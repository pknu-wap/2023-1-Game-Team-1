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
Entity addEnforceStoneButton
Entity ResetEnforceStoneButton
Entity AddAllRuneButton
Entity ResetAllRuneButton
string userId = ""
number soulValue = 10000
number stoneValue = 3
number runeValue = 10


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
	
	--enforce 버튼
	
	self.addSoulButton:ConnectEvent(ButtonClickEvent, function() self:AddSoul() end)
	self.subSoulButton:ConnectEvent(ButtonClickEvent, function() self:SubSoul() end)
	self.soulCopyButton:ConnectEvent(ButtonClickEvent, function() self:SoulCopy() end)
	self.enforceButton:ConnectEvent(ButtonClickEvent, function() self:Enforce() end)
	self.enforcePopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenEnforcePopup() end)
	self.inventoryPopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenInventoryPopup() end)
	self.addEnforceStoneButton:ConnectEvent(ButtonClickEvent, function() self:AddEnforceStone() end)
	self.AddAllRuneButton:ConnectEvent(ButtonClickEvent, function() self:AddAllRune() end)
	self.ResetAllRuneButton:ConnectEvent(ButtonClickEvent, function() self:AddItem("CategoryConsume", tostring(math.random(3,5))) end)
	self.ResetEnforceStoneButton:ConnectEvent(ButtonClickEvent, function() self:ResetEnforceStone() end)
	
	self.userId = _UserService.LocalPlayer.Name 
}

[Default]
void AddItem(string category, string itemCode)
{
	_InventoryServer:AddItem(self.userId, category, itemCode)
	_EnforceClient:UpdateUI()
}

[Default]
void RemoveItem(string category, string itemId)
{
	_InventoryServer:RemoveItem(self.userId, category, itemId)
}

[Default]
void RmItems(string category, string itemCode, number cnt)
{
	_InventoryServer:RemoveMultipleItems(self.userId, category, itemCode, cnt)
}

[Default]
void Reset()
{
	_InventoryServer:ResetInventory(self.userId)
}

[Client Only]
void AddSoul()
{
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceSoul, self.soulValue)
	_EnforceClient:UpdateUI()
}

[Client Only]
void SubSoul()
{
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceSoul, self.soulValue * -1)
	_EnforceClient:UpdateUI()
}

[Client Only]
void SoulCopy()
{
	_InventoryServer:SetResource(self.userId, _EnforceEnum.ResourceSoul, 1000000)
	_EnforceClient:UpdateUI()
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

[Client]
void AddEnforceStone()
{
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceEnforceStone, self.stoneValue)
	_EnforceClient:UpdateUI()
}

[Client]
void AddAllRune()
{
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceRuneWarrior, self.runeValue)
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceRuneThief, self.runeValue)
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceRuneBowman, self.runeValue)
	_InventoryServer:AddResource(self.userId, _EnforceEnum.ResourceRuneMagician, self.runeValue)
	_EnforceClient:UpdateUI()
}

[Client]
void ResetEnforceStone()
{
	_InventoryServer:SetResource(self.userId, _EnforceEnum.ResourceEnforceStone, 0)
	_EnforceClient:UpdateUI()
}


--Events--

