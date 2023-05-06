--Properties--

Entity currentSelected
string userId = nil
number currentIdx = -1
number currentItemId = 0
Entity menu


--Methods--

[Client]
void Select(Entity selected, number idx, number itemId)
{
	--woo : menu가 처음 배치될 때 원하는 곳으로 안가는 문제
	--woo : select 후 같은 슬롯을 눌러 deselect한 경우 다른 슬롯을 누르면 이전 위치에서 menu가 잠시 보이는 문제
	
	if self.currentIdx == idx then
		self:Deselect()
		
	else
		self:Deselect()
		selected.Enable = true
		self.currentSelected = selected
		self.currentIdx = idx
		self.currentItemId = itemId
		
		--woo : 메뉴 위치 옮기기
		local selectedComp = selected.UITransformComponent
		local position = Vector3(selectedComp.WorldPosition.x + (selectedComp.RectSize.x / 2) + 16, selectedComp.WorldPosition.y, 0)
		self.menu.UITransformComponent.WorldPosition = position
		
		self.menu:SetVisible(true)	
	end
	
	log(itemId)
	
}

[Client]
void Deselect()
{
	if self.currentIdx == -1 then return end
	self.currentSelected.Enable = false
	self.currentSelected = nil
	self.currentIdx = -1
	self.currentItemId = 0
	self.menu:SetVisible(false)
}


--Events--

