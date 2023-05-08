--Properties--

dictionary<string, string> categoryToKey
string equipKey = "Equip"
string consumeKey = "Consume"
string materialKey = "Material"
string costumeKey = "Costume"
string soulKey = "Soul"
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
string emptyInvenJson = nil
string emptyItemStatusJson = nil
string emptyEquipStatusJson = nil
string globalKey = "Global"


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
	
	self.categoryToKey[self.equipCategory] = self.equipKey
	self.categoryToKey[self.consumeCategory] = self.consumeKey
	self.categoryToKey[self.materialCategory] = self.materialKey
	self.categoryToKey[self.costumeCategory] = self.costumeKey
	
	self.emptyInvenJson = self:GetEmptyInventoryJson()
	self.emptyEquipStatusJson = self:GetEmptyEquipStatusJson()
	self.emptyItemStatusJson = self:GetEmptyItemStatusJson()
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
	status["0"] = "0"
	local json = _HttpService:JSONEncode(status)
	return json
}

[Server]
void ResetInventory(string userId)
{
	-- 인벤토리를 초기화한다.
	
	log("Reset Inven")
	local db = _DataStorageService:GetUserDataStorage(userId)
	local emptyInvenJson = self.emptyInvenJson
	local emptyEquipStatusJson = self.emptyEquipStatusJson
	local emptyItemStatusJson = self.emptyItemStatusJson
	
	--woo:소울 추가
	local zero = "0"
	
	db:SetAndWait(self.equipKey, emptyInvenJson)
	db:SetAndWait(self.consumeKey, emptyInvenJson)
	db:SetAndWait(self.materialKey, emptyInvenJson)
	db:SetAndWait(self.costumeKey, emptyInvenJson)
	--woo:소울 추가
	db:SetAndWait(self.soulKey, zero)
	
	db:SetAndWait(self.equipStatusKey, emptyEquipStatusJson)
	db:SetAndWait(self.itemStatusKey, emptyItemStatusJson)
	
	self:UpdateUserData(userId)
}

[Server]
void AddItem(string userId, string category, string itemCode)
{
	-- 인벤토리에 아이템을 추가한다.
	
	log("add item")
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
		
		equipStatus[id] = {}
		--equipStatus[id].code = itemCode
		--woo:장비 랜덤 생성
		equipStatus[id].code = tostring(math.random(1, 5))
		--woo:여기 장비 수치들 추가
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
	--woo:소울도 같이 업데이트
	local _, soulString = db:GetAndWait(self.soulKey)
	
	local equip = _HttpService:JSONDecode(equipJson)
	local consume = _HttpService:JSONDecode(consumeJson)
	local material = _HttpService:JSONDecode(materialJson)
	local costume = _HttpService:JSONDecode(costumeJson)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local itemStatus = _HttpService:JSONDecode(itemStatusJson)
	
	local data = {}
	data[self.equipCategory] = equip
	data[self.consumeCategory] = consume
	data[self.materialCategory] = material
	data[self.costumeCategory] = costume
	data[self.equipStatus] = equipStatus
	data[self.itemStatus] = itemStatus
	data[self.soulKey] = soulString
	
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
integer GetSoul(string userId)
{
	--woo:소울값 리턴 함수
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, currentSoul = db:GetAndWait(self.soulKey)
	
	return tonumber(currentSoul)
}

[Server]
void SetSoul(string userId, integer inputSoul)
{
	--woo:소울값 inputSoul로 설정
	local db = _DataStorageService:GetUserDataStorage(userId)
	db:SetAndWait(self.soulKey, tostring(inputSoul))
	local _, currentSoul = db:GetAndWait(self.soulKey)
	
	self:UpdateUserData(userId)
}

[Server]
void AddSoul(string userId, integer inputSoul)
{
	--woo:소울값 inputSoul만큼 추가
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, currentSoul = db:GetAndWait(self.soulKey)
	currentSoul = currentSoul + inputSoul
	db:SetAndWait(self.soulKey, tostring(math.floor(currentSoul)))
	
	self:UpdateUserData(userId)
}

[Server]
void SubSoul(string userId, integer inputSoul)
{
	--woo:소울값 inputSoul만큼 추가
	--음수일 경우 0
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, currentSoul = db:GetAndWait(self.soulKey)
	currentSoul = currentSoul - inputSoul
	if currentSoul < 0 then 
		currentSoul = 0 end
	db:SetAndWait(self.soulKey, tostring(math.floor(currentSoul)))
	
	self:UpdateUserData(userId)
}


--Events--

