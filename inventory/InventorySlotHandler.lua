--Properties--

Entity currentSelected
string userId = nil
number currentIdx = -1


--Methods--

[Client]
void Select(Entity selected, number idx)
{
	log("select")
	if self.currentIdx == idx then
		self:Deselect()
	elseif self.currentIdx ~= -1 then
		_InventoryClient:Swap(self.currentIdx, idx)
	    self:Deselect()
	else
		selected.Enable = true
		self.currentSelected = selected
		self.currentIdx = idx
	end
}

[Client]
void Deselect()
{
	if self.currentIdx == -1 then return end
	self.currentSelected.Enable = false
	self.currentSelected = nil
	self.currentIdx = -1
}


--Events--

