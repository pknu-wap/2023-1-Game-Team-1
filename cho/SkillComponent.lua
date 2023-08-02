--Properties--

integer idx = 0
integer group = 0
Entity selected
Entity locked
boolean isSelected = false
boolean isEmpty = false
boolean isLocked = false


--Methods--

[Client]
void SetValue(string RUID)
{
	self.Entity.SpriteGUIRendererComponent.ImageRUID = RUID
}

[Client]
void Update()
{
	if self.selected ~= nil then self.selected:SetEnable(self.isSelected) end
	if self.locked ~= nil then self.locked:SetEnable(self.isLocked) end
}

[Client]
void SetSelected(boolean selected)
{
	self.isSelected = selected
}

[Client]
void SetLocked(boolean locked)
{
	self.isLocked = locked
}

[Client]
integer GetIndex()
{
	return self.idx
}


--Events--

[Default]
HandleButtonClickEvent(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	
	_SkillSetClient:SkillSlotClicked(self.group, self.idx)
}

