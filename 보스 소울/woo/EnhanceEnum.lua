--Properties--

integer Enforce = 1
integer Scroll = 2
integer Enchant = 3
integer Succession = 4
Entity EquipSelectSlot
Entity ScrollSelectSlot
Entity SelectedEquipInfoSlot
Entity CostSlot
Entity SelectedEquipItemSlot
Entity SelectedEquipNameSlot
Entity EnforceEntity
Entity EquippedScrollEntity
integer EquipSelect = 1
integer ScrollSelect = 2
integer SelectedEquip = 3
integer EnforceSelected = 4
integer EnforceTarget = 5
integer EquippedScroll = 6
integer SelectedEquipInfo = 1
integer EnhanceCost = 2
table SlotsNum
integer AtkValue = 1
integer EnforceValue = 2


--Methods--

[Default]
void SetNull()
{
	self.EquipSelectSlot = nil
	self.ScrollSelectSlot = nil
	self.SelectedEquipInfoSlot = nil
	self.CostSlot = nil
	self.SelectedEquipItemSlot = nil
	self.SelectedEquipNameSlot = nil
	self.EnforceEntity = nil
	self.EquippedScrollEntity = nil
}


--Events--

