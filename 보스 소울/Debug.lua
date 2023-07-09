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
Entity reloadButton
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
Entity debugGroup
boolean debugEnable = false
Entity popupGroup


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
	self.reloadButton:ConnectEvent(ButtonClickEvent, function() self:TmpPlayerSetting() end)
	self.enforcePopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenEnhancePage() end)
	self.inventoryPopupButton:ConnectEvent(ButtonClickEvent, function() self:OpenInventoryPage() end)
	self.addEnforceStoneButton:ConnectEvent(ButtonClickEvent, function() self:AddEnforceStone() end)
	self.AddAllRuneButton:ConnectEvent(ButtonClickEvent, function() self:AddAllRune() end)
	self.ResetAllRuneButton:ConnectEvent(ButtonClickEvent, function() self:AddItem("CategoryConsume", tostring(math.random(3,8))) end)
	self.ResetEnforceStoneButton:ConnectEvent(ButtonClickEvent, function() self:ResetEnforceStone() end)
	
	
	self.userId = _UserService.LocalPlayer.Name 
}

[Default]
void AddItem(string category, string itemCode)
{
	_InventoryServer:AddItem(self.userId, category, itemCode)
	_EnhanceClient:UpdateUI()
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
	_InventoryServer:AddResource(self.userId, _ItemTypeEnum.Soul, self.soulValue)
	_EnhanceClient:UpdateUI()
}

[Client Only]
void SubSoul()
{
	_InventoryServer:AddResource(self.userId, _ItemTypeEnum.Soul, self.soulValue * -1)
	_EnhanceClient:UpdateUI()
}

[Client]
void SoulCopy()
{
	_InventoryServer:SetResource(self.userId, _ItemTypeEnum.Soul, 1000000)
	--_InventoryServer:SetResource(self.userId, _Enum.EnforceStone, 5000)
}

[Client Only]
void TmpPlayerSetting()
{
	_EnhanceClient:UpdateUI()
}

[Client Only]
void OpenEnhancePage()
{
	_UIWindowHandler:OpenWindow(_UIEnum.Enhance, 1, 1)
}

[Client Only]
void OpenInventoryPage()
{
	_UIWindowHandler:OpenWindow(_UIEnum.Inventory, 1, 1)
}

[Client]
void AddEnforceStone()
{
	_InventoryServer:AddResource(self.userId, _ItemTypeEnum.EnforceStone, self.stoneValue)
	_EnhanceClient:UpdateUI()
}

[Client]
void AddAllRune()
{
	--_InventoryServer:AddResource(self.userId, _ItemTypeEnum.RuneWarrior, self.runeValue)
	--_InventoryServer:AddResource(self.userId, _ItemTypeEnum.RuneThief, self.runeValue)
	--_InventoryServer:AddResource(self.userId, _ItemTypeEnum.RuneBowman, self.runeValue)
	--_InventoryServer:AddResource(self.userId, _ItemTypeEnum.RuneMagician, self.runeValue)
	--_EnhanceClient:UpdateUI()
	--_ModalHandler:LoadingOn()
	_UIWindowHandler:OpenWindow(_UIEnum.EquipCraft, nil, nil)
}

[Client]
void ResetEnforceStone()
{
	--_InventoryServer:SetResource(self.userId, _ItemTypeEnum.EnforceStone, 0)
	--_EnhanceClient:UpdateUI()
	_UIWindowHandler:OpenWindow(_UIEnum.BossSelect, nil, nil)
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
	if key == KeyboardKey.F3 then
		self.debugEnable = not self.debugEnable
		self.debugGroup:SetEnable(self.debugEnable)
	end
	---------------------------------------------------------
	
}

