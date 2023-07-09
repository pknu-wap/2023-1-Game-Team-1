--Properties--

integer page = nil
integer group = nil
integer idx = nil
string img = nil
string itemId = nil
string numValue = nil
boolean locked = false
boolean isSelected = false
boolean isEquipped = false
boolean isChanged = false
Component slot
Component icon
Component num
Entity equippedSlot


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.slot = self.Entity.SpriteGUIRendererComponent
	
	if self.Entity:GetChildByName("Icon") ~= nil then
		self.icon = self.Entity:GetChildByName("Icon").SpriteGUIRendererComponent 
	end
	
	if self.Entity:GetChildByName("Num") ~= nil then
		self.num = self.Entity:GetChildByName("Num").TextComponent 
	end
	
	if self.Entity:GetChildByName("EquippedSlot") ~= nil then
		self.equippedSlot = self.Entity:GetChildByName("EquippedSlot") 
	end
}

[Client]
ItemSlot Create(integer page, integer group, integer idx)
{
	self.page = page
	self.group = group
	self.idx = idx
	self.isChanged = true
	return self.Entity.ItemSlot
}

[Client]
void Update()
{
	if self.isChanged then
		-- 슬롯 이미지
		if self.isSelected then self.slot.ImageRUID = _Util.SelectedSlot
		else self.slot.ImageRUID = _Util.DefaultSlot end
		
		-- 아이템 이미지
		if self.locked == false then self.icon.ImageRUID = _Util.LockImg
		elseif self.img == nil then self.icon.ImageRUID = _Util.EmptyImg 
		else self.icon.ImageRUID = self.img end
		
		-- 아이템 값
		if self.num ~= nil then self.num.Text = self.numValue end
		
		-- 장착중 텍스트
		if self.equippedSlot ~= nil then self.equippedSlot:SetEnable(self.isEquipped) end
	
		self.isChanged = false
	end
}

[Client]
void SetItem(string itemId, string RUID)
{
	self.itemId = itemId
	self.img = RUID
	self.isChanged = true
}

[Client]
void SetSlotInfo(boolean selected, boolean equipped)
{
	if selected ~= nil then
		self.isSelected = selected
	end
	if equipped ~= nil then
		self.isEquipped = equipped
	end
	
	self.isChanged = true
}

[Client]
void SetNum(string num)
{
	self.numValue = num
	self.isChanged = true
}

[Client]
void SetLock(boolean lock)
{
	self.locked = lock
	self.isChanged = true
}

[Client]
void SetItemNum(string itemId, string RUID, string num)
{
	self.itemId = itemId
	self.img = RUID
	self.numValue = num
	self.isChanged = true
}


--Events--

[Client Only]
HandleButtonClickEvent(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	log(self.page, self.group, self.idx)
	--_EnhanceClient:SlotSelect(self.group, self.idx, self.itemId)
}

