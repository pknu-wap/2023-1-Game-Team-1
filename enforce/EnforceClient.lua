--Properties--

Entity slot
array<SpriteGUIRendererComponent> sprites
array<InventorySlot> slots
array<Entity> selected
number slotCnt = 30
string emptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"
string equipKey = "EquipStatus"
string selectedWeaponId = ""
Component selectedWeaponIcon


--Methods--

[Client Only]
void OnBeginPlay()
{
	--woo : 슬롯 설정
	self.slots[1] = self.slot.InventorySlot
	self.slots[1].idx = 1
	self.slots[1].group = "enforce"
	self.sprites[1] = self.slot.Children[1].SpriteGUIRendererComponent
	self.selected[1] = self.slot.Children[3]
	
	for i = 2, self.slotCnt do
		local slot = self.slot:Clone(nil)
		self.slots[i] = slot.InventorySlot
		self.sprites[i] = slot.Children[1].SpriteGUIRendererComponent
		self.selected[i] = slot.Children[3]
		self.slots[i].idx = i
		self.slots[i].group = "enforce"
	end
}

[Client Only]
void LoadEquips()
{
	local equips = _InventoryClient.data[self.equipKey]
	local cnt = 1
	
	log(self.selectedWeaponId)
	
	for _, table in pairs(equips) do
		if table.id ~= nil then
			self.sprites[cnt].ImageRUID = _InventoryClient.img["CategoryEquip"][table["code"]]
			self.slots[cnt].itemId = table.id
			log(table.id)
			if self.selectedWeaponId == table.id then
				self.selected[cnt]:SetEnable(true)
			else
				self.selected[cnt]:SetEnable(false)
			end
			cnt = cnt + 1
		end
	end
	
	for i = cnt, self.slotCnt do
		self.sprites[i].ImageRUID = self.emptyImg
	end
}

[Client Only]
void LoadEnforcePage(string equipId)
{
	local equips = _InventoryClient.data[self.equipKey]
	self.selectedWeaponIcon.ImageRUID = _InventoryClient.img["CategoryEquip"][equips[equipId]["code"]]
	self.selectedWeaponId = equipId
	_EnforceTapHandler:TapOpen("left", "info")
}


--Events--

