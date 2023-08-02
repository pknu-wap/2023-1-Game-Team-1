--Properties--

array<ItemSlot> slots
array<ItemSlot> equipSlots
array<InfoSlot> infos
table data
table img
Entity slot
Entity infomation
Entity equip
Entity status
Entity equipSlotButton
Entity sortButton
Component equipSlotButtonText
string userId = nil


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.userId = _UserService.LocalPlayer.Name
	
	-- dataSet 불러오기
	
	local dataSets = {}
	dataSets[_InventoryEnum.equipCategory] = _DataSetEnum.EquipDataSet
	dataSets[_InventoryEnum.consumeCategory] = _DataSetEnum.ConsumeDataSet
	
	for category, dataSetName in pairs(dataSets) do
		self.img[category] = {}
		local dataSet = _DataService:GetTable(dataSetName)
		
		for _, row in ipairs(dataSet:GetAllRow()) do
			local code = row:GetItem("code")
			local img = row:GetItem("img")
			self.img[category][code] = img
		end
	end
	
	-- 슬롯 생성 및 컴포넌트 저장
	
	local slot = self.slot
	
	for idx = 1, _InventoryEnum.slotCnt do
		if idx ~= 1 then slot = self.slot:Clone(nil) end
		self.slots[idx] = slot.ItemSlot:Create(_SlotEnum.Inventory, _SlotEnum.Items, idx)
	end
	
	-- 장비 착용 슬롯 저장
	for idx, equip in ipairs(_EquipEnum.EquipList) do
		self.equipSlots[idx] = self.equip:GetChildByName(equip).ItemSlot:Create(_SlotEnum.Inventory, _SlotEnum.Equipment, idx)
	end
	
	-- 장비 장착 토글 버튼 변수
	
	self._T.isMain = true
	
	-- 버튼 연결
	self.equipSlotButton:ConnectEvent(ButtonClickEvent, function() self:Toggle() end)
	self.sortButton:ConnectEvent(ButtonClickEvent, function() self:Sort() end)
	
	-- 서버 데이터 불러오기
	
	_InventoryServer:UpdateUserData(self.userId)
}

[Client]
void UpdateUI()
{
	-- UI 갱신
	log("inventory update ui")
	self:UpdateInfo()
	self:UpdateCategory()
	self:UpdateAllSlots()
}

[Client]
void UpdateInfo()
{
	---- EquipInfo update
	--local currentData = _oldUserDataClient:GetCurrentEquip()
	--
	--for idx, equip in ipairs(_EquipEnum.EquipList) do
	--    local itemId = currentData[equip]
	--    local RUID
	--    
	--    if itemId == "" then
	--        itemId = nil
	--        RUID = nil
	--    else
	--        RUID = _oldUserDataClient:GetEquipRUIDById(itemId)
	--    end
	--    
	--    self.equipSlots[idx]:SetItem(itemId, RUID)
	--end
	--
	---- StatusInfo update
	--local statusData = _oldUserDataClient:GetStatus()
	--local userData = _oldUserDataClient:GetUserData()
	
	
	-- AvatarInfo update
	-- 미완성
}

[Client]
void UpdateCategory()
{
	--local category = self.currentCategory
	--local inven = self.data[category]
	--
	--for i = 1, self.slotCnt do
	--    local id = inven[i]
	--    local img = nil
	--    local num = nil
	--    if id == "0" then
	--        id = nil
	--    
	--    elseif category == self.equipCategory then
	--        local code = self.data[self.equipStatus][id].code
	--        img = self.img[category][code]
	--        
	--    else
	--        local code = inven[i]
	--        img = self.img[category][code]
	--        num = self.data[self.itemStatus][category][code].cnt
	--        
	--    end
	--    
	--    self.slots[i]:SetItemNum(id, img, num)
	--end
	--
	-- 공사중
	
	--local equippedWeaponId = self.data[self.currentEquipment][_ItemTypeEnum.Weapon]
	--local subWeaponId = self.data[self.currentEquipment][_ItemTypeEnum.SubWeapon]
	--
	--if equippedWeaponId ~= "0" then
	--    local equippedWeapon = self:GetEquipmentClient(equippedWeaponId)
	--    local unequipped = self.mainWeaponSlot:GetChildByName("UnEquipped")
	--    unequipped:SetEnable(false)
	--    local icon = self.mainWeaponSlot:GetChildByName("Icon")
	--    
	--    icon:SetEnable(true)
	--    icon.SpriteGUIRendererComponent.ImageRUID = equippedWeapon.img
	--end
	--
	--if subWeaponId ~= "0" then
	--    local equippedSubWeapon = self:GetEquipmentClient(subWeaponId)
	--    local unequipped = self.subWeaponSlot:GetChildByName("UnEquipped")
	--    unequipped:SetEnable(false)
	--    local icon = self.subWeaponSlot:GetChildByName("Icon")
	--    icon:SetEnable(true)
	--    icon.SpriteGUIRendererComponent.ImageRUID = equippedSubWeapon.img
	--else
	--    self.subWeaponSlot:GetChildByName("UnEquipped"):SetEnable(true)
	--    self.subWeaponSlot:GetChildByName("Icon"):SetEnable(false)
	--    
	--end
}

[Client]
void UpdateAllSlots()
{
	for slot = 1, #self.slots do
		self.slots[slot]:Update()
	end
	
	for slot =1, #self.equipSlots do
		self.equipSlots[slot]:Update()
	end
}

[Client]
void UpdateData(string json)
{
	local data = _HttpService:JSONDecode(json)
	self.data = data
	self:UpdateUI()
}

[Client]
void Swap(number idx1, number idx2)
{
	local tmp = self.data[self.currentCategory][idx1]
	self.data[self.currentCategory][idx1] = self.data[self.currentCategory][idx2]
	self.data[self.currentCategory][idx2] = tmp
	self:UpdateUI()
	
	local json = _HttpService:JSONEncode(self.data[self.currentCategory])
	_InventoryServer:UpdateData(self.userId, self.currentCategory, json)
}

[Client]
void Sort()
{
	-- 인벤토리를 정렬한다.
	
	log("sort")
	if self.currentCategory == self.equipCategory then
		error("아직 장비 정렬은 지원 X")
	else
	    table.sort(self.data[self.currentCategory], function(a, b)
				if a == "0" then return false
				elseif b == "0" then return true
				else return a<b end
		end)
		self:UpdateUI()
		
		local json = _HttpService:JSONEncode(self.data[self.currentCategory])
		_InventoryServer:UpdateData(self.userId, self.currentCategory, json)
	end
}

[Client]
void Toggle()
{
	self._T.isMain = not self._T.isMain
	
	if self._T.isMain then
		self.equipSlotButtonText.Text = "메인 무기"
	else
		self.equipSlotButtonText.Text = "서브 무기"
	end
}


--Events--

