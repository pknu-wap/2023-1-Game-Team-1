--Properties--

Entity selectFirstSlot
Entity infoFirstSlot
Entity selectedText
Component selectedWeaponIcon
Component enforceGoalIcon
Component enforceSelectIcon
Component infoWeaponName
Component infoWeaponGrade
array<Entity> selectSlotArray
array<InfoSlot> infoSlotArray
dictionary<string, InfoSlot> enforceInfoSlot
number selectSlotCnt = 30
number infoSlotCnt = 10
string selectedWeaponId = ""
Entity enforceButton


--Methods--

[Client Only]
void OnBeginPlay()
{
	
	--woo : Left 탭 무기 정보 슬롯
	self.infoSlotArray[1] = self.infoFirstSlot.InfoSlot
	
	for i = 2, self.infoSlotCnt do
		local slot = self.infoFirstSlot:Clone(nil)
		self.infoSlotArray[i] = slot.InfoSlot
	end
	
	--woo : Left 탭 무기 선택 슬롯
	self.selectSlotArray[1] = self.selectFirstSlot
	self.selectSlotArray[1].InventorySlot.idx = 1
	self.selectSlotArray[1].InventorySlot.group = "enforce"
	
	for i = 2, self.selectSlotCnt do
		local slot = self.selectFirstSlot:Clone(nil)
		slot.InventorySlot.idx = i
		slot.InventorySlot.group = "enforce"
		self.selectSlotArray[i] = slot
	end
	
	--center enforce info slot
	self.enforceInfoSlot["selectedAtk"] = _EntityService:GetEntity("5f3fdaa3-5aae-47d5-a36f-6ade0a87747e").InfoSlot
	self.enforceInfoSlot["selectedEnforce"] = _EntityService:GetEntity("a41301fa-8081-4eca-a211-f27329943f98").InfoSlot
	self.enforceInfoSlot["goalAtk"] = _EntityService:GetEntity("2566b37d-3625-42bb-9e65-ef6949842d36").InfoSlot
	self.enforceInfoSlot["goalEnforce"] = _EntityService:GetEntity("4c17a679-87b9-4573-acad-5b8984e77643").InfoSlot
	
	self.enforceInfoSlot["selectedAtk"]:SetName("Atk")
	self.enforceInfoSlot["selectedEnforce"]:SetName("Enforce")
	self.enforceInfoSlot["goalAtk"]:SetName("Atk")
	self.enforceInfoSlot["goalEnforce"]:SetName("Enforce")
	
	--woo : 강화 버튼
	self.enforceButton:ConnectEvent(ButtonClickEvent, function() self:Enforce() end)
}

[Client Only]
void UpdateUI()
{
	--Update left weapon select tap
	local equips = _InventoryClient.data[_EnforceEnum.EquipStatusKey]
	local cnt = 1
	
	--temporary weaponid
	if self.selectedWeaponId == "" then
		log("empty")
		self.selectedWeaponId = "0" 
	end
	
	for _, table in pairs(equips) do
		if table.id ~= nil then
			self.selectSlotArray[cnt].Children[1].SpriteGUIRendererComponent.ImageRUID = _InventoryClient.img["CategoryEquip"][table["code"]]
			self.selectSlotArray[cnt].InventorySlot.itemId = table.id
			if self.selectedWeaponId == table.id then
				self.selectSlotArray[cnt].Children[3]:SetEnable(true)
			else
				self.selectSlotArray[cnt].Children[3]:SetEnable(false)
			end
			cnt = cnt + 1
		end
	end
	
	for i = cnt, self.selectSlotCnt do
		self.selectSlotArray[i].Children[1].SpriteGUIRendererComponent.ImageRUID = _Util.EmptyImg
	end
	
	--Update left weapon info tap
	local equipDataSet = _DataService:GetTable("EquipDataSet")
	local enforceDataSet = _DataService:GetTable("EnforceData")
	local equipedWeapon = equips[self.selectedWeaponId]
	local img = _InventoryClient.img["CategoryEquip"][equipedWeapon["code"]]
	
	self.selectedWeaponIcon.ImageRUID = img
	self.infoWeaponGrade.Text = ""
	for i = 1, tonumber(equipedWeapon["grade"]) do
		self.infoWeaponGrade.Text = self.infoWeaponGrade.Text .. "★"	
	end
	
	self.infoWeaponName.Text = "+" .. equipedWeapon["enforce"] .. " " .. equipedWeapon["name"]
	
	self.infoSlotArray[1]:SetAll("ATK", equipedWeapon["baseAtkPoint"]) 
	self.infoSlotArray[2]:SetAll("Enforce", equipedWeapon["enforce"] .. "강")
	self.infoSlotArray[3]:SetAll("Grade", equipedWeapon["grade"] .. "성")
	
	
	--Update center enforce tap
	self.enforceGoalIcon.ImageRUID = img
	self.enforceSelectIcon.ImageRUID = img
	
}

[Client Only]
void LeftTapInfoPageOpen(string equipId, number idx)
{
	--Left tap weapon info update
	self.selectedWeaponId = equipId
	self:UpdateUI()
}

[Default]
void Enforce()
{
	local userId = _UserService.LocalPlayer.Name
	_EnforceServer:EnforceWeapon(userId, self.selectedWeaponId)
}


--Events--

