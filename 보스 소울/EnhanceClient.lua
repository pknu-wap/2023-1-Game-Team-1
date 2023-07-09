--Properties--

table slots
table itemSlots
table infoSlots
table costs
table equippedScroll
string userId = ""
integer selectedSlotGroup = 0
integer selectedSlotIdx = 0
boolean selectedSlot = false
string selectedEquipmentId = nil
boolean isEnforceCostFilled = false
Component selectedItemNum
Component selectedItemDescription
Entity enforceButton
Entity selectedItemInfo


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.userId = _UserService.LocalPlayer.Name
	
	local pageNum = _UIEnum.Enhance 
	
	-- 슬롯 복사
	
	---@type table<Entity>
	local slotTable = {
		{_EnhanceEnum.EquipSelectSlot, _EnhanceEnum.ScrollSelectSlot},
		{_EnhanceEnum.SelectedEquipInfoSlot, _EnhanceEnum.CostSlot}
		}
	
	for type, slots in ipairs(slotTable) do
		for group, slot in ipairs(slots) do
			if type == _Enum.Item then self.itemSlots[group] = {}
			elseif type == _Enum.Info then self.infoSlots[group] = {} end
			
			for idx = 1, _EnhanceEnum.SlotsNum[type][group] do
				---@type Entity
				local copy
		
				if idx == 1 then copy = slot 
				else copy = slot:Clone(nil) end
				
				if type == _Enum.Item then
					local component	= copy.ItemSlot:Create(pageNum, group, idx)
					self.itemSlots[group][idx] = component
					
				elseif type == _Enum.Info then
					local component = copy.InfoSlot
					self.infoSlots[group][idx] = component
					
				end
			end
		end
	end
	
	local group = _EnhanceEnum.SelectedEquip
	self.itemSlots[group] = _EnhanceEnum.SelectedEquipItemSlot.ItemSlot:Create(pageNum, group, 1)
	self.infoSlots[group] = _EnhanceEnum.SelectedEquipNameSlot.InfoSlot
	
	local tmpSlot = _EnhanceEnum.EnforceEntity
	local tmpSlots = {tmpSlot:GetChildByName("Selected"), tmpSlot:GetChildByName("Target")}
	
	for i, slot in ipairs(tmpSlots) do
		group = _EnhanceEnum.EnforceSelected + i - 1 
		self.itemSlots[group] = slot:GetChildByName("Weapon").ItemSlot:Create(pageNum, group, 1)
		self.infoSlots[group] = {}
		self.infoSlots[group][1] = slot:GetChildByName("Atk").InfoSlot
		self.infoSlots[group][2] = slot:GetChildByName("Enforce").InfoSlot
	end
	
	group = _EnhanceEnum.EquippedScroll
	self.itemSlots[group] = {}
	tmpSlot = _EnhanceEnum.EquippedScrollEntity
	for idx = 1, 5 do
		local text = "ScrollSlot" .. idx
		local slot = tmpSlot:GetChildByName(text)
		self.itemSlots[group][idx] = slot.ItemSlot:Create(pageNum, group, idx)
	end
	
	_EnhanceEnum:SetNull()
}

[Client]
void UpdateData()
{
	log("Enhance Tap Update")
	-----@type table
	--local data = nil
	--
	--while data ~= nil do
	--    data = _InventoryClient.data
	--    wait(1)
	--end
	--
	--local currentEquipment = data[_InventoryEnum.currentEquipment]
	--self.selectedEquipmentId = self.selectedEquipmentId or currentEquipment[_ItemTypeEnum.Weapon]
	--
	--local equips = data[_InventoryEnum.equipStatus]
	--local consume = data[_InventoryEnum.consumeCategory]
	--local selectedEquipment = _InventoryClient:GetEquipmentClient(self.selectedEquipmentId)
	--
	---- 무기 선택 슬롯 itemId 초기화 및 설정
	--self:ResetSlotId(_Enum.ItemSlotSelectEq)
	--
	--local cnt = 1
	--for _, item in pairs(equips) do
	--    if item.id ~= nil then
	--        self.slots[_Enum.ItemSlotSelectEq][cnt].itemId = item.id
	--        cnt = cnt + 1
	--    end
	--end
	--
	---- 스크롤 선택 슬롯 itemId 초기화 및 설정
	--self:ResetSlotId(_Enum.ItemSlotSelectSc)
	--
	--cnt = 1
	--for _, scrollId in pairs(consume) do
	--    if scrollId ~= "0" then
	--        self.slots[_Enum.ItemSlotSelectSc][cnt].itemId = scrollId
	--        cnt = cnt + 1
	--    end
	--end
	--
	---- 장착중인 스크롤 초기화 및 설정
	--self.equippedScroll = {"0", "0", "0", "0", "0"}
	--
	--cnt = 1
	--for idx = 1, 5 do
	--    local key = "scroll"..tostring(idx)
	--    local scrollId = selectedEquipment[key]
	--    if scrollId ~= "0" then
	--        self.slots[_Enum.ItemSlotEquippedScroll][cnt].itemId = scrollId
	--        self.equippedScroll[cnt] = scrollId
	--        cnt = cnt + 1 
	--    end
	--end
	--
	--
	---- 강화 비용 초기화 및 설정
	--self:ResetCost()
	--
	--local enforceData = _DataService:GetTable(_DataSetEnum.EnforceDataSet)
	--local enforceNum = tonumber(selectedEquipment.enforce)
	--
	--self.costs[_Enum.TapEnforce][_ItemTypeEnum.Soul] = enforceData:GetCell(enforceNum + 1, "SoulCost")
	--self.costs[_Enum.TapEnforce][_ItemTypeEnum.EnforceStone] = enforceData:GetCell(enforceNum + 1, "StoneCost") 
	--
	--self:UpdateUI()
}

[Client]
void UpdateUI()
{
	--self:UpdateItemSlot(_Enum.ItemSlotSelectEq)
	--self:UpdateItemSlot(_Enum.ItemSlotSelectSc)
	--
	--self:UpdateResourceSlot()
	--
	--self:UpdateSelectedEquipment()
	--
	--self:UpdateEnforce()
	--self:UpdateScroll()
	--
	--self:UpdateSelectedSlot()
	--
	--self:UpdateAllSlot()
}

[Client Only]
void Enforce()
{
	if self.isEnforceCostFilled then
		local userId = _UserService.LocalPlayer.Name
		_EnhanceServer:EnforceWeapon(userId, self.selectedEquipmentId)
	else
		log("재화가 부족해요!")
	end
	
}

[Client Only]
void CostSlotUpdate(integer tap)
{
	---@type table
	local cost = self.costs[tap]
	---@type table<InfoSlot>
	local slots = self.slots[_Enum.Info][_Enum.InfoSlotEnhanceCost]
	---@type table
	local playerResource = _InventoryClient.data[_InventoryEnum.resourceStatus]
	self.isEnforceCostFilled = true
	
	for i = 1, _Enum.ResourceMax do
	    slots[i]:SetValue(cost[i])
	    
	    if cost[i] == "0" then slots[i]:SetEnable(false)
	    else slots[i]:SetEnable(true)
	    end
	    
	    if tonumber(cost[i]) > tonumber(playerResource[i]) then 
			self.isEnforceCostFilled = false
	    end
	end
	
	if self.isEnforceCostFilled then
	    self.enforceButton.SpriteGUIRendererComponent.ImageRUID = _Enum.SpriteEnhanceButton[1]
	    self.enforceButton.ButtonComponent.Transition = TransitionType.SpriteSwap
	else
	    self.enforceButton.SpriteGUIRendererComponent.ImageRUID = _Enum.SpriteEnhanceButton[2]
	    self.enforceButton.ButtonComponent.Transition = TransitionType.None
	end
}

[Client Only]
void UpdateAllSlot()
{
	for type, arrays in ipairs(self.slots) do
		for group, array in ipairs(arrays) do
			for idx, slot in ipairs(array) do
				slot:Update()
			end
		end
	end
}

[Client Only]
void SlotSelect(integer group, integer idx, string itemId)
{
	if self.selectedSlotGroup == _Enum.ItemSlotSelectSc and group == _Enum.ItemSlotEquippedScroll then
		---@type table
		local scroll = self.slots[_Enum.Item][self.selectedSlotGroup][self.selectedSlotIdx].item
		_EnhanceServer:EquipScroll(self.userId, self.selectedEquipmentId, scroll.code)
		log("스크롤 장착 시도!")
		
		self:SlotDeselect()
		
	elseif group == self.selectedSlotGroup and self.selectedSlotIdx == idx then
		if self.selectedSlotGroup == _Enum.ItemSlotSelectEq then
			self:SlotDeselect()
			self.selectedEquipmentId = itemId
			log("더블 클릭!")
			_EnhanceTapHandler:TapOpen(_Enum.LeftInfo, nil)
		else
			self:SlotDeselect()
		end
		
	else
		self:SlotDeselect()
		if itemId ~= "" then
			self.selectedSlotGroup = group
			self.selectedSlotIdx = idx
			self.selectedSlot = true
		end
	end
	
	self:UpdateUI()
}

[Client Only]
void SlotDeselect()
{
	if self.selectedSlot then
		self.slots[_Enum.Item][self.selectedSlotGroup][self.selectedSlotIdx]:SetSlot(false, nil)
		self.selectedSlotGroup = 0
		self.selectedSlotIdx = 0	
		self.selectedSlot = false
	end
}

[Client Only]
void SelectedItemInfo(table item, string RUID)
{
	local value = ""
	local color = 0
	local num = ""
	local name = ""
	local description = ""
	if item.grade == nil then 
		color = _Enum.Black
		value = item.type
		num = tostring(item.cnt)
		name = item.name
		description = item.description
		
	else
		color = tonumber(item.grade)
		value = _Enum.grade[color]
		num = item.enforce
		name = "+"..num.." "..item.name
		description = "ATK : ".._Util:Comma(item.finalAtkPoint)
		
	end
	---@type InfoSlot
	local slot = self.slots[_Enum.Info][_Enum.InfoSlotSelectedItemInfo][1]
	slot:Set(RUID, name, value)
	slot:FontColor(color)
	
	local desc = item.description or "아이템 설명이 비어있습니다!"
	self.selectedItemDescription.Text = desc
	self.selectedItemNum.Text = num
}

[Client]
void ResetSlotId(integer slot)
{
	local type = _Enum.Item
	for idx = 1, _Enum.SlotCount[type][slot] do
		self.slots[type][slot].itemId = nil
	end
}

[Client]
void ResetCost()
{
	for tap = 1, _Enum.TapNumber do
		for resource = 1, _Enum.ResourceMax do
			self.costs[tap][resource] = ""
		end
	end
}

[Client]
void UpdateItemSlot(integer slotType)
{
	for idx = 1, _Enum.SlotCount[slotType] do
		---@type ItemSlot
		local slot = self.slots[slotType][idx]
		local id = slot.itemId
		
		if id ~= nil then
			local item
			
			if slotType == _Enum.ItemSlotSelectEq then -- 무기 선택
				item = _InventoryClient:GetEquipmentClient(id)
				slot:SetNum(item.enforce)
				if self.selectedEquipmentId == id then slot:SetSlotInfo(false, true)
				else slot:SetSlotInfo(false, false) end
				
			elseif slotType == _Enum.ItemSlotSelectSc then -- 스크롤 선택
				slot:SetNum(item.num)
				item = _InventoryClient:GetConsumeClient(id) 
				slot:SetSlotInfo(false, false) end
				
			slot.img = item.img
		end
	end
}

[Client]
void UpdateResourceSlot()
{
	---@type table
	local resources = _InventoryClient.data[_InventoryEnum.resourceStatus]
	
	-- 일단 2개만
	for idx = 1, 2 do
		---@type InfoSlot
		local slot = self.slots[_Enum.InfoSlotPlayerResource][idx]
	    slot:SetValue(resources[idx])
	end
}

[Client]
void UpdateSelectedEquipment()
{
	---@type table
	local selected = _InventoryClient:GetEquipmentClient(self.selectedEquipmentId)
	---@type InfoSlot
	local slot = self.slots[_Enum.InfoSlotSelectedEq][1]
	
	local name = "+" .. selected.enforce .. " " .. selected.name
	local gradeNum = tonumber(selected.grade)
	local grade = _Enum.grade[gradeNum] -- 별 개수
	
	slot:Set(selected.img, name, grade)
	slot:FontColor(_Enum.Black)
	
	for idx, stat in ipairs(_Enum.EquipmentInfos) do
		local statName = _Enum.EquipmentInfoStats[stat]
	    self.slots[_Enum.InfoSlotSelectedEqInfo][idx]:Set(nil, statName, selected[stat])
	end
	
}

[Client]
void UpdateEnforce()
{
	---@type table<InfoSlot>
	local enforceInfo = self.slots[_Enum.InfoSlotEnforceSelected]
	---@type table<ItemSlot>
	local enforceItem = self.slots[_Enum.ItemSlotEnforceSelected]
	local selectedEq = _InventoryClient:GetEquipmentClient(self.selectedEquipmentId)
	
	-- +1강된 무기 테이블
	local enforced = {}
	table.initialize(enforced, selectedEq)
	
	local enforceNum = tonumber(selectedEq.enforce)
	local finalAtk = selectedEq.finalAtkPoint
	
	local selectedAtk = _Util:Comma(finalAtk) .. "(" .. _Util:Comma(selectedEq.enforceAtk) .. ")"
	local selectedEnforce = selectedEq.enforce .. "강"
	local targetAtk = "???"
	local targetEnforce = tostring(enforceNum + 1) .. "강"
	
	enforced.enforce = tostring(enforceNum + 1)
	enforced.finalAtkPoint = "???"
	
	enforceItem[_Enum.SelectedEquipment]:SetItem(selectedEq, selectedEq.img)
	--enforceItem[_Enum.TargetEquipment]:SetItem(enforced, selectedEq.img)
	
	enforceInfo[_Enum.SelectedAtk]:SetValue(selectedAtk)
	enforceInfo[_Enum.SelectedEnforce]:SetValue(selectedEnforce)
	enforceInfo[_Enum.TargetAtk]:SetValue(targetAtk)
	enforceInfo[_Enum.TargetEnforce]:SetValue(targetEnforce)
	
	-- 재련 비용 업데이트
	local enforceData = _DataService:GetTable(_DataSetEnum.EnforceDataSet)
	self.costs[_Enum.TapEnforce][_ItemTypeEnum.Soul] = enforceData:GetCell(enforceNum + 1, "SoulCost")
	self.costs[_Enum.TapEnforce][_ItemTypeEnum.EnforceStone] = enforceData:GetCell(enforceNum + 1, "StoneCost") 
}

[Client]
void UpdateScroll()
{
	-- 장착중인 스크롤 셋
	for idx, scrollId in ipairs(self.equippedScroll) do
		---@type ItemSlot
	 	local slot = self.slots[_Enum.ItemSlotEquippedScroll][idx]
		local scroll = _InventoryClient:GetConsumeClient(scrollId)
		
		if scroll.type == _ItemTypeEnum.Scroll then
			slot:SetItem(scroll, scroll.img)
			slot:SetNum(scroll.num)
			
		else
			slot:SetItem(nil, nil)
			slot:SetNum(nil)
		end
	end
	
	
	local consume = _InventoryClient.data[_DataSetEnum.ConsumeDataSet]
	
	local cnt = 1
	-- 숫자인지 확인
	for idx, itemId in ipairs(consume) do
	    if itemId ~= "0" then
			local item = _InventoryClient:GetConsumeClient(itemId)
			
			if item.type == _ItemTypeEnum.Scroll then
				---@type ItemSlot
		        local slot = self.slots[_Enum.ItemSlotSelectSc][cnt]
				
		        slot:SetItem(item, item.img)
		        slot:SetNum(item.cnt)
				
		        cnt = cnt + 1
			end
	        
	    end
	end
	
	for idx = cnt, _Enum.SlotCount[_Enum.ItemSlotSelectSc] do
		---@type ItemSlot
		local slot = self.slots[_Enum.ItemSlotSelectSc][idx]
		slot:SetItem(nil, nil)
		slot:SetNum(nil)
	end
}

[Client]
void UpdateSelectedSlot()
{
	if self.selectedSlot then
	    ---@type ItemSlot
	    local selectedSlot = self.slots[self.selectedSlotGroup][self.selectedSlotIdx]
	    selectedSlot:SetSlotInfo(true, nil)
	    
	    -- 선택한 아이템 정보 창
	    local xRatio = _UILogic.ScreenWidth / 1920
	    local yRatio = _UILogic.ScreenHeight / 1080
	    
	    local slotSize = selectedSlot.size
	    local infoSize = self.selectedItemInfo.UITransformComponent.RectSize
	    local worldPos = selectedSlot.Entity.UITransformComponent.WorldPosition
	    local x = worldPos.x + ((slotSize.x / 2 + infoSize.x / 2) * xRatio) --((slotSize.x / 2) + (infoSize.x / 2)) * xRatio
	    local y = worldPos.y + ((slotSize.y / 2 - infoSize.y / 2) * yRatio) --((slotSize.y / 2) - (infoSize.y / 2) - 5) * yRatio
	    
	    self.selectedItemInfo.UITransformComponent.WorldPosition = Vector3(x, y, 0)
	    
	    --self:SelectedItemInfo(selectedSlot.item, selectedSlot.img)
	end
	self.selectedItemInfo:SetVisible(self.selectedSlot)
}


--Events--

