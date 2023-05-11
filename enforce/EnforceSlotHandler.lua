--Properties--

Entity currentSelected
string userId = nil
number currentIdx = -1
string currentItemId = ""


--Methods--

[Client]
void Select(Entity selected, number idx, string itemId)
{
	if itemId ~= 0 then
		if self.currentIdx == idx then
			self:Deselect()
			_EnforceClient:LoadEnforcePage(itemId)
			
		else
			self:Deselect()
			selected.Enable = true
			self.currentSelected = selected
			self.currentIdx = idx
			self.currentItemId = itemId
			log(itemId)
			
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
	self.currentItemId = 0
}


--Events--

