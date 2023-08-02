--Properties--

string userDataKey = "UserData"


--Methods--

[Server]
void OnUserEnter(string userId)
{
	-- 유저가 입장하였을 때 클라이언트로부터 호출됩니다. 
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, userDataJson = db:GetAndWait(self.userDataKey)
	
	-- 데이터가 비어있다면 새로 생성합니다.
	
	if not userDataJson then
		self:InitData(userId)
	end
	_UserDataClient:SetUserData(userDataJson, userId)
}

[Server]
void InitData(string userId)
{
	-- 데이터를 새로 생성한 후 저장합니다.
	
	local emptyInven = {}
	
	for i = 1, _UserDataEnum.slotCnt do
		emptyInven[i] = {
			code = -1,
			cnt = 0
		}
	end
	
	local userData = {
	    item = {
	        equip = emptyInven,
	        consume = emptyInven,
	        material = emptyInven,
	        costume = emptyInven
	    },
	    
	    equip = {
			weapon = -1,
			subWeapon = -1,
			hat = -1,
			top = -1,
			bottom = -1,
			gloves = -1,
			shoes = -1
		},
	    
	    resource = {
			soul = 0,
			stone = 0
		},
		
		-- 클래스별 레벨이랑 경험치 정보
		level = {
			sword = {1, 0},
			wand = {1, 0},
			dagger = {1, 0},
			bow = {1, 0}
		},
		
		-- 클래스별 스킬 퀵 슬롯 정보
		quickSlot = {
			sword = {0, 0, 0, 0, 0, 0},
			wand = {0, 0, 0, 0, 0, 0},
			dagger = {0, 0, 0, 0, 0, 0},
			bow = {0, 0, 0, 0, 0, 0}
		},
		
		-- 보스 클리어 여부
		bossClear = {
			Golem = {false, false, false},
			KnightStatue = {false, false, false},
			Stump = {false, false, false},
			Pirate = {false, false, false}
		}
	}
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local userDataJson = _HttpService:JSONEncode(userData)
	
	db:SetAndWait(self.userDataKey, userDataJson)
	_UserDataClient:SetUserData(userDataJson, userId)
}

[Server]
integer FindInsertionPos(string category, string invenJson, string itemCode)
{
	-- 아이템이 삽입될 적절한 슬롯 위치를 반환합니다.
	-- 장비 아이템의 경우 최상단 빈 슬롯의 위치를 반환합니다.
	-- 다른 아이템의 경우 존재하던 아이템의 위치 -> 최상단 빈 슬롯 우선 순위로 반환합니다.
	-- 아이템이 삽입될 슬롯이 존재하지 않으면 nil을 반환합니다.
	
	local inven = _HttpService:JSONDecode(invenJson)
	
	if category ~= "equip" then
		for k, v in ipairs(inven) do
			if v.code == itemCode then
				return k
			end
		end
	end
	
	for k, v in ipairs(inven) do
		if v.code == "" then
			return k
		end
	end
	
	return nil
}

[Server]
integer FindExistingPos(string invenJson, string itemCode)
{
	-- itemCode인 아이템이 존재하는 위치를 반환합니다.
	-- 존재하지 않으면 nil을 반환합니다.
	
	local inven = _HttpService:JSONDecode(invenJson)
	
	for k, v in ipairs(inven) do
		if v.code == itemCode then
			return k
		end
	end
	
	return nil
}

[Server]
boolean CreateItem(string userId, string category, string itemCode, integer itemCnt)
{
	-- 아이템을 itemCnt만큼 생성합니다.
	-- 성공할 경우 true를 반환합니다.
	-- equip 아이템의 경우 itemCnt를 1로 설정해야합니다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local err, userDataJson = db:GetAndWait(self.userDataKey)
	local userData = _HttpService:JSONDecode(userDataJson)
	
	local inven = userData.item[category]
	local invenJson = _HttpService:JSONEncode(inven)
	
	local pos = self:FindInsertionPos(category, invenJson, itemCode)
	if not pos then return false end -- 빈 슬롯이 없을 경우
	
	inven[pos].code = itemCode
	inven[pos].cnt += itemCnt
	
	userDataJson = _HttpService:JSONEncode(userData)
	db:SetAndWait(self.userDataKey, userDataJson)
	
	return true
}

[Server]
boolean RemoveItem(string userId, string category, string itemCode, integer itemCnt)
{
	-- 아이템을 itemCnt만큼 삭제합니다.
	-- 성공할 경우 true를 반환합니다.
	-- equip 아이템의 경우 itemCnt를 1로 설정해야합니다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local err, userDataJson = db:GetAndWait(self.userDataKey)
	local userData = _HttpService:JSONDecode(userDataJson)
	
	local inven = userData.item[category]
	local invenJson = _HttpService:JSONEncode(inven)
	
	local pos = self:FindExistingPos(invenJson, itemCode)
	if not pos then return false end -- 아이템이 존재하지 않을 경우
	
	if inven[pos].cnt > itemCnt then
		inven[pos].cnt -= itemCnt
	elseif inven[pos].cnt == itemCnt then
		inven[pos].code = -1
		inven[pos].cnt = 0
	else -- 아이템이 부족할 경우
		return false
	end
	
	userDataJson = _HttpService:JSONEncode(userData)
	db:SetAndWait(self.userDataKey, userDataJson)
	
	return true
}

[Server]
boolean SetQuickSlot(string userId, string class, table quickSlots)
{
	-- class에 해당하는 퀵 슬롯 저장
	log(quickSlots)
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local err, userDataJson = db:GetAndWait(self.userDataKey)
	local userData = _HttpService:JSONDecode(userDataJson)
	
	userData["quickSlot"][class] = quickSlots
	
	userDataJson = _HttpService:JSONEncode(userData)
	db:SetAndWait(self.userDataKey, userDataJson)
	
	return true
}

[Server]
integer GetItemCnt(string userId, string category, string itemCode)
{
	-- 아이템의 갯수를 반환합니다.
	-- 존재하지 않을 경우 0을 반환합니다.
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local err, userDataJson = db:GetAndWait(self.userDataKey)
	local userData = _HttpService:JSONDecode(userDataJson)
	
	local inven = userData.item[category]
	local invenJson = _HttpService:JSONEncode(inven)
	
	local pos = self:FindExistingPos(invenJson, itemCode)
	if not pos then return 0 end -- 아이템이 존재하지 않을 경우
	
	return inven[pos].cnt
}


--Events--

[Default]
HandleKeyDownEvent(KeyDownEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: InputService
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local key = event.key
	---------------------------------------------------------
	local userId = _UserService.LocalPlayer.Name
	
	if key == KeyboardKey.F2 then
		log("reset data")
		self:InitData(userId)
	end
}

