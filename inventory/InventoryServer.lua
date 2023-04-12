--Properties--

string globalKey = "Global_1"
string invenEquipKey = "Inventory_Equip"
string invenConsumeKey = "Inventory_Consume"
string invenEtcKey = "Inventory_Etc"
string invenCostumeKey = "Inventory_Costume"
string equipPropKey = "Equip_Property"
string itemPropKey = "Item_Property"
string uniqueIdKey = "Unique_Id"
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
	local _, invenJson = db:GetAndWait(self.categoryToKey[category])
	invenJson = invenJson or self:GetEmptyInventoryJson()
	local inven = _HttpService:JSONDecode(invenJson)
	local pos = nil
	
	if category == self.categoryEquip then
		local _, equipPropJson = db:GetAndWait(self.equipPropKey)
		equipPropJson = equipPropJson or "{}"
		local equipProp = _HttpService:JSONDecode(equipPropJson)
		
		pos = self:GetEmptySpace(inven)
		local id = self:GetUniqueID()
		inven[pos] = id
		invenJson = _HttpService:JSONEncode(inven)
		db:SetAndWait(self.invenEquipKey, invenJson)
		
		equipProp[id] = {}
		equipProp[id].code = itemCode
		equipPropJson = _HttpService:JSONEncode(equipProp)
		db:SetAndWait(self.equipPropKey, equipPropJson)
	else
		local _, itemPropJson = db:GetAndWait(self.itemPropKey)
		itemPropJson = itemPropJson or "{}"
		local itemProp = _HttpService:JSONDecode(itemPropJson)
		
		itemProp[category] = itemProp[category] or {}
		itemProp[category][itemCode] = itemProp[category][itemCode] or {}
		local cnt = itemProp[category][itemCode].cnt or 0
		
		if cnt > 0 then
			pos = itemProp[category][itemCode].pos
			itemProp[category][itemCode].cnt = itemProp[category][itemCode].cnt + 1
		else
			pos = self:GetEmptySpace(inven)
			inven[pos] = itemCode
			itemProp[category][itemCode].pos = pos
			itemProp[category][itemCode].cnt = 1
		end
		
	    itemPropJson = _HttpService:JSONEncode(itemProp)
		db:SetAndWait(self.itemPropKey, itemPropJson)
	end
	
	invenJson = _HttpService:JSONEncode(inven)
	db:SetAndWait(self.categoryToKey[category], invenJson)
	
	self:UpdateUserData(userId)
}

[Server]
number GetEmptySpace(table inven)
{
	-- 인벤토리에서 가장 앞에 있는 빈칸을 찾는다.
	
	for i = 1, self.slotCnt do
		if inven[i] == 0 then return i end
	end
	
	assert(false, "인벤토리에 빈 공간이 없습니다!")
}

[Server]
void ResetInventory(string userId)
{
	-- 인벤토리를 초기화한다.
	
	log("Reset Inven")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local emptyInvenJson = self:GetEmptyInventoryJson()
	
	db:SetAndWait(self.invenEquipKey, emptyInvenJson)
	db:SetAndWait(self.invenConsumeKey, emptyInvenJson)
	db:SetAndWait(self.invenEtcKey, emptyInvenJson)
	db:SetAndWait(self.invenCostumeKey, emptyInvenJson)
	db:SetAndWait(self.equipPropKey, "{}")
	db:SetAndWait(self.itemPropKey, "{}")
	
	self:UpdateUserData(userId)
}

[Server]
string GetUniqueID()
{
	local db = _DataStorageService:GetGlobalDataStorage(self.globalKey)
	local _, IdString = db:GetAndWait(self.uniqueIdKey)
	IdString = IdString or "1"
	
	local id = tonumber(IdString)
	local nextIdString = tostring(id + 1)
	db:SetAndWait(self.uniqueIdKey, nextIdString)
	
	return IdString
}

[Server]
void UpdateUserData(string userId)
{
	-- 특정 유저의 인벤토리 데이터를 갱신한다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenEquipJson = db:GetAndWait(self.invenEquipKey)
	local _, invenConsumeJson = db:GetAndWait(self.invenConsumeKey)
	local _, invenEtcJson = db:GetAndWait(self.invenEtcKey)
	local _, invenCostumeJson = db:GetAndWait(self.invenCostumeKey)
	local _, equipPropJson = db:GetAndWait(self.equipPropKey)
	local _, itemPropJson = db:GetAndWait(self.itemPropKey)
	
	local jsons = {}
	local emptyInvenJson = self:GetEmptyInventoryJson()
	jsons[1] = invenEquipJson or emptyInvenJson
	jsons[2] = invenConsumeJson or emptyInvenJson
	jsons[3] = invenEtcJson or emptyInvenJson
	jsons[4] = invenCostumeJson or emptyInvenJson
	jsons[5] = equipPropJson or "{}"
	jsons[6] = itemPropJson or "{}"
	local encodedJsons = _HttpService:JSONEncode(jsons)
	
	_InventoryClient:UpdateData(encodedJsons, userId)
}

[Server]
void RemoveItem(string userId, string category, string itemId)
{
	-- 특정 유저의 인벤토리에서 특정 id의 아이템을 1개 제거한다.
	
	log("remove item")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenJson = db:GetAndWait(self.categoryToKey[category])
	invenJson = invenJson or self:GetEmptyInventoryJson()
	local inven = _HttpService:JSONDecode(invenJson)
	
	if category == self.categoryEquip then
		assert(false, "아직 장비 삭제는 지원하지 않습니다.")
	else
		local _, itemPropJson = db:GetAndWait(self.itemPropKey)
		itemPropJson = itemPropJson or "{}"
		local itemProp = _HttpService:JSONDecode(itemPropJson)
		itemProp[category] = itemProp[category] or {}
		assert(itemProp[category][itemId] and itemProp[category][itemId].cnt > 0, "해당 아이템이 없습니다.")
		itemProp[category][itemId].cnt = itemProp[category][itemId].cnt - 1
		if itemProp[category][itemId].cnt <= 0 then
			local pos = itemProp[category][itemId].pos
			inven[pos] = 0
			itemProp[category][itemId] = nil
			invenJson = _HttpService:JSONEncode(inven)
			db:SetAndWait(self.categoryToKey[category], invenJson)
		end
		itemPropJson = _HttpService:JSONEncode(itemProp)
		db:SetAndWait(self.itemPropKey, itemPropJson)
	end
	
	self:UpdateUserData(userId)
}

[Server]
string GetEmptyInventoryJson()
{
	local inven = {}
	for i = 1, self.slotCnt do
		inven[i] = 0
	end
	
	local invenJson = _HttpService:JSONEncode(inven)
	return invenJson
}


--Events--

