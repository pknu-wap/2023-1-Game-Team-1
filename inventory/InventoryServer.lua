--Properties--

string globalKey = "Global1"
string invenKey = "Inventory"
string itemPropsKey = "ItemProperty"
string equipPropsKey = "EquipProperty"
string nextIdKey = "NextID"
number slotCnt = 30


--Methods--

[Server]
void AddItem(string userId, string itemCode)
{
	-- 아이템을 생성하여 유저의 인벤토리에 추가한다.
	
	log("Add Item")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenData = db:GetAndWait(self.invenKey)
	local _, itemPropsData = db:GetAndWait(self.itemPropsKey)
	invenData = invenData or self:CreateInventoryData()
	itemPropsData = itemPropsData or "{}"
	local inven = _HttpService:JSONDecode(invenData)
	local itemCnt = _HttpService:JSONDecode(itemPropsData)
	
	
	-- 이미 존재하는 아이템이라면 개수만 +1 한다.
	-- 새로운 아이템이라면 인벤토리의 위쪽 빈칸에 추가한다.
	
	if itemCnt[itemCode] then
		itemCnt[itemCode] = itemCnt[itemCode] + 1
	else
		local pos = self:GetEmptySpace(inven)
		inven[pos] = itemCode
		itemCnt[itemCode] = 1
	end
	
	invenData = _HttpService:JSONEncode(inven)
	itemPropsData = _HttpService:JSONEncode(itemCnt)
	db:SetAndWait(self.invenKey, invenData)
	db:SetAndWait(self.itemPropsKey, itemPropsData)
	
	self:UpdateUserUI(userId)
}

[Server]
string CreateInventoryData()
{
	-- 비어있는 인벤토리 데이터를 생성한다.
	
	local inven = {}
	for i = 1, self.slotCnt do
		inven[i] = "1"
	end
	return _HttpService:JSONEncode(inven)
}

[Server]
number GetEmptySpace(table inven)
{
	-- 인벤토리에서 가장 앞에 있는 빈칸을 찾는다.
	
	for i = 1, self.slotCnt do
		if inven[i] == "1" then return i end
	end
	
	assert(false, "인벤토리에 빈 공간이 없습니다!")
}

[Server]
void UpdateUserUI(string userId)
{
	-- 특정 유저의 인벤토리 UI를 갱신한다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenData = db:GetAndWait(self.invenKey)
	local _, itemPropsData = db:GetAndWait(self.itemPropsKey)
	local _, equipPropsData = db:GetAndWait(self.equipPropsKey)
	invenData = invenData or self:CreateInventoryData()
	itemPropsData = itemPropsData or "{}"
	equipPropsData = equipPropsData or "{}"
	_InventoryClient:UpdateUI(invenData, itemPropsData, equipPropsData, userId)
}

[Server]
void ResetInventory(string userId)
{
	-- 인벤토리를 초기화한다.
	
	log("Reset Inven")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, invenData = db:GetAndWait(self.invenKey)
	local _, itemCntData = db:GetAndWait(self.itemPropsKey)
	
	invenData = self:CreateInventoryData()
	itemCntData = "{}"
	db:SetAndWait(self.invenKey, invenData)
	db:SetAndWait(self.itemPropsKey, itemCntData)
	
	self:UpdateUserUI(userId)
}

[Server]
void AddEquip(string userId, string equipCode)
{
	-- 장비를 생성하여 유저의 인벤토리에 추가한다.
	
	log("Add Equip")
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	
	local _, invenData = db:GetAndWait(self.invenKey)
	invenData = invenData or self:CreateInventoryData()
	local inven = _HttpService:JSONDecode(invenData)
	
	local _, equipPropsData = db:GetAndWait(self.equipPropsKey)
	equipPropsData = equipPropsData or "{}"
	local equipProps = _HttpService:JSONDecode(equipPropsData)
	
	local pos = self:GetEmptySpace(inven)
	local id = self:CreateID()
	inven[pos] = id
	invenData = _HttpService:JSONEncode(inven)
	db:SetAndWait(self.invenKey, invenData)
	
	equipProps.id = {}
	equipProps.id.code = equipCode
	equipPropsData = _HttpService:JSONEncode(equipProps)
	db:SetAndWait(self.equipPropsKey, equipPropsData)
	
	self:UpdateUserUI(userId)
}

[Server]
number CreateID()
{
	local db = _DataStorageService:GetGlobalDataStorage(self.globalKey)
	local _, nextIdData = db:GetAndWait(self.nextIdKey)
	nextIdData = nextIdData or "10001"
	
	local id = tonumber(nextIdData)
	nextIdData = tostring(id + 1)
	db:SetAndWait(self.nextIdKey, nextIdData)
	return id
}


--Events--

