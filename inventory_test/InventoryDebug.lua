[Properties]

Entity reset 
Entity get 
Entity pget 
Entity getSword 


[Methods]

void OnBeginPlay() {
	self.reset:ConnectEvent("ButtonClickEvent", self.Reset)
	self.get:ConnectEvent(ButtonClickEvent, function() self:Get("2") end)
	self.pget:ConnectEvent(ButtonClickEvent, function() self:Get("3") end)
	self.getSword:ConnectEvent(ButtonClickEvent, function() self:GetEquip("10002") end)
}


void Reset() {
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:ResetInventory(id)
}


void Get(string code) {
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddItem(id, code)
}


void GetEquip(string code) {
	local id = _UserService.LocalPlayer.Name
	_InventoryServer:AddEquip(id, code)
}


