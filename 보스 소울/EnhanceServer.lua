--Properties--

table enforceProbability
number MaxEnforceValue = 20
integer LoadingBox = 0
integer MsgOKBox = 0
integer MsgYNBox = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.LoadingBox = _Enum.LoadingBox
	self.MsgOKBox = _Enum.MsgOkBox
	self.MsgYNBox = _Enum.MsgYNBox
}

[Server]
void EnforceWeapon(string userId, string weaponId)
{
	-- 공사중
	
	----확률따라 강화 성공 및 실패
	--log("강화시작")
	--
	--_EnhanceTapHandler:DisplayLoadingPage(self.LoadingBox, "loading", false, "강화중.", nil, userId)
	--_EnhanceTapHandler:SetLoadingGauge(20, userId)
	--wait(0.5)
	--local db = _DataStorageService:GetUserDataStorage(userId)
	--local enforceDataSet = _DataService:GetTable(_Enum.KeyDataSetEnforce)
	--
	--local _, equipStatusJson = db:GetAndWait(_InventoryServer.equipStatusKey)
	--local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	--local equip = equipStatus[weaponId]
	--local enforce = tonumber(equip["enforce"])
	--local probability = tonumber(enforceDataSet:GetCell(enforce + 1, "Probability"))
	--
	--local _, resources = db:GetAndWait(_InventoryEnum.resourceStatus)
	--
	----플레이어 자원 체크
	--_EnhanceTapHandler:SetLoadingGauge(50, userId)
	--_EnhanceTapHandler:SetLoadingMessage("강화중..", userId)
	--log("자원 충분")
	--
	--_InventoryServer:AddResource(userId, _Enum.Soul, -150)
	--
	--local randomNumber = math.random(1, 100)
	--local success = false
	--log(randomNumber, probability)
	--if randomNumber <= probability then
	--    --강화 성공
	--    equip["enforce"] = tostring(enforce + 1)
	--    success = true
	--    log("강화 성공!")
	--else
	--    --강화 실패	
	--    success = false
	--    log("강화 실패..")
	--end
	--
	--_EnhanceTapHandler:SetLoadingGauge(70, userId)
	--_EnhanceTapHandler:SetLoadingMessage("강화중...", userId)
	--
	--equipStatus[weaponId] = equip
	--equipStatusJson = _HttpService:JSONEncode(equipStatus)
	--db:SetAndWait(_InventoryServer.equipStatusKey, equipStatusJson)
	--
	--_InventoryServer:EnhanceDataCalculate(userId, weaponId)
	--_InventoryServer:UpdateUserData(userId)
	--
	--
	--
	--_EnhanceTapHandler:SetLoadingGauge(100, userId)
	--_EnhanceTapHandler:SetLoadingMessage("강화중...", userId)
	--
	--_EnhanceTapHandler:EnhanceIsSuccess(success)
}

[Server]
void EquipScroll(string userId, string weaponId, string scrollId)
{
	-- 공사중
	
	--_EnhanceTapHandler:DisplayLoadingPage(self.LoadingBox, "loading", false, "장착중.", nil, userId)
	--_EnhanceTapHandler:SetLoadingGauge(20, userId)
	--
	--local consumeDataSet = _DataService:GetTable(_Enum.KeyDataSetConsume)
	--local db = _DataStorageService:GetUserDataStorage(userId)
	--
	--local _, equipStatusJson = db:GetAndWait(_InventoryServer.equipStatusKey)
	--local _, itemStatusJson = db:GetAndWait(_InventoryServer.itemStatusKey)
	--local _, consumeJson = db:GetAndWait(_InventoryServer.consumeKey)
	--
	--local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	--local itemStatus = _HttpService:JSONDecode(itemStatusJson)
	--local consume = _HttpService:JSONDecode(consumeJson)
	--
	--local consumeStatus = itemStatus[_Enum.KeyConsumeCategory]
	--
	--local error = false
	--local errorMsg = ""
	--
	---- 무기 존재?
	--if equipStatus[weaponId] == nil then
	--    errorMsg = "무기가 없습니다!"
	--    error = true
	--end
	--
	---- 스크롤 존재?
	--if consumeStatus[scrollId] == nil then 
	--    errorMsg = "해당 스크롤이 존재하지 않습니다!"
	--    error = true
	--end
	--
	--local equip = equipStatus[weaponId]
	--
	---- 스크롤 몇개?
	--local scrollAmount = tonumber(consumeStatus[scrollId].cnt)
	--
	--if scrollAmount < 1 then
	--    errorMsg = "스크롤이 0개 입니다"
	--    error = true
	--end
	--
	---- 무기 스크롤 슬롯 비어있나?
	--local cnt = 0
	--
	--for i = 1, 5 do
	--    local text = "scroll"..tostring(i)
	--    if equip[text] ~= "0" then
	--        cnt = cnt + 1
	--    end
	--end
	--
	--if cnt >= tonumber(equip["scrollLimit"]) then
	--    errorMsg = "무기 스크롤 슬롯이 부족합니다!"
	--    error = true
	--end
	--
	--if error then
	--    log(errorMsg)
	--    _EnhanceTapHandler:DisplayLoadingPage(self.MsgOKBox, "오류", true, errorMsg, _Util.EmptyImg, userId)
	--    return
	--end
	--
	---- 장착 시작
	--_EnhanceTapHandler:SetLoadingGauge(60, userId)
	--
	--local text = "scroll"..tostring(cnt + 1)
	--local scroll = consumeDataSet:GetCell(tonumber(scrollId), "typeId")
	--
	--equip[text] = scrollId
	--scrollAmount = scrollAmount - 1
	--
	--consumeStatus[scrollId].cnt = tostring(scrollAmount)
	--
	--equipStatus[weaponId] = equip
	--itemStatus[_Enum.KeyConsumeCategory] = consumeStatus
	--
	--equipStatusJson = _HttpService:JSONEncode(equipStatus)
	--itemStatusJson = _HttpService:JSONEncode(itemStatus)
	--consumeJson = _HttpService:JSONEncode(consume)
	--
	--db:SetAndWait(_InventoryServer.equipStatusKey, equipStatusJson)
	--db:SetAndWait(_InventoryServer.itemStatusKey, itemStatusJson)
	--db:SetAndWait(_InventoryServer.consumeKey, consumeJson)
	--
	--_InventoryServer:EnhanceDataCalculate(userId, weaponId)
	--_EnhanceTapHandler:SetLoadingGauge(100, userId)
	--_InventoryServer:UpdateUserData(userId)
	--
	--wait(0.5)
	--_EnhanceTapHandler:CloseAllLoadingTap(userId)
	--_EnhanceClient:UpdateUI(userId)
	--return
}


--Events--

