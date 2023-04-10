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


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 서버에서 slotCnt 값 불러오기
	
	self.slotCnt = _InventoryServer.slotCnt
	
	-- 클라이언트 데이터 구조 세팅
	
	self.datas.equip = {}
	self.datas.consume = {}
	self.datas.etc = {}
	self.datas.costume = {}
	self.datas.equipProp = {}
	self.datas.itemProp = {}
	
	-- 데이터셋에서 아이템 정보 불러오기
	
	self.itemImg.equip = {}
	local equipDataSet = _DataService:GetTable(self.equipDataSet)
	for _, row in ipairs(equipDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg.equip[code] = img
	end
	
	self.itemImg.consume = {}
	local consumeDataSet = _DataService:GetTable(self.consumeDataSet)
	for _, row in ipairs(consumeDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg.consume[code] = img
	end
	
	self.itemImg.etc = {}
	local etcDataSet = _DataService:GetTable(self.etcDataSet)
	for _, row in ipairs(etcDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg.etc[code] = img
	end
	
	self.itemImg.costume = {}
	local costumeDataSet = _DataService:GetTable(self.costumeDataSet)
	for _, row in ipairs(costumeDataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg.costume[code] = img
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
	
	self.btnEquip:ConnectEvent(ButtonClickEvent, function() self:UpdateUI("equip") end)
	self.btnConsume:ConnectEvent(ButtonClickEvent, function() self:UpdateUI("consume") end)
	self.btnEtc:ConnectEvent(ButtonClickEvent, function() self:UpdateUI("etc") end)
	self.btnCostume:ConnectEvent(ButtonClickEvent, function() self:UpdateUI("costume") end)
}

[Client]
void UpdateData(string datasJson)
{
	-- 인벤토리 데이터를 갱신한다.
	
	log("update data")
	local datas = _HttpService:JSONDecode(datasJson)
	self.datas.equip = _HttpService:JSONDecode(datas[1])
	self.datas.consume = _HttpService:JSONDecode(datas[2])
	self.datas.etc = _HttpService:JSONDecode(datas[3])
	self.datas.costume = _HttpService:JSONDecode(datas[4])
	self.datas.equipProp = _HttpService:JSONDecode(datas[5])
	self.datas.itemProp = _HttpService:JSONDecode(datas[6])
	
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
		if inven[i] then
			local id = inven[i]
			local code = nil
			if category == "equip" then
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

