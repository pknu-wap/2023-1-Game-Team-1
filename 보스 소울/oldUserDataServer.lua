--Properties--

string vistitors = "vistitors"
boolean user = false
boolean administrator = true
integer NextId = 0


--Methods--

[Server]
void UserEnter(string userId)
{
	local data = self:LoadData(userId)
	
	_oldUserDataClient:SetData(data, userId)
	
}

[Server]
void NewbieEnter(string userId)
{
	local data = self:InitData()
	_oldUserDataClient:SetData(data, userId)
	
	self:SaveData(userId, data)
}

[Server]
table InitData()
{
	local items = {}
	
	items[_oldUserDataEnum.Equip] = {}
	items[_oldUserDataEnum.Consume] = {}
	items[_oldUserDataEnum.Material] = {}
	items[_oldUserDataEnum.Costume] = {}
	items[_oldUserDataEnum.Resource] = {}
	
	items[_oldUserDataEnum.Equip]["0"] = "0"
	items[_oldUserDataEnum.Consume]["0"] = 0
	items[_oldUserDataEnum.Material]["0"] = 0
	items[_oldUserDataEnum.Costume]["0"] = 0
	
	items[_oldUserDataEnum.Resource][_oldUserDataEnum.Soul] = 0
	items[_oldUserDataEnum.Resource][_oldUserDataEnum.EnforceStone] = 0
	
	
	local inventory = {}
	
	inventory[_oldUserDataEnum.Equip] = {}
	inventory[_oldUserDataEnum.Consume] = {}
	inventory[_oldUserDataEnum.Material] = {}
	inventory[_oldUserDataEnum.Costume] = {}
	
	for idx = 1, _oldUserDataEnum.InventorySlotNum do
		inventory[_oldUserDataEnum.Equip][idx] = ""
		inventory[_oldUserDataEnum.Consume][idx] = ""
		inventory[_oldUserDataEnum.Material][idx] = ""
		inventory[_oldUserDataEnum.Costume][idx] = ""
	end
	
	
	local equip = {}
	
	
	local currentEquip = {}
	
	currentEquip[_oldUserDataEnum.Weapon] = ""
	currentEquip[_oldUserDataEnum.Hat] = ""
	currentEquip[_oldUserDataEnum.Top] = ""
	currentEquip[_oldUserDataEnum.Bottom] = ""
	currentEquip[_oldUserDataEnum.Gloves] = ""
	currentEquip[_oldUserDataEnum.Shoes] = ""
	currentEquip[_oldUserDataEnum.SubWeapon] = ""
	
	
	local status = {}
	
	status[_oldUserDataEnum.Status] = {}
	status[_oldUserDataEnum.Attribute] = {}
	
	status[_oldUserDataEnum.Status][_oldUserDataEnum.MaxHP] = 0
	status[_oldUserDataEnum.Status][_oldUserDataEnum.MaxMP] = 0
	status[_oldUserDataEnum.Status][_oldUserDataEnum.AttackPoint] = 0
	status[_oldUserDataEnum.Status][_oldUserDataEnum.AttackSpeed] = 0
	status[_oldUserDataEnum.Status][_oldUserDataEnum.MoveSpeed] = 0
	
	status[_oldUserDataEnum.Attribute][_oldUserDataEnum.STR] = 0
	status[_oldUserDataEnum.Attribute][_oldUserDataEnum.DEX] = 0
	status[_oldUserDataEnum.Attribute][_oldUserDataEnum.LUK] = 0
	status[_oldUserDataEnum.Attribute][_oldUserDataEnum.INT] = 0
	
	
	local userData = {}
	userData[_oldUserDataEnum.LastVisit] = 0 --DateTime.UtcNow.Elapsed
	userData[_oldUserDataEnum.VisitGap] = 0
	userData[_oldUserDataEnum.NextID] = 0
	userData[_oldUserDataEnum.Nickname] = "미정"
	userData[_oldUserDataEnum.Job] = "미정"
	
	local data = {}
	
	data[_oldUserDataEnum.ItemData] = items
	data[_oldUserDataEnum.InventoryData] = inventory
	data[_oldUserDataEnum.EquipData] = equip
	data[_oldUserDataEnum.CurrentEquipData] = currentEquip
	data[_oldUserDataEnum.StatusData] = status
	data[_oldUserDataEnum.UserData] = userData
	
	return data
}

[Server]
table LoadData(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	---@type int32, string
	local errCode, dataString
	local errCounter = 0
	
	while true do
		errCode, dataString = db:GetAndWait(_oldUserDataEnum.Data)
		if errCode == 0 then
			log("유저 데이터 불러오기 성공") 
			break
		elseif errCounter <= 2 then
			errCounter += 1 
			log("유저 데이터 불러오기 실패... (" .. errCounter .. " / 3)")
		else
			log("유저 데이터 불러오기 실패.. 종료")
			--종료 이벤트 넣기
			break
		end
	end
	
	return _UtilLogic:StringToTable(dataString)
}

[Server]
void SaveData(string userId, table data)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local dataString = _UtilLogic:TableToString(data)
	db:SetAndWait(_oldUserDataEnum.Data, dataString)
}

[Server]
void AddItem(string userId, string category, string itemCode)
{
	-- inventory에 자리가 있는지 먼저 확인
	-- 자리가 있으면 item에 추가
	local data = self:LoadData(userId)
	local items = data[_oldUserDataEnum.ItemData][category]
	local inven = data[_oldUserDataEnum.InventoryData][category]
	
	
	
}

[Server]
void RemoveItems(string userId, string category, string itemCode, integer value)
{
	
}

[Server]
table GetNewEquip(string code, string id)
{
	
}

[Server]
table EquipEnhanceCalculate(table equip)
{
	
}

[Server]
integer GetEmptySpace(table inven)
{
	for i = 1, _InventoryEnum.slotCnt do
		if inven[i] == "" then return i end
	end
	
	log("인벤토리에 빈 공간이 없습니다!")
	return 0
}


--Events--

[Server Only]
HandleUserEnterEvent(UserEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: UserService
	-- Space: Server
	---------------------------------------------------------
	
	-- Parameters
	local userId = event.UserId
	---------------------------------------------------------
	local visitorsDB = _DataStorageService:GetGlobalDataStorage(self.vistitors)
	---@type int32, string
	local errCode, visitorsString
	local errCounter = 0
	
	while true do
		errCode, visitorsString = visitorsDB:GetAndWait(self.vistitors)
		if errCode == 0 then
			log("방문자 목록 불러오기 성공") 
			break
		elseif errCounter <= 2 then
			errCounter += 1 
			log("방문자 목록 불러오기 실패... (" .. errCounter .. " / 3)")
		else
			log("방문자 목록 불러오기 실패.. 종료")
			--종료 이벤트 넣기
			break
		end
	end
	
	local visitors = {}
	if visitorsString ~= nil then visitors = _UtilLogic:StringToTable(visitorsString) end
	
	if visitors[userId] == nil then
		-- 뉴비 등록
		visitors[userId] = {}
		visitors[userId]["isAdmin"] = false
		visitorsString = _UtilLogic:TableToString(visitors)
		--visitorsDB:SetAndWait(self.vistitors, visitorsString)
		
		-- 어드민 기능 추가
		log("Newbie Enter")
		self:NewbieEnter(userId)
		
	else
		log("User Enter")
		self:UserEnter(userId)
	end
	
}

