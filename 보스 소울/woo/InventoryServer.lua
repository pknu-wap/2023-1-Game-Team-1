--Properties--

dictionary<string, string> categoryToKey
string equipKey = "Equip"
string consumeKey = "Consume"
string materialKey = "Material"
string costumeKey = "Costume"
string resourceStatusKey = "Resource"
string equipStatusKey = "EquipStatus"
string itemStatusKey = "ItemStatus"
string uniqueIdKey = "UniqueId"
string currentEquipmentKey = "currentEquipment"
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
string emptyCurrentEquipmentJson = nil
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
	self.emptyCurrentEquipmentJson = self:GetEmptyCurrentEquipmentJson()
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
string GetEmptyCurrentEquipmentJson()
{
	local currentEquipment = {}
	for i = 1, 7 do
		currentEquipment[i] = "0"
	end
	
	local json = _HttpService:JSONEncode(currentEquipment)
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
	local emptyCurrentEquipment = self.emptyCurrentEquipmentJson
	
	
	
	db:SetAndWait(self.equipKey, emptyInvenJson)
	db:SetAndWait(self.consumeKey, emptyInvenJson)
	db:SetAndWait(self.materialKey, emptyInvenJson)
	db:SetAndWait(self.costumeKey, emptyInvenJson)
	db:SetAndWait(self.resourceStatusKey, emptyResourceJson)
	db:SetAndWait(self.currentEquipmentKey, emptyCurrentEquipment)
	
	db:SetAndWait(self.equipStatusKey, emptyEquipStatusJson)
	db:SetAndWait(self.itemStatusKey, emptyItemStatusJson)
	
	self:FirstInventorySetting(userId)
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
	
		local rand = tostring(math.random(1, 6))
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
	local _, resourceStatusJson = db:GetAndWait(self.resourceStatusKey)
	local _, currentEquipmentJson = db:GetAndWait(self.currentEquipmentKey)
	
	local equip = _HttpService:JSONDecode(equipJson)
	local consume = _HttpService:JSONDecode(consumeJson)
	local material = _HttpService:JSONDecode(materialJson)
	local costume = _HttpService:JSONDecode(costumeJson)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local itemStatus = _HttpService:JSONDecode(itemStatusJson)
	local resourceStatus = _HttpService:JSONDecode(resourceStatusJson)
	local currentEquipment = _HttpService:JSONDecode(currentEquipmentJson)
	
	local data = {}
	data[self.equipCategory] = equip
	data[self.consumeCategory] = consume
	data[self.materialCategory] = material
	data[self.costumeCategory] = costume
	data[self.equipStatus] = equipStatus
	data[self.itemStatus] = itemStatus
	data[self.resourceStatusKey] = resourceStatus
	data[self.currentEquipmentKey] = currentEquipment
	
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
integer GetResource(string userId, integer resourceNum)
{
	--woo:소울값 리턴 함수
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, resourceJson = db:GetAndWait(self.resourceStatusKey)
	local resource = _HttpService:JSONDecode(resourceJson)
	
	return tonumber(resource[resourceNum])
}

[Server]
void SetResource(string userId, integer resourceNum, integer value)
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
void AddResource(string userId, integer resourceNum, integer value)
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
table GetNewEquip(string code, string id)
{
	local equipData = _DataService:GetTable(_DataSetEnum.EquipDataSet)
	local codeNum = tonumber(code)
	local grade = tonumber(equipData:GetCell(codeNum, _DataSetEnum.Grade))
	local atk = equipData:GetCell(codeNum, _DataSetEnum.InitialAtkPoint)
	local atkspeed = equipData:GetCell(codeNum, _DataSetEnum.InitialAtkSpeed)
	
	local equip = {}
	
	equip[_EquipEnum.Code] = code
	equip[_EquipEnum.Id]   = id
	
	equip[_EquipEnum.EnforceLevel]    = 0
	equip[_EquipEnum.EnforceAtkPoint] = 0
	equip[_EquipEnum.EnforceAtkFixed] = 0
	equip[_EquipEnum.EnforceAtkRatio] = 0
	
	equip[_EquipEnum.BaseAtkPoint] = atk
	equip[_EquipEnum.BaseAtkSpeed] = atkspeed
	
	equip[_EquipEnum.ScrollNum]           = 0
	equip[_EquipEnum.ScrollTotalAtkPoint] = 0
	equip[_EquipEnum.ScrollId]            = {"0", "0", "0", "0", "0"}
	equip[_EquipEnum.ScrollAtkPoint]      = {0, 0, 0, 0, 0}
	equip[_EquipEnum.ScrollLimit]         = tostring(2 + (grade / 2))
	
	equip[_EquipEnum.EnchantMainStatus] = 0
	equip[_EquipEnum.EnchantMainValue]  = 0
	equip[_EquipEnum.EnchantSubStatus]  = 0
	equip[_EquipEnum.EnchantSubValue]   = 0
	
	equip[_EquipEnum.ExperienceLevel] = 0
	equip[_EquipEnum.ExperiencePoint] = 0
	
	equip[_EquipEnum.FinalAtkPoint] = atk
	
	return equip
}

[Server]
table GetEquipByCode(string code)
{
	local data = _DataService:GetTable(_DataSetEnum.EquipDataSet):GetRow(tonumber(code))
	local equipData = {}
	
	equipData[_DataSetEnum.Code] = data:GetItem(_DataSetEnum.Code)
	equipData[_DataSetEnum.Type] = data:GetItem(_DataSetEnum.Type)
	equipData[_DataSetEnum.Grade] = data:GetItem(_DataSetEnum.Grade)
	equipData[_DataSetEnum.Img] = data:GetItem(_DataSetEnum.Img)
	equipData[_DataSetEnum.AttackPoint] = data:GetItem(_DataSetEnum.AttackPoint)
	equipData[_DataSetEnum.AttackSpeed] = data:GetItem(_DataSetEnum.AttackSpeed)
	equipData[_DataSetEnum.Description] = data:GetItem(_DataSetEnum.Description)
	
	return equipData
}

[Server]
table GetEquipById(string userId, string equipId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipJson = db:GetAndWait(self.equipKey)
	
	local equip = _HttpService:JSONDecode(equipJson)
	
	return equip[equipId]
}

[Server]
void SetEquip(string userId, string equipId, table equip)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	
	equipStatus[equipId] = equip
	
	equipStatusJson = _HttpService:JSONEncode(equipStatus)
	db:SetAndWait(self.equipStatusKey, equipStatusJson)
	
	self:UpdateUserData(userId)
}

[Server]
table EnhanceDataCalculate(table equip)
{
	local equipData = self:GetEquipByCode(equip[_EquipEnum.Code])
	
	--타입에 따라 나누기
	if equipData[_DataSetEnum.Type] == _ItemTypeEnum.Weapon then	
		-- dataset 불러오기
		local enforceData = _DataService:GetTable(_DataSetEnum.EnforceDataSet)
		local scrollData = _DataService:GetTable(_DataSetEnum.ScrollDataSet)
		
		-- 무기 정보
		local enforceLevel = equip[_EquipEnum.EnforceLevel]
		local initialAtk = tonumber(equipData[_DataSetEnum.InitialAtkPoint])
		local grade = tonumber(equipData[_DataSetEnum.Grade])
		
		-- 재련
		local fixedAtk = tonumber(enforceData:GetCell(enforceLevel + 1, _DataSetEnum.Fixed))
		local ratio = tonumber(enforceData:GetCell(enforceLevel + 1, _DataSetEnum.Ratio))
		local ratioAtk = initialAtk * ratio
		
		local enforceAtk = fixedAtk + ratioAtk
		local baseAtk = initialAtk + enforceAtk
		
		equip[_EquipEnum.EnforceAtkFixed] = fixedAtk
		equip[_EquipEnum.EnforceAtkRatio] = ratioAtk
		equip[_EquipEnum.EnforceAtkPoint] = enforceAtk
		equip[_EquipEnum.BaseAtkPoint] = baseAtk
	 
		-- 스크롤
		local scrollAtkTotal = 0
		local scrollNum = 0
		for idx = 1, 5 do
			local scrollId = equip[_EquipEnum.ScrollId][idx]
			local scrollAtk = 0
			
			if scrollId ~= "0" then
				local scroll = scrollData:GetRow(tonumber(scrollId))
				local type = scroll:GetItem(_DataSetEnum.Type)
				local value = tonumber(scroll:GetItem(_DataSetEnum.Value))
				
				if type == _DataSetEnum.TypeFixed then scrollAtk = value
				elseif type == _DataSetEnum.TypeRatio then scrollAtk = baseAtk * value end
				scrollNum = scrollNum + 1
			end
			
			equip[_EquipEnum.ScrollAtkPoint][idx] = 0
			scrollAtkTotal = scrollAtkTotal + scrollAtk
		end
		
		equip[_EquipEnum.ScrollNum] = scrollNum
		equip[_EquipEnum.ScrollTotalAtkPoint] = scrollAtkTotal
		equip[_EquipEnum.ScrollLimit] = 2 + (grade / 2)
		
		local finalAtk = baseAtk + scrollAtkTotal
		equip[_EquipEnum.FinalAtkPoint] = finalAtk
	end
	
	return equip
}

[Server]
void EquipEquipment(string userId, integer parts, string itemId)
{
	--local db = _DataStorageService:GetUserDataStorage(userId)
	--local _, currentEquipmentJson = db:GetAndWait(self.currentEquipmentKey)
	--local currentEquipment = _HttpService:JSONDecode(currentEquipmentJson)
	--
	--local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
	--local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	--
	--currentEquipment[parts] = itemId
	--
	--currentEquipmentJson = _HttpService:JSONEncode(currentEquipment)
	--db:SetAndWait(self.currentEquipmentKey, currentEquipmentJson)
	--
	--local userEntity = _UserService:GetUserEntityByUserId(userId)
	--
	--local equipment = equipStatus[itemId]
	--local equipmentAtk = equipment["finalAtkPoint"]
	--
	--userEntity.ExtendPlayerComponent:UpdateAtkPoint(equipmentAtk)
	--
	--db:SetAndWait("Atk", equipmentAtk)
	--
	--self:UpdateUserData(userId)
}

[Server]
void FirstInventorySetting(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipStatusJson = db:GetAndWait(self.equipStatusKey)
	local _, equipJson = db:GetAndWait(self.equipKey)
	local _, currentEquipmentJson = db:GetAndWait(self.currentEquipmentKey)
	
	local equip = _HttpService:JSONDecode(equipJson)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local currentEquipment = _HttpService:JSONDecode(currentEquipmentJson)
	
	local id = self:GetUniqueId()
	equip[1] = id
	
	equipStatus[id] = self:GetNewEquip("1", id)
	currentEquipment[_ItemTypeEnum.Weapon] = id
	
	equipJson = _HttpService:JSONEncode(equip)
	equipStatusJson = _HttpService:JSONEncode(equipStatus)
	currentEquipmentJson = _HttpService:JSONEncode(currentEquipment)
	
	db:SetAndWait(self.equipKey, equipJson)
	db:SetAndWait(self.equipStatusKey, equipStatusJson)
	db:SetAndWait(self.currentEquipmentKey, currentEquipmentJson)
	
	_Debug:SoulCopy(userId)
	
	self:UpdateUserData(userId)
}


--Events--

