--Properties--

table enforceProbability
number MaxEnforceValue = 7


--Methods--

[Server]
void EnforceWeapon(string userId, string weaponId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, equipStatusJson = db:GetAndWait(_InventoryServer.equipStatusKey)
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local equip = equipStatus[weaponId]
	local enforce = tonumber(equip["enforce"])
	
	equip["enforce"] = tostring(enforce + 1)
	
	equipStatus[weaponId] = equip
	equipStatusJson = _HttpService:JSONEncode(equipStatus)
	db:SetAndWait(_InventoryServer.equipStatusKey, equipStatusJson)
	
	_InventoryServer:EquipDataCalculate(userId, weaponId)
	_InventoryServer:UpdateUserData(userId)
	_EnforceClient:UpdateUI()
	
	--local enforceData = _DataService:GetTable(_EnforceEnum.EnforceDataSet)
	--
	--local db = _DataStorageService:GetUserDataStorage(userId)
	--local _, equipStatusJson = db:GetAndWait(_InventoryServer.equipStatusKey)
	--local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	--
	--log(equipStatus[weaponId]["name"])
	
	
	--woo:강화 시도 함수
	--if weaponId >= self.MaxEnforceValue then
	--    log("Max enforce")
	--end
	--
	--local currentSoul = _InventoryServer:GetSoul(userId)
	--local probabilityTable = _DataService:GetTable(self.probabilityTableName)
	--
	--local probability = tonumber(probabilityTable:GetCell(weaponId, 2))
	--local price = tonumber(probabilityTable:GetCell(weaponId, 3))
	--local currentNum = math.random(0, 100)
	--
	--if currentSoul >= price then
	--    _InventoryServer:SubSoul(userId, price)
	--    if currentNum > probability then
	--        log(probability, currentNum.." Enforce Failed!")
	--
	--    else
	--        log(probability, currentNum.." Enforce Success!")
	--    
	--    end
	--else
	--    log("Not enough Soul")
	--
	--end
}


--Events--

