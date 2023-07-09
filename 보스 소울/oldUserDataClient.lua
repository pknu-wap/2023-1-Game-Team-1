--Properties--

table itemData
table inventoryData
table equipData
table currentEquipData
table statusData
table userData
table img
string userId = ""


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.userId = _UserService.LocalPlayer.Name
	self:SetImage()
}

[Client]
void SetData(table data)
{
	self.itemData = data[_oldUserDataEnum.ItemData]
	self.inventoryData = data[_oldUserDataEnum.InventoryData]
	self.equipData = data[_oldUserDataEnum.EquipData]
	self.currentEquipData = data[_oldUserDataEnum.CurrentEquipData]
	self.statusData = data[_oldUserDataEnum.StatusData]
	self.userData = data[_oldUserDataEnum.UserData]
}

[Client]
void SetImage()
{
	local dataSets = {}
	dataSets[_oldUserDataEnum.Equip] = _DataSetEnum.EquipDataSet
	dataSets[_oldUserDataEnum.Consume] = _DataSetEnum.ConsumeDataSet
	
	for category, dataSetName in pairs(dataSets) do
		self.img[category] = {}
		local dataSet = _DataService:GetTable(dataSetName)
		
		for _, row in ipairs(dataSet:GetAllRow()) do
			local code = row:GetItem("code")
			local img = row:GetItem("img")
			self.img[category][code] = img
		end
	end
}

[Client]
table GetItemTable(string category)
{
	return self.itemData[category]
}

[Client]
table GetItem(string category, string code)
{
	
}

[Client]
string GetItemRUID(string category, string code)
{
	return self.img[category][code]
}

[Client]
table GetInventory(string category)
{
	return self.inventoryData[category]
}

[Client]
table GetEquipByCode(string code)
{
	local equip = {}
	-- 장비 코드 시작숫자만큼 빼주기
	local codeNum = tonumber(code) - _DataSetEnum.EquipDataStartNum
	local dataSet = _DataService:GetTable(_DataSetEnum.EquipDataSet)
	local row = dataSet:GetRow(codeNum)
	
	for key in _DataSetEnum.EquipDataSetKeys do
		equip[key] = row:GetItem(key)
	end
	
	return equip
}

[Client]
table GetEquipById(string id)
{
	return self.equipData[id]
}

[Client]
string GetEquipRUIDById(string id)
{
	local code = self.equipData[id][_EquipEnum.Code]
	return self.img[_oldUserDataEnum.Equip][code]
	
}

[Client]
table GetCurrentEquip()
{
	return self.currentEquipData
}

[Client]
table GetStatus()
{
	return self.statusData
}

[Client]
table GetUserData()
{
	return self.userData
}


--Events--

