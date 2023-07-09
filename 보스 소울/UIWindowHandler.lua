--Properties--

Entity window
Entity inventory
Entity enhance
Entity equipCraft
Entity bossSelect
Component title
Entity exitButton
table pages
table taps
table buttons
integer currentPage = 0
table currentTap
table titles


--Methods--

[Client Only]
void OnBeginPlay()
{
	local inventory = _UIEnum.Inventory
	local enhance = _UIEnum.Enhance
	local equipCraft = _UIEnum.EquipCraft
	local bossSelect = _UIEnum.BossSelect
	
	
	local left = _UIEnum.Left
	local right = _UIEnum.Right
	
	self.pages[inventory] = self.inventory
	self.pages[enhance] = self.enhance
	self.pages[equipCraft] = self.equipCraft
	self.pages[bossSelect] = self.bossSelect
	
	self.taps[inventory] = {}
	self.taps[enhance] = {}
	self.buttons[inventory] = {}
	self.buttons[enhance] = {}
	
	self.taps[inventory][left] = {}
	self.taps[inventory][right] = {}
	self.taps[enhance][left] = {}
	self.taps[enhance][right] = {}
	self.buttons[inventory][left] = {}
	self.buttons[inventory][right] = {}
	self.buttons[enhance][left] = {}
	self.buttons[enhance][right] = {}
	
	local dirText = {"Left", "Right"}
	local btnText = "Button"
	
	local UIName = {
		{   --inventory
			{"Equip", "Status", "Avatar"}, --left
			{"Equip", "Consume", "Material", "Costume"} --right
			},
		{   --Enhance
			{"Info", "Select"}, --left
			{"Enforce", "Scroll", "Enchant", "Succession"} --right
			}
		}
	
	for pageNum, pages in ipairs(UIName) do
		for dir, taps in ipairs(pages) do
			---@type Entity
			local page = self.pages[pageNum]:GetChildByName(dirText[dir])
			for idx, tapText in ipairs(taps) do
				local tap = page:GetChildByName(tapText)
				local button = page:GetChildByName(tapText .. btnText)
				
				if dir == left then 
					button:ConnectEvent(ButtonClickEvent, function() self:OpenWindow(pageNum, idx, nil) end)	
				elseif dir == right then
					button:ConnectEvent(ButtonClickEvent, function() self:OpenWindow(pageNum, nil, idx) end)	
				end
				
				tap:SetVisible(true)
				button:SetVisible(true)
				
				self.taps[pageNum][dir][idx] = tap
				self.buttons[pageNum][dir][idx] = button
			end
		end
	end
	
	self:CloseAllTaps()
	self:CloseAllPages()
	
	self.exitButton:ConnectEvent(ButtonClickEvent, function() self:CloseWindow() end)
}

[Client]
void OpenWindow(integer page, integer left, integer right)
{
	if self.window.Enable == false then self.window:SetEnable(true) end
	
	if page ~= nil and page ~= self.currentPage then self:OpenPage(page) end
	
	if left ~= nil and left ~= self.currentTap[_UIEnum.Left] then self:OpenTap(_UIEnum.Left, left) end
	if right ~= nil and right ~= self.currentTap[_UIEnum.Right] then self:OpenTap(_UIEnum.Right, right) end
}

[Client]
void OpenPage(integer page)
{
	self:CloseAllTaps()
	self:ClosePages()
	self.pages[page]:SetEnable(true)
	self.title.Text = self.titles[page]
	
	self.currentPage = page
}

[Client]
void OpenTap(integer dir, integer tap)
{
	self:CloseTaps(dir)
	
	local page = self.currentPage
	self.taps[page][dir][tap]:SetVisible(true)
	self.buttons[page][dir][tap].TextComponent.FontColor = Color.black
	
	self.currentTap[dir] = tap
}

[Client]
void CloseWindow()
{
	self:CloseAllTaps()
	self:CloseAllPages()
	
	self.currentPage = 0
	self.currentTap = {0, 0}
	
	self.window:SetEnable(false)
}

[Client]
void ClosePages()
{
	local page = self.currentPage
	if page ~= 0 then 
		self.pages[page]:SetEnable(false) 
	end
}

[Client]
void CloseTaps(integer dir)
{
	local tap = self.currentTap[dir]
	local page = self.currentPage
	if tap ~= 0 then 
		self.taps[page][dir][tap]:SetVisible(false)
		self.buttons[page][dir][tap].TextComponent.FontColor = Color.gray
	end
}

[Client]
void CloseAllTaps()
{
	for page = 1, #self.taps do
		for dir = 1, #self.taps[page] do
			for tap = 1, #self.taps[page][dir] do
				self.taps[page][dir][tap]:SetVisible(false)
				self.buttons[page][dir][tap].TextComponent.FontColor = Color.gray
			end
		end
	end
	
	self.currentTap = {0, 0}
}

[Client]
void CloseAllPages()
{
	for page = 1, #self.pages do
		self.pages[page]:SetEnable(false)
	end
	
	self.currentPage = 0
}


--Events--

