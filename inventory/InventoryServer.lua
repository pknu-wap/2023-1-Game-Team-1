--Properties--

string globalKey = "Global_1"
string invenEquipKey = "Inventory_Equip"
string invenConsumeKey = "Inventory_Consume"
string invenEtcKey = "Inventory_Etc"
string invenCostumeKey = "Inventory_Costume"
string equipPropKey = "Equip_Property"
string itemPropKey = "Item_Property"
string nextIDKey = "Next_ID"
number slotCnt = 30
dictionary<string, string> categoryToKey
string categoryEquip = "equip"
string categoryConsume = "consume"
string categoryEtc = "etc"
string categoryCostume = "costume"


--Methods--

[Server Only]
void OnBeginPlay()
{
	-- category와 key 매칭
	
	self.categoryToKey[self.categoryEquip] = self.invenEquipKey
	self.categoryToKey[self.categoryConsume] = self.invenConsumeKey
	self.categoryToKey[self.categoryEtc] = self.invenEtcKey
	self.categoryToKey[self.categoryCostume] = self.invenCostumeKey
}

[Server]
void AddItem(string userId, string category, string itemCode)
{
	-- 아이템을 생성하여 유저의 인벤토리에 추가한다.
	
	log("Add Item")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenData = db:GetAndWait(self.categoryToKey[category])
	invenData = invenData or "{}"
	local inven = _HttpService:JSONDecode(invenData)
	local pos = nil
	
	if category == self.categoryEquip then
		local _, equipPropData = db:GetAndWait(self.equipPropKey)
		equipPropData = equipPropData or "{}"
		local equipProp = _HttpService:JSONDecode(equipPropData)
		
		pos = self:GetEmptySpace(inven)
		local id = self:GetUniqueID()
		inven[pos] = id
		invenData = _HttpService:JSONEncode(inven)
		db:SetAndWait(self.invenEquipKey, invenData)
		
		equipProp[id] = {}
		equipProp[id].code = itemCode
		equipPropData = _HttpService:JSONEncode(equipProp)
		db:SetAndWait(self.equipPropKey, equipPropData)
	else
		local _, itemPropData = db:GetAndWait(self.itemPropKey)
		itemPropData = itemPropData or "{}"
		local itemProp = _HttpService:JSONDecode(itemPropData)
		
		itemProp[itemCode] = itemProp[itemCode] or {}
		local cnt = itemProp[itemCode].cnt or 0
		
		if cnt > 0 then
			pos = itemProp[itemCode].pos
			itemProp[itemCode].cnt = itemProp[itemCode].cnt + 1
		else
			pos = self:GetEmptySpace(inven)
			inven[pos] = itemCode
			itemProp[itemCode].pos = pos
			itemProp[itemCode].cnt = 1
		end
		
	    itemPropData = _HttpService:JSONEncode(itemProp)
		db:SetAndWait(self.itemPropKey, itemPropData)
	end
	
	invenData = _HttpService:JSONEncode(inven)
	db:SetAndWait(self.categoryToKey[category], invenData)
	
	self:UpdateUserData(userId)
}

[Server]
number GetEmptySpace(table inven)
{
	-- 인벤토리에서 가장 앞에 있는 빈칸을 찾는다.
	
	for i = 1, self.slotCnt do
		if not inven[i] then return i end
	end
	
	assert(false, "인벤토리에 빈 공간이 없습니다!")
}

[Server]
void ResetInventory(string userId)
{
	-- 인벤토리를 초기화한다.
	
	log("Reset Inven")
	local db = _DataStorageService:GetUserDataStorage(userId)
	
	db:SetAndWait(self.invenEquipKey, "{}")
	db:SetAndWait(self.invenConsumeKey, "{}")
	db:SetAndWait(self.invenEtcKey, "{}")
	db:SetAndWait(self.invenCostumeKey, "{}")
	db:SetAndWait(self.equipPropKey, "{}")
	db:SetAndWait(self.itemPropKey, "{}")
	
	self:UpdateUserData(userId)
}

[Server]
string GetUniqueID()
{
	local db = _DataStorageService:GetGlobalDataStorage(self.globalKey)
	local _, nextIdData = db:GetAndWait(self.nextIDKey)
	nextIdData = nextIdData or "1"
	
	local id = nextIdData
	local nextId = tonumber(id) + 1
	nextIdData = tostring(nextId)
	db:SetAndWait(self.nextIDKey, nextIdData)
	return id
}

[Server]
void UpdateUserData(string userId)
{
	-- 특정 유저의 인벤토리 데이터를 갱신한다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenEquipData = db:GetAndWait(self.invenEquipKey)
	local _, invenConsumeData = db:GetAndWait(self.invenConsumeKey)
	local _, invenEtcData = db:GetAndWait(self.invenEtcKey)
	local _, invenCostumeData = db:GetAndWait(self.invenCostumeKey)
	local _, equipPropData = db:GetAndWait(self.equipPropKey)
	local _, itemCntData = db:GetAndWait(self.itemPropKey)
	
	local datas = {}
	datas[1] = invenEquipData or "{}"
	datas[2] = invenConsumeData or "{}"
	datas[3] = invenEtcData or "{}"
	datas[4] = invenCostumeData or "{}"
	datas[5] = equipPropData or "{}"
	datas[6] = itemCntData or "{}"
	local datasJson = _HttpService:JSONEncode(datas)
	
	_InventoryClient:UpdateData(datasJson, userId)
}


--Events--

