--Properties--

Entity summon
string dummy = "model://5608ba45-680a-4c0f-9b4a-7f92c01a6ce7"
Entity map


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.summon:ConnectEvent(ButtonClickEvent, function() self:Summon() end)
}

[Server]
void Summon()
{
	_SpawnService:SpawnByModelId(self.dummy, "Dummy", Vector3(-5, -0.435, 0), self.map)
}


--Events--

