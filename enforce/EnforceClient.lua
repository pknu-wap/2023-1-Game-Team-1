--Properties--

Entity selectFirstSlot
Entity infoFirstSlot
Entity costSlotParent
<<<<<<< HEAD
Entity scrollFirstSlot
=======
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
Entity selectedText
Component selectedWeaponIcon
Component enforceGoalIcon
Component enforceSelectIcon
Component infoWeaponName
Component infoWeaponGrade
array<Entity> selectSlotArray
array<InfoSlot> infoSlotArray
<<<<<<< HEAD
array<Entity> scrollSlotArray
array<CostSlot> costSlotArray
array<CostSlot> playersResourceSlot
dictionary<string, InfoSlot> enforceInfoSlot
number selectSlotCnt = 30
number infoSlotCnt = 10
number costSlotCnt = 6
number scrollSlotCnt = 18
=======
array<CostSlot> playersResourceSlot
array<CostSlot> costSlotArray
dictionary<string, InfoSlot> enforceInfoSlot
number selectSlotCnt = 30
number infoSlotCnt = 10
number costSlotcnt = 6
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
string selectedWeaponId = ""
Entity enforceButton
table cost
string userId = ""
<<<<<<< HEAD
boolean isEnforceCostFilled = false
table firstSlot
=======
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.userId = _UserService.LocalPlayer.Name
	
<<<<<<< HEAD
	self.firstSlot["abc"] = "ad"
	
	-- player's resource slot
	self.playersResourceSlot[_EnforceEnum.ResourceSoul] = _EntityService:GetEntity("1fab2cb1-0193-4462-8c29-e48a28a91055").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceEnforceStone] = _EntityService:GetEntity("24d81565-a60f-470d-adf9-4b9d374a48ef").CostSlot
=======
	-- player's resource slot
	self.playersResourceSlot[_EnforceEnum.ResourceSoul] = _EntityService:GetEntity("24d81565-a60f-470d-adf9-4b9d374a48ef").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceEnforceStone] = _EntityService:GetEntity("1fab2cb1-0193-4462-8c29-e48a28a91055").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceRuneWarrior] = _EntityService:GetEntity("98c5acf7-ed22-4052-a99b-d5bc0ae8d768").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceRuneThief] = _EntityService:GetEntity("7a25438c-6407-48ca-b613-4a590e2d9c27").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceRuneBowman] = _EntityService:GetEntity("2f9f9aec-4a43-4cf9-9682-f7acaf86eb63").CostSlot
	self.playersResourceSlot[_EnforceEnum.ResourceRuneMagician] = _EntityService:GetEntity("c2d539f1-8de8-42e2-9cd9-63e76907302e").CostSlot
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
	
	-- empty tap resource
	local emptyResourceTable = {}
	emptyResourceTable[_EnforceEnum.ResourceSoul] = "0"
	emptyResourceTable[_EnforceEnum.ResourceEnforceStone] = "0"
	emptyResourceTable[_EnforceEnum.ResourceRuneWarrior] = "0"
	emptyResourceTable[_EnforceEnum.ResourceRuneThief] = "0"
	emptyResourceTable[_EnforceEnum.ResourceRuneBowman] = "0"
	emptyResourceTable[_EnforceEnum.ResourceRuneMagician] = "0"
	
<<<<<<< HEAD
	self.cost[_EnforceEnum.KeyEnforce] = emptyResourceTable
	self.cost[_EnforceEnum.KeyScroll] = emptyResourceTable
	self.cost[_EnforceEnum.KeyEnchant] = emptyResourceTable
	self.cost[_EnforceEnum.KeySuccession] = emptyResourceTable
=======
	self.cost[_EnforceEnum.CenterTapEnforce] = emptyResourceTable
	self.cost[_EnforceEnum.CenterTapScroll] = emptyResourceTable
	self.cost[_EnforceEnum.CenterTapEnchant] = emptyResourceTable
	self.cost[_EnforceEnum.CenterTapSuccession] = emptyResourceTable
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
	
	-- Left 탭 무기 정보 슬롯
	self.infoSlotArray[1] = self.infoFirstSlot.InfoSlot
	
	for i = 2, self.infoSlotCnt do
		local slot = self.infoFirstSlot:Clone(nil)
		self.infoSlotArray[i] = slot.InfoSlot
	end
	
	self.infoSlotArray[1]:SetName("Atk")
	self.infoSlotArray[2]:SetName("Enforce")
	self.infoSlotArray[3]:SetName("Grade")
	
	-- Left 탭 무기 선택 슬롯
	self.selectSlotArray[1] = self.selectFirstSlot
	self.selectSlotArray[1].InventorySlot.idx = 1
	self.selectSlotArray[1].InventorySlot.group = "enforce"
	
	for i = 2, self.selectSlotCnt do
		local slot = self.selectFirstSlot:Clone(nil)
		slot.InventorySlot.idx = i
		slot.InventorySlot.group = "enforce"
		self.selectSlotArray[i] = slot
	end
	
	--center enforce info slot
	self.enforceInfoSlot["selectedAtk"] = _EntityService:GetEntity("5f3fdaa3-5aae-47d5-a36f-6ade0a87747e").InfoSlot
	self.enforceInfoSlot["selectedEnforce"] = _EntityService:GetEntity("a41301fa-8081-4eca-a211-f27329943f98").InfoSlot
	self.enforceInfoSlot["goalAtk"] = _EntityService:GetEntity("2566b37d-3625-42bb-9e65-ef6949842d36").InfoSlot
	self.enforceInfoSlot["goalEnforce"] = _EntityService:GetEntity("4c17a679-87b9-4573-acad-5b8984e77643").InfoSlot
	
	self.enforceInfoSlot["selectedAtk"]:SetName("Atk")
	self.enforceInfoSlot["selectedEnforce"]:SetName("Enforce")
	self.enforceInfoSlot["goalAtk"]:SetName("Atk")
	self.enforceInfoSlot["goalEnforce"]:SetName("Enforce")
	
<<<<<<< HEAD
	--center scroll slot
	self.scrollSlotArray[1] = self.scrollFirstSlot
	self.scrollSlotArray[1].InventorySlot.idx = 1
	self.scrollSlotArray[1].InventorySlot.group = "scroll"
	
	for i = 2, self.scrollSlotCnt do
		local slot = self.scrollFirstSlot:Clone(nil)
		slot.InventorySlot.idx = i
		slot.InventorySlot.group = "scroll"
		self.scrollSlotArray[i] = slot
	end
	
	
	--right Cost slot
	for i = 1, self.costSlotCnt do
=======
	--right Cost slot
	for i = 1, self.costSlotcnt do
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
		self.costSlotArray[i] = self.costSlotParent.Children[i].CostSlot
	end
	
	--woo : 강화 버튼
	self.enforceButton:ConnectEvent(ButtonClickEvent, function() self:Enforce() end)
}

[Client]
void UpdateUI()
{
<<<<<<< HEAD
	log("Enforce UI Update")
	
	--Update Player's resource
	local soul = _InventoryClient.data[_InventoryEnum.resourceStatus][_InventoryEnum.resourceSoul]
	local stone = _InventoryClient.data[_InventoryEnum.resourceStatus][_InventoryEnum.resourceEnforceStone]
	
	self.playersResourceSlot[_EnforceEnum.ResourceSoul]:SetValue(soul)
	self.playersResourceSlot[_EnforceEnum.ResourceEnforceStone]:SetValue(stone)
	
	
	--Update left weapon select tap
	local equips = _InventoryClient.data[_EnforceEnum.KeyEquipStatus]
=======
	--Update Player's resource
	local soul = _InventoryClient.data["Soul"]
	
	--Update left weapon select tap
	local equips = _InventoryClient.data[_EnforceEnum.EquipStatusKey]
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
	local cnt = 1
	
	--temporary weaponid
	if self.selectedWeaponId == "" then
<<<<<<< HEAD
=======
		log("empty")
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
		self.selectedWeaponId = "0" 
	end
	
	for _, table in pairs(equips) do
		if table.id ~= nil then
			self.selectSlotArray[cnt].Children[1].SpriteGUIRendererComponent.ImageRUID = _InventoryClient.img["CategoryEquip"][table["code"]]
			self.selectSlotArray[cnt].InventorySlot.itemId = table.id
			if self.selectedWeaponId == table.id then
				self.selectSlotArray[cnt].Children[3]:SetEnable(true)
			else
				self.selectSlotArray[cnt].Children[3]:SetEnable(false)
			end
			cnt = cnt + 1
		end
	end
	
	for i = cnt, self.selectSlotCnt do
		self.selectSlotArray[i].Children[1].SpriteGUIRendererComponent.ImageRUID = _Util.EmptyImg
	end
	
	--Update left weapon info tap
	local equipedWeapon = equips[self.selectedWeaponId]
	local img = _InventoryClient.img["CategoryEquip"][equipedWeapon["code"]]
	
	self.selectedWeaponIcon.ImageRUID = img
	self.infoWeaponGrade.Text = ""
	for i = 1, tonumber(equipedWeapon["grade"]) do
		self.infoWeaponGrade.Text = self.infoWeaponGrade.Text .. "★"	
	end
	
	self.infoWeaponName.Text = "+" .. equipedWeapon["enforce"] .. " " .. equipedWeapon["name"]
	
	self.infoSlotArray[1]:SetValue(equipedWeapon["baseAtkPoint"]) 
	self.infoSlotArray[2]:SetValue(equipedWeapon["enforce"] .. "강", 0)
	self.infoSlotArray[3]:SetValue(equipedWeapon["grade"] .. "성", 0)
	
	
	--Update center enforce tap
	self.enforceGoalIcon.ImageRUID = img
	self.enforceSelectIcon.ImageRUID = img
	
	local enforceNum = tonumber(equipedWeapon["enforce"])
	
	self.enforceInfoSlot["selectedAtk"]:SetValue(_Util:NumberComma(equipedWeapon["finalAtkPoint"]) .. "(" .. equipedWeapon["enforceAddAtk"] .. ")", 0)
	self.enforceInfoSlot["selectedEnforce"]:SetValue(tostring(enforceNum))
	self.enforceInfoSlot["goalAtk"]:SetValue("?", 0)
	self.enforceInfoSlot["goalEnforce"]:SetValue(tostring(enforceNum + 1))
	
<<<<<<< HEAD
	local enforceData = _DataService:GetTable(_EnforceEnum.DataSetEnforce)
	self.cost[_EnforceEnum.KeyEnforce][_EnforceEnum.ResourceSoul] = enforceData:GetCell(enforceNum + 1, "SoulCost")
	self.cost[_EnforceEnum.KeyEnforce][_EnforceEnum.ResourceEnforceStone] = enforceData:GetCell(enforceNum + 1, "StoneCost") 
	
	self:CostSlotUpdate(_EnforceEnum.KeyEnforce)
	
	--Update center scroll tap
	
	
	--할 일 : 강화 이펙트 만들기
	
=======
	local enforceData = _DataService:GetTable(_EnforceEnum.EnforceDataSet)
	self.cost[_EnforceEnum.CenterTapEnforce][_EnforceEnum.ResourceSoul] = enforceData:GetCell(enforceNum + 1, "SoulCost")
	self.cost[_EnforceEnum.CenterTapEnforce][_EnforceEnum.ResourceEnforceStone] = enforceData:GetCell(enforceNum + 1, "StoneCost") 
	
	self:CostSlotUpdate(_EnforceEnum.CenterTapEnforce)
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
}

[Client Only]
void WeaponSelect(string equipId, number idx)
{
	--Left tap weapon info update
	self.selectedWeaponId = equipId
	self:UpdateUI()
}

[Client Only]
void Enforce()
{
<<<<<<< HEAD
	if self.isEnforceCostFilled then
		local userId = _UserService.LocalPlayer.Name
		_EnforceServer:EnforceWeapon(userId, self.selectedWeaponId)
	else
		log("재화가 부족해요!")
	end
	
=======
	local userId = _UserService.LocalPlayer.Name
	_EnforceServer:EnforceWeapon(userId, self.selectedWeaponId)
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
}

[Client Only]
void CostSlotUpdate(string tap)
{
	local cost = self.cost[tap]
<<<<<<< HEAD
	self.isEnforceCostFilled = true
	for i = 1, self.costSlotCnt do
		self.costSlotArray[i]:SetValue(cost[i])
		self.costSlotArray[i]:Update()
		if tonumber(cost[i]) > tonumber(_InventoryClient.data[_InventoryEnum.resourceStatus][i]) then
			self.isEnforceCostFilled = false
		end
	end
	
	if self.isEnforceCostFilled then
		self.enforceButton.SpriteGUIRendererComponent.ImageRUID = _EnforceEnum.SpriteEnforceButtonEnable
		self.enforceButton.ButtonComponent.Transition = 2
	else
		self.enforceButton.SpriteGUIRendererComponent.ImageRUID = _EnforceEnum.SpriteEnforceButtonDisable
		self.enforceButton.ButtonComponent.Transition = 0
	end
	
	
	
=======
	for i = 1, self.costSlotcnt do
		self.costSlotArray[i]:SetValue(cost[i])
		self.costSlotArray[i]:Update()
	end
	
>>>>>>> c561ea44b3f888c6c1dd38870ced22a12f09fe6d
}


--Events--

