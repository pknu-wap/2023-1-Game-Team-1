--Properties--

Entity slot
array<SpriteGUIRendererComponent> sprites
array<TextComponent> texts
table data
table img
string equipDataSet = "EquipDataSet"
string consumeDataSet = "ConsumeDataSet"
string emptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"
string currentCategory = nil
string equipCategory = nil
string consumeCategory = nil
string materialCategory = nil
string costumeCategory = nil
string equipStatus = nil
string itemStatus = nil
string userId = nil
number slotCnt = nil


--Methods--

[Client Only]
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
	
	self.currentCategory = self.equipCategory
	self.userId = _UserService.LocalPlayer.Name
	
	-- dataSet 불러오기
	
	local dataSets = {}
	dataSets[self.equipCategory] = self.equipDataSet
	dataSets[self.consumeCategory] = self.consumeDataSet
	
	for category, dataSetName in pairs(dataSets) do
		self.img[category] = {}
		local dataSet = _DataService:GetTable(dataSetName)
		
		for _, row in ipairs(dataSet:GetAllRow()) do
			local code = row:GetItem("code")
			local img = row:GetItem("img")
			self.img[category][code] = img
		end
	end
	
	-- 슬롯 생성 및 컴포넌트 저장
	
	self.slot.InventorySlot.idx = 1
	self.sprites[1] = self.slot.Children[1].SpriteGUIRendererComponent
	self.texts[1] = self.slot.Children[2].TextComponent
	for i = 2, self.slotCnt do
		local slot = self.slot:Clone(nil)
		slot.InventorySlot.idx = i
		self.sprites[i] = slot.Children[1].SpriteGUIRendererComponent
		self.texts[i] = slot.Children[2].TextComponent
	end
	
	-- 서버 데이터 불러오기
	
	_InventoryServer:UpdateUserData(self.userId)
}

[Client]
void UpdateUI(string category)
{
	-- UI 갱신
	
	log("update ui")
	self.currentCategory = category
	local inven = self.data[category]
	
	for i = 1, self.slotCnt do
		local img = nil
		local txt = nil
		
		if inven[i] == 0 then
			img = self.emptyImg
			txt = ""	
		elseif category == self.equipCategory then
			local id = inven[i]
			local code = self.data[self.equipStatus][id].code
			img = self.img[category][code]
		else
			local code = inven[i]
			img = self.img[category][code]
			txt = self.data[self.itemStatus][category][code].cnt
		end
		
		self.sprites[i].ImageRUID = img
		self.texts[i].Text = txt
	end
}

[Client]
void UpdateData(string json)
{
	local data = _HttpService:JSONDecode(json)
	self.data = data
	self:UpdateUI(self.currentCategory)
}

[Client]
void Swap(number idx1, number idx2)
{
	local tmp = self.data[self.currentCategory][idx1]
	self.data[self.currentCategory][idx1] = self.data[self.currentCategory][idx2]
	self.data[self.currentCategory][idx2] = tmp
	self:UpdateUI(self.currentCategory)
	
	local json = _HttpService:JSONEncode(self.data[self.currentCategory])
	_InventoryServer:UpdateData(self.userId, self.currentCategory, json)
}


--Events--

