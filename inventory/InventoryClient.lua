--Properties--

number slotCnt = nil
string equipDataSet = "EquipDataSet"
string consumeDataSet = "ConsumeDataSet"
string etcDataSet = "EtcDataSet"
string costumeDataSet = "CostumeDataSet"
string emptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"
Entity itemSlot
string currentCategory = "equip"
string userId = ""
table itemImg
array<SpriteGUIRendererComponent> sprites
array<TextComponent> texts
table datas
Entity btnEquip
Entity btnConsume
Entity btnEtc
Entity btnCostume
string categoryEquip = nil
string categoryConsume = nil
string categoryEtc = nil
string categoryCostume = nil


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 서버에서 상수 값 불러오기
	
	self.slotCnt = _InventoryServer.slotCnt
	self.categoryEquip = _InventoryServer.categoryEquip
	self.categoryConsume = _InventoryServer.categoryConsume
	self.categoryEtc = _InventoryServer.categoryEtc
	self.categoryCostume = _InventoryServer.categoryCostume
	
	-- 클라이언트 데이터 구조 세팅
	
	self.datas[self.categoryEquip] = {}
	self.datas[self.categoryConsume] = {}
	self.datas[self.categoryEtc] = {}
	self.datas[self.categoryCostume] = {}
	self.datas.equipProp = {}
	self.datas.itemProp = {}
	
	-- 데이터셋에서 아이템 정보 불러오기
	
	self.itemImg[self.categoryEquip] = {}
	local equipDataSet = _DataService:GetTable(self.equipDataSet)
	for _, row in ipairs(equipDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[self.categoryEquip][code] = img
	end
	
	self.itemImg[self.categoryConsume] = {}
	local consumeDataSet = _DataService:GetTable(self.consumeDataSet)
	for _, row in ipairs(consumeDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[self.categoryConsume][code] = img
	end
	
	self.itemImg[self.categoryEtc] = {}
	local etcDataSet = _DataService:GetTable(self.etcDataSet)
	for _, row in ipairs(etcDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[self.categoryEtc][code] = img
	end
	
	self.itemImg[self.categoryCostume] = {}
	local costumeDataSet = _DataService:GetTable(self.costumeDataSet)
	for _, row in ipairs(costumeDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[self.categoryCostume][code] = img
	end
	
	-- 아이템 슬롯 복제 및 스프라이트/텍스트 컴포넌트 저장
	
	table.insert(self.sprites, self.itemSlot.Children[2].SpriteGUIRendererComponent)
	table.insert(self.texts, self.itemSlot.Children[3].TextComponent)
	for i = 1, self.slotCnt - 1 do
	    local slot = self.itemSlot:Clone("")
		table.insert(self.sprites, slot.Children[2].SpriteGUIRendererComponent)
		table.insert(self.texts, slot.Children[3].TextComponent)
	end
	
	-- 플레이어 id 저장
	
	self.userId = _UserService.LocalPlayer.Name
	
	-- 데이터 갱신
	
	_InventoryServer:UpdateUserData(self.userId)
	
	-- 카테고리 버튼 연동
	
	self.btnEquip:ConnectEvent(ButtonClickEvent, function() self:UpdateUI(self.categoryEquip) end)
	self.btnConsume:ConnectEvent(ButtonClickEvent, function() self:UpdateUI(self.categoryConsume) end)
	self.btnEtc:ConnectEvent(ButtonClickEvent, function() self:UpdateUI(self.categoryEtc) end)
	self.btnCostume:ConnectEvent(ButtonClickEvent, function() self:UpdateUI(self.categoryCostume) end)
}

[Client]
void UpdateData(string encodedJsons)
{
	-- 인벤토리 데이터를 갱신한다.
	
	log("update data")
	local jsons = _HttpService:JSONDecode(encodedJsons)
	self.datas[self.categoryEquip] = _HttpService:JSONDecode(jsons[1])
	self.datas[self.categoryConsume] = _HttpService:JSONDecode(jsons[2])
	self.datas[self.categoryEtc] = _HttpService:JSONDecode(jsons[3])
	self.datas[self.categoryCostume] = _HttpService:JSONDecode(jsons[4])
	self.datas.equipProp = _HttpService:JSONDecode(jsons[5])
	self.datas.itemProp = _HttpService:JSONDecode(jsons[6])
	
	self:UpdateUI(self.currentCategory)
}

[Client]
void UpdateUI(string category)
{
	-- 인벤토리 UI를 갱신 및 표시한다.
	
	log("update ui")
	self.currentCategory = category
	local inven = self.datas[category]
	
	for i = 1, self.slotCnt do
		local img = self.emptyImg
		local txt = ""
		if inven[i] ~= 0 then
			local id = inven[i]
			local code = nil
			if category == self.categoryEquip then
				code = self.datas.equipProp[id].code
			else
				code = id
				txt = self.datas.itemProp[id].cnt
			end
			img = self.itemImg[category][code]
		end
		self.sprites[i].ImageRUID = img
		self.texts[i].Text = txt
	end
}


--Events--

