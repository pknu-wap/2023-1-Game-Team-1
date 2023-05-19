--Properties--

Entity currentSelected
number currentIdx = -1
string currentItemId = ""


--Methods--

[Client]
void Select(Entity selected, number idx, string itemId)
{
	if itemId ~= "" then
		if self.currentIdx == idx then
			self:Deselect()
			_EnforceClient:WeaponSelect(itemId, idx)
			_EnforceTapHandler:TapOpen("left", "info")
			
		else
			self:Deselect()
			selected.Enable = true
			self.currentSelected = selected
			self.currentIdx = idx
			self.currentItemId = itemId
		end
	else
		self:Deselect()
	end
}

[Client]
void Deselect()
{
	if self.currentIdx == -1 then return end
	self.currentSelected.Enable = false
	self.currentSelected = nil
	self.currentIdx = -1
	self.currentItemId = "0"
}


--Events--

