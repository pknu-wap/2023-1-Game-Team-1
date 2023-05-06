--Properties--

Entity slot
array<SpriteGUIRendererComponent> sprites
array<InventorySlot> slots
number slotCnt = 30
string emptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"
string equipKey = "EquipStatus"
Entity enforceButton
Entity removeItemButton


--Methods--

[Client Only]
void OnBeginPlay()
{
	--woo : 슬롯 설정
	self.slots[1] = self.slot.InventorySlot
	self.slots[1].idx = 1
	self.slots[1].group = "enforce"
	self.sprites[1] = self.slot.Children[1].SpriteGUIRendererComponent
	
	for i = 2, self.slotCnt do
		local slot = self.slot:Clone(nil)
		self.slots[i] = slot.InventorySlot
		self.sprites[i] = slot.Children[1].SpriteGUIRendererComponent
		self.slots[i].idx = i
		self.slots[i].group = "enforce"
	end
	
	--woo : 버튼 설정
	self.enforceButton:ConnectEvent(ButtonClickEvent, function() self:LoadEnforcePage() end)
	self.removeItemButton:ConnectEvent(ButtonClickEvent, function() self:LoadEnforcePage() end)
}

[Client Only]
void LoadWeaponPage()
{
	local equips = _InventoryClient.data[self.equipKey]
	local cnt = 1
	
	for id, table in pairs(equips) do
		if id ~= "0" then
			self.sprites[cnt].ImageRUID = _InventoryClient.img["CategoryEquip"][table["code"]]
			self.slots[cnt].itemId = id
			cnt = cnt + 1
		end
	end
	
	for i = cnt, self.slotCnt do
		self.sprites[i].ImageRUID = self.emptyImg
	end
}

[Default]
void LoadEnforcePage()
{
	
}


--Events--

