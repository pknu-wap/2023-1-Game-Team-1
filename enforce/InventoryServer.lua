--Properties--

dictionary<string, string> categoryToKey
string equipKey = "Equip"
string consumeKey = "Consume"
string materialKey = "Material"
string costumeKey = "Costume"
string soulKey = "Soul"
string resourceStatusKey = "Resource"
string equipStatusKey = "EquipStatus"
string itemStatusKey = "ItemStatus"
string uniqueIdKey = "UniqueId"
number slotCnt = nil
string equipCategory = nil
string consumeCategory = nil
string materialCategory = nil
string costumeCategory = nil
string equipStatus = nil
string itemStatus = nil
string resourceStatus = nil
string emptyInvenJson = nil
string emptyItemStatusJson = nil
string emptyEquipStatusJson = nil
string emptyResourceJson = nil
string globalKey = "Global"
table equipElements


--Methods--

[Server Only]
void OnBeginPlay()
{
	-- enum 불러오기
	
	self.slotCnt = _InventoryEnum.slotCnt
	self.equipCategory = _InventoryEnum.equipCategory
	self.consumeCategory = _InventoryEnum.consumeCategory
	self.materialCategory = _InventoryEnum.materialCategory
	self.costumeCategory = _InventoryEnum.costumeCategory
	self.equipStatus = _InventoryEnum.equipStatus
	self.itemStatus = _InventoryEnum.itemStatus
	self.resourceStatus = _InventoryEnum.resourceStatus
	
	self.categoryToKey[self.equipCategory] = self.equipKey
	self.categoryToKey[self.consumeCategory] = self.consumeKey
	self.categoryToKey[self.materialCategory] = self.materialKey
	self.categoryToKey[self.costumeCategory] = self.costumeKey
	self.categoryToKey[self.resourceStatusKey] =self.resourceStatusKey 
	
	self.emptyInvenJson = self:GetEmptyInventoryJson()
	self.emptyEquipStatusJson = self:GetEmptyEquipStatusJson()
	self.emptyItemStatusJson = self:GetEmptyItemStatusJson()
	self.emptyResourceJson = self:GetEmptyResourceJson()
}

[Server]
string GetEmptyInventoryJson()
{
	-- 빈 인벤토리 json을 생성한다.
	
	local inven = {}
	for i = 1, self.slotCnt do
		inven[i] = "0"
	end
	
	local json = _HttpService:JSONEncode(inven)
	return json
}

[Server]
string GetEmptyItemStatusJson()
{
	-- 빈 itemStatus json을 생성한다.
	
	local status = {}
	local categories = {self.consumeCategory, self.materialCategory, self.costumeCategory}
	for _, category in ipairs(categories) do
	    status[category] = {}
		status[category]["0"] = "0"
	end
	
	local json = _HttpService:JSONEncode(status)
	return json
}

[Server]
string GetEmptyEquipStatusJson()
{
	-- 빈 equipStatus json을 생성한다.
	
	local status = {}
	--임시 첫 값 생성
	status["0"] = self:GetNewEquip(1, "0")
	--status["0"] = "0"
	local json = _HttpService:JSONEncode(status)
	return json
}

[Server]
string GetEmptyResourceJson()
{
	local resource = {}
	for i = 1, 6 do
		resource[i] = "0"
	end
	local json = _HttpService:JSONEncode(resource)
	return json
}

[Server]
void ResetInventory(string userId)
{
	-- 인벤토리를 초기화한다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local emptyInvenJson = self.emptyInvenJson
	local emptyEquipStatusJson = self.emptyEquipStatusJson
	local emptyItemStatusJson = self.emptyItemStatusJson
	local emptyResourceJson = self.emptyResourceJson
	
	local zero = "0"
	
	db:SetAndWait(self.equipKey, emptyInvenJson)
	db:SetAndWait(self.consumeKey, emptyInvenJson)
	db:SetAndWait(self.materialKey, emptyInvenJson)
	db:SetAndWait(self.costumeKey, emptyInvenJson)
	db:SetAndWait(self.resourceStatusKey, emptyResourceJson)
	
	db:SetAndWait(self.equipStatusKey, emptyEquipStatusJson)
	db:SetAndWait(self.itemStatusKey, emptyItemStatusJson)
	
	self:UpdateUserData(userId)
}

[Server]
void AddItem(string userId, string category, string itemCode)
{
	-- 인벤토리에 아이템을 추가한다.
	local db = _DataStorageService:GetUserDataStorage(userId)
	local invenKey = self.categoryToKey[category]
	local _, invenJson = db:GetAndWait(invenKey)
	local inven = _HttpService:JSONDecode(invenJson)
	
	if category == self.equipCategory then
		local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
		local equipStatus = _HttpService:JSONDecode(equipStatusJson)
		
		local pos = self:GetEmptySpace(invenJson)
		local id = self:GetUniqueId()
		inven[pos] = id
		
		invenJson = _HttpService:JSONEncode(inven)
		db:SetAndWait(invenKey, invenJson)
		
		--equipStatus[id] = {}
		--equipStatus[id].code = itemCode
	
		local rand = math.random(1, 6)
		--woo:장비 생성 함수로
		equipStatus[id] = self:GetNewEquip(rand, id)
		equipStatusJson = _HttpService:JSONEncode(equipStatus)
		db:SetAndWait(self.equipStatusKey, equipStatusJson)
		
	else
		local _, itemStatusJson = db:GetAndWait(self.itemStatusKey)
		local itemStatus = _HttpService:JSONDecode(itemStatusJson)
		
		if itemStatus[category][itemCode] then
			itemStatus[category][itemCode].cnt = itemStatus[category][itemCode].cnt + 1
		else
			local pos = self:GetEmptySpace(invenJson)
			inven[pos] = itemCode
			itemStatus[category][itemCode] = {}
			itemStatus[category][itemCode].pos = pos
			itemStatus[category][itemCode].cnt = 1
			
			invenJson = _HttpService:JSONEncode(inven)
			db:SetAndWait(invenKey, invenJson)
		end
		
		itemStatusJson = _HttpService:JSONEncode(itemStatus)
		db:SetAndWait(self.itemStatusKey, itemStatusJson)
	end
	
	self:UpdateUserData(userId)
}

[Server]
void RemoveItem(string userId, string category, string itemId)
{
	-- 특정 id의 아이템을 하나 제거한다.
	
	log("Remove Item")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local invenKey = self.categoryToKey[category]
	local _, invenJson = db:GetAndWait(invenKey)
	local inven = _HttpService:JSONDecode(invenJson)
	
	if category == self.equipCategory then
		error("장비 삭제 아직 구현 중")
	else
		local _, itemStatusJson = db:GetAndWait(self.itemStatusKey)
		local itemStatus = _HttpService:JSONDecode(itemStatusJson)
		assert(itemStatus[category][itemId], "삭제할 아이템이 존재하지 않습니다!")
		itemStatus[category][itemId].cnt = itemStatus[category][itemId].cnt - 1
		if itemStatus[category][itemId].cnt <= 0 then
			local pos = itemStatus[category][itemId].pos
			inven[pos] = "0"
			itemStatus[category][itemId] = nil
			
			invenJson = _HttpService:JSONEncode(inven)
			db:SetAndWait(invenKey, invenJson)
		end
		
		itemStatusJson = _HttpService:JSONEncode(itemStatus)
		db:SetAndWait(self.itemStatusKey, itemStatusJson)
	end
	
	self:UpdateUserData(userId)
}

[Server]
void RemoveMultipleItems(string userId, string category, string itemCode, number cnt)
{
	-- 특정 code의 아이템을 여러 개 제거한다.
	
	log("Remove multiple Items")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local invenKey = self.categoryToKey[category]
	local _, invenJson = db:GetAndWait(invenKey)
	local inven = _HttpService:JSONDecode(invenJson)
	
	if category == self.equipCategory then
		error("장비 삭제 아직 구현 중")
	else
		local _, itemStatusJson = db:GetAndWait(self.itemStatusKey)
		local itemStatus = _HttpService:JSONDecode(itemStatusJson)
		assert(itemStatus[category][itemCode] and itemStatus[category][itemCode].cnt >= cnt, "삭제할 아이템이 부족하거나 존재하지 않습니다!")
		itemStatus[category][itemCode].cnt = itemStatus[category][itemCode].cnt - cnt
		if itemStatus[category][itemCode].cnt <= 0 then
			local pos = itemStatus[category][itemCode].pos
			inven[pos] = "0"
			itemStatus[category][itemCode] = nil
			
			invenJson = _HttpService:JSONEncode(inven)
			db:SetAndWait(invenKey, invenJson)
		end
		
		itemStatusJson = _HttpService:JSONEncode(itemStatus)
		db:SetAndWait(self.itemStatusKey, itemStatusJson)
	end
	
	self:UpdateUserData(userId)
}

[Server]
number GetEmptySpace(string json)
{
	-- 인벤토리에서 가장 앞에 있는 빈 칸을 찾는다.
	
	local inven = _HttpService:JSONDecode(json)
	for i = 1, self.slotCnt do
		if inven[i] == "0" then return i end
	end
	
	error("인벤토리에 빈 공간이 없습니다!")
}

[Server]
string GetUniqueId()
{
	local db = _DataStorageService:GetGlobalDataStorage(self.globalKey)
	local _, idString = db:GetAndWait(self.uniqueIdKey)
	idString = idString or "1"
	
	local id = tonumber(idString)
	local nextIdString = tostring(id + 1)
	db:SetAndWait(self.uniqueIdKey, nextIdString)
	
	return idString
}

[Server]
void UpdateUserData(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipJson = db:GetAndWait(self.equipKey)
	local _, consumeJson = db:GetAndWait(self.consumeKey)
	local _, materialJson = db:GetAndWait(self.materialKey)
	local _, costumeJson = db:GetAndWait(self.costumeKey)
	local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
	local _, itemStatusJson = db:GetAndWait(self.itemStatusKey)
	--자원 업데이트
	local _, resourceStatusJson = db:GetAndWait(self.resourceStatusKey)
	
	local equip = _HttpService:JSONDecode(equipJson)
	local consume = _HttpService:JSONDecode(consumeJson)
	local material = _HttpService:JSONDecode(materialJson)
	local costume = _HttpService:JSONDecode(costumeJson)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local itemStatus = _HttpService:JSONDecode(itemStatusJson)
	local resourceStatus = _HttpService:JSONDecode(resourceStatusJson)
	
	local data = {}
	data[self.equipCategory] = equip
	data[self.consumeCategory] = consume
	data[self.materialCategory] = material
	data[self.costumeCategory] = costume
	data[self.equipStatus] = equipStatus
	data[self.itemStatus] = itemStatus
	data[self.resourceStatusKey] = resourceStatus
	
	local json = _HttpService:JSONEncode(data)
	_InventoryClient:UpdateData(json, userId)
}

[Server]
void UpdateData(string userId, string category, string invenJson)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local invenKey = self.categoryToKey[category]
	db:SetAndWait(invenKey, invenJson)
}

[Server]
integer GetResource(string userId, number resourceNum)
{
	--woo:소울값 리턴 함수
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, resourceJson = db:GetAndWait(self.resourceStatusKey)
	local resource = _HttpService:JSONDecode(resourceJson)
	
	return tonumber(resource[resourceNum])
}

[Server]
void SetResource(string userId, number resourceNum, number value)
{
	--woo:소울값 inputSoul로 설정
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, resourceJson = db:GetAndWait(self.resourceStatusKey)
	local resource = _HttpService:JSONDecode(resourceJson)
	
	resource[resourceNum] = tostring(value)
	
	resourceJson = _HttpService:JSONEncode(resource)
	db:SetAndWait(self.resourceStatusKey, resourceJson)
	
	self:UpdateUserData(userId)
}

[Server]
void AddResource(string userId, number resourceNum, number value)
{
	--소울값 value만큼 더하기
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, resourceJson = db:GetAndWait(self.resourceStatusKey)
	local resource = _HttpService:JSONDecode(resourceJson)
	local current = math.floor(tonumber(resource[resourceNum]) + value)
	
	if current < 0 then
		current = 0
	end
	
	resource[resourceNum] = tostring(current)
	
	resourceJson = _HttpService:JSONEncode(resource)
	db:SetAndWait(self.resourceStatusKey, resourceJson)
	
	self:UpdateUserData(userId)
}

[Server]
table GetNewEquip(integer code, string id)
{
	local equipData = _DataService:GetTable("EquipDataSet"):GetRow(code)
	
	local equip = {}
	for _, element in pairs(self.equipElements) do
		equip["id"] = id
		equip[element] = equipData:GetItem(element)
	end
	
	equip["enforce"] = "0"
	equip["enforceAddAtk"] = "0"
	
<<<<<<< HEAD
	
	
=======
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
	equip["finalAtkPoint"] = equip["baseAtkPoint"]
	
	return equip
}

[Server]
void EquipDataCalculate(string userId, string id)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local equip = equipStatus[id]
	
	--타입에 따라 나누기
	if equip["type"] == "1" then
<<<<<<< HEAD
		local enforceData = _DataService:GetTable(_EnforceEnum.DataSetEnforce)
		local equipData = _DataService:GetTable(_EnforceEnum.DataSetEquip)
=======
		local enforceData = _DataService:GetTable(_EnforceEnum.EnforceDataSet)
		local equipData = _DataService:GetTable(_EnforceEnum.EquipDataSet)
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
		
		local enforceValue = tonumber(equip["enforce"]) + 1
		
		local baseAtk = tonumber(equip["baseAtkPoint"])
		local fixed = tonumber(enforceData:GetCell(enforceValue, "FixedAdd"))
		local ratio = tonumber(enforceData:GetCell(enforceValue, "RatioAdd"))
		local enforceAdd = fixed + math.floor(baseAtk * ratio / 100) 
		local finalAtk = baseAtk + enforceAdd
		
		equip["enforceAddAtk"] = tostring(enforceAdd)
		equip["finalAtkPoint"] = tostring(finalAtk)
	end
	
	equipStatus[id] = equip
	equipStatusJson = _HttpService:JSONEncode(equipStatus)
	db:SetAndWait(self.equipStatusKey, equipStatusJson)
}


--Events--

