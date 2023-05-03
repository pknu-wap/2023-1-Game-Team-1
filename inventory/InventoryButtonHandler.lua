--Properties--

Entity equipButton
Entity consumeButton
Entity materialButton
Entity costumeButton
Entity sortButton
dictionary<string, Entity> buttons
dictionary<string, SpriteGUIRendererComponent> sprites
string equipCategory = nil
string consumeCategory = nil
string materialCategory = nil
string costumeCategory = nil
string pressedImg = "e22dca176e7c48b39d5b40554b546e22"
string disabledImg = "9bb8e4d004fb46bb9c1b528b3c1ebf9f"
string pressedColor = "#653122"
string disabledColor = "#ffe398"
dictionary<string, TextComponent> texts


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- enum 불러오기
	
	self.equipCategory = _InventoryEnum.equipCategory
	self.consumeCategory = _InventoryEnum.consumeCategory
	self.materialCategory = _InventoryEnum.materialCategory
	self.costumeCategory = _InventoryEnum.costumeCategory
	
	-- 컴포넌트 저장
	
	self.buttons[self.equipCategory] = self.equipButton
	self.buttons[self.consumeCategory] = self.consumeButton
	self.buttons[self.materialCategory] = self.materialButton
	self.buttons[self.costumeCategory] = self.costumeButton
	
	for category, button in pairs(self.buttons) do
		self.sprites[category] = button.SpriteGUIRendererComponent
		self.texts[category] = button.TextComponent
	end
	
	-- 이벤트 연결
	
	for category, button in pairs(self.buttons) do
		button:ConnectEvent(ButtonClickEvent, function() self:ClickButton(category) end)
	end
	self.sortButton:ConnectEvent(ButtonClickEvent, function() _InventoryClient:Sort() end)
}

[Client]
void ClickButton(string category)
{
	if _InventoryClient.currentCategory == category then return end
	
	for cate, sprite in pairs(self.sprites) do
		local img, color
		
		if category == cate then
			img = self.pressedImg
			color = self.pressedColor
		else
			img = self.disabledImg
			color = self.disabledColor
		end
		
		sprite.ImageRUID = img
		self.texts[cate].FontColor = Color.FromHexCode(color)
	end
	
	_InventorySlotHandler:Deselect()
	_InventoryClient.currentCategory = category
	_InventoryClient:UpdateUI(category)
}


--Events--

