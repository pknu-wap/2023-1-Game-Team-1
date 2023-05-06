--Properties--

table enforceProbability
string probabilityTableName = "EnforceProbability"
number MaxEnforceValue = 7


--Methods--

[Server]
void EnforceWeapon(string userId, integer weaponId)
{
	--woo:강화 시도 함수
	if weaponId >= self.MaxEnforceValue then
		log("Max enforce")
	end
	
	local currentSoul = _InventoryServer:GetSoul(userId)
	local probabilityTable = _DataService:GetTable(self.probabilityTableName)
	
	local probability = tonumber(probabilityTable:GetCell(weaponId, 2))
	local price = tonumber(probabilityTable:GetCell(weaponId, 3))
	local currentNum = math.random(0, 100)
	
	if currentSoul >= price then
		_InventoryServer:SubSoul(userId, price)
		if currentNum > probability then
			log(probability, currentNum.." Enforce Failed!")
	
		else
			log(probability, currentNum.." Enforce Success!")
		
		end
	else
		log("Not enough Soul")
	
	end
}


--Events--

