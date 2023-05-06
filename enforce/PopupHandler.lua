--Properties--

string inventoryPageId = "0cc67633-7f10-4c0d-9d16-e4e0b720a160"
string enforcePageId = "254eb657-dd8f-4a60-b4f6-b0b4fc7acb75"
string inventoryKey = "inventory"
string enforceKey = "enforce"
dictionary<string, Entity> popups


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.popups[self.inventoryKey] = _EntityService:GetEntity(self.inventoryPageId)
	self.popups[self.enforceKey] = _EntityService:GetEntity(self.enforcePageId)
}

[Client Only]
void OpenPage(string pageKey)
{
	self:CloseAllPages()
	self.popups[pageKey]:SetEnable(true)
}

[Client Only]
void CloseAllPages()
{
	for _, popup in pairs(self.popups) do
		popup:SetEnable(false)
	end
}


--Events--

