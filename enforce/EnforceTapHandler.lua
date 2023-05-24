--Properties--

table tapButtonTable
table tapPageTable
table tapStateTable
dictionary<string, number> currentState
dictionary<string, number> maxState


--Methods--

[Client Only]
void OnBeginPlay()
{
	--woo : left Tap
	self.tapButtonTable["left"] = {}
	self.tapPageTable["left"] = {}
	self.tapStateTable["left"] = {}
	self.tapButtonTable["center"] = {}
	self.tapPageTable["center"] = {}
	self.tapStateTable["center"] = {}
	
	self.tapButtonTable["left"][1] = _EntityService:GetEntity(_EnforceEnum.TapLeftInfoButtonId)
	self.tapButtonTable["left"][2] = _EntityService:GetEntity(_EnforceEnum.TapLeftSelectButtonId)
	self.tapButtonTable["left"][1]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("left", "info") end)
	self.tapButtonTable["left"][2]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("left", "select") end)
	
	self.tapPageTable["left"][1] = _EntityService:GetEntity(_EnforceEnum.TapLeftInfoId)
	self.tapPageTable["left"][2] = _EntityService:GetEntity(_EnforceEnum.TapLeftSelectId)
	
	self.tapStateTable["left"]["info"] = 1
	self.tapStateTable["left"]["select"] = 2
	
	self.maxState["left"] = 2
	
	--woo : center Tap
	self.tapButtonTable["center"][1] = _EntityService:GetEntity(_EnforceEnum.TapCenterEnforceButtonId)
	self.tapButtonTable["center"][2] = _EntityService:GetEntity(_EnforceEnum.TapCenterScrollButtonId)
	self.tapButtonTable["center"][3] = _EntityService:GetEntity(_EnforceEnum.TapCenterEnchantButtonId)
	self.tapButtonTable["center"][4] = _EntityService:GetEntity(_EnforceEnum.TapCenterSuccessionButtonId)
	self.tapButtonTable["center"][1]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("center", "enforce") end)
	self.tapButtonTable["center"][2]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("center", "scroll") end)
	self.tapButtonTable["center"][3]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("center", "enchant") end)
	self.tapButtonTable["center"][4]:ConnectEvent(ButtonClickEvent, function() self:TapOpen("center", "succession") end)
	
	self.tapPageTable["center"][1] = _EntityService:GetEntity(_EnforceEnum.TapCenterEnforceId)
	self.tapPageTable["center"][2] = _EntityService:GetEntity(_EnforceEnum.TapCenterScrollId)
	self.tapPageTable["center"][3] = _EntityService:GetEntity(_EnforceEnum.TapCenterEnchantId)
	self.tapPageTable["center"][4] = _EntityService:GetEntity(_EnforceEnum.TapCenterSuccessionId)
	
	self.tapStateTable["center"]["enforce"] = 1
	self.tapStateTable["center"]["scroll"] = 2
	self.tapStateTable["center"]["enchant"] = 3
	self.tapStateTable["center"]["succession"] = 4
	
	self.maxState["center"] = 4
	
	--woo : init
	self:TapOpen("left", "info")
	self:TapOpen("center", "scroll")
}

[Client]
void TapOpen(string location, string tap)
{
	self.currentState[location] = self.tapStateTable[location][tap]
	for i = 1, self.maxState[location] do
		local color = Color.gray
		local bool = false
		if i == self.currentState[location] then
			color = Color.black
			bool = true
		end
		self.tapPageTable[location][i]:SetVisible(bool)
		self.tapButtonTable[location][i].TextComponent.FontColor = color
	end
	
	if location == "center" then
		--_EnforceClient:CostSlotUpdate(tap)
	end
	
}


--Events--

