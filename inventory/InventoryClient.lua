--Properties--

number slotCnt = 30
string itemsDataSet = "ItemsDataSet"
string equipsDataSet = "EquipsDataSet"
string userId = ""
dictionary<string, string> itemImg
array<SpriteGUIRendererComponent> sprites
array<TextComponent> texts
Entity itemSlot


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 플레이어 id 저장
	
	self.userId = _UserService.LocalPlayer.Name
	
	
	-- 데이터셋에서 아이템 정보 불러오기
	
	local dataSet = _DataService:GetTable(self.itemsDataSet)
	for _, row in ipairs(dataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[code] = img
	end
	
	dataSet = _DataService:GetTable(self.equipsDataSet)
	for _, row in ipairs(dataSet:GetAllRow()) do
		local code = row:GetItem("code")
		local img = row:GetItem("img")
		self.itemImg[code] = img
	end
	
	
	-- 아이템 슬롯 복제 및 스프라이트/텍스트 컴포넌트 저장
	
	table.insert(self.sprites, self.itemSlot.Children[2].SpriteGUIRendererComponent)
	table.insert(self.texts, self.itemSlot.Children[3].TextComponent)
	for i = 1, self.slotCnt - 1 do
	    local slot = self.itemSlot:Clone("")
		table.insert(self.sprites, slot.Children[2].SpriteGUIRendererComponent)
		table.insert(self.texts, slot.Children[3].TextComponent)
	end
	
	_InventoryServer:UpdateUserUI(self.userId)
}

[Client]
void UpdateUI(string invenData, string itemPropsData, string equipPropsData)
{
	-- 인벤토리 UI를 갱신한다.
	
	log("update ui")
	local inven = _HttpService:JSONDecode(invenData)
	local itemCnt = _HttpService:JSONDecode(itemPropsData)
	local equipProps = _HttpService:JSONDecode(equipPropsData)
	
	for i = 1, self.slotCnt do
		if inven[i] ~= 1 then
			local code = inven[i]
			if string.len(code) > 4 then
				code = equipProps.id.code
				self.texts[i].Text = ""
			else
				self.texts[i].Text = itemCnt[code]
			end
			self.sprites[i].ImageRUID = self.itemImg[code]
			self.texts[i].Entity.Enable = true
		end
	end
}


--Events--

