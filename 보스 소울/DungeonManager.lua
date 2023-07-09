--Properties--

integer roomIdx = 0
number checkReadyPlayerTimer = 0
integer playerNumPerGame = 0
string dungeonName = ""
Entity matchPanelUI
integer gameIdx = 0
Entity btn1
Entity btn2
Entity btn3
Entity btn4
Entity btnClose


--Methods--

[Default]
any GetOrCreateInstanceRoom()
{
	local instanceRoom = _RoomService:GetOrCreateInstanceRoom(self.dungeonName..tostring(self.roomIdx))
	self.roomIdx = self.roomIdx + 1
	return instanceRoom
}

[Server Only]
void OnUpdate(number delta)
{
	self.checkReadyPlayerTimer = self.checkReadyPlayerTimer + delta
	
	if self.checkReadyPlayerTimer >= 5.0 then
		self.checkReadyPlayerTimer = 0.0
		
		local readyPlayerNum = 0
		local readyPlayers = {}
		
		for k, v in pairs(_UserService:GetUsersByMapName(self.Entity.CurrentMap.Name)) do
			if v.Player.isReady == true then
				log("유저 네임 " ..v.Name)
				readyPlayerNum = readyPlayerNum + 1
				readyPlayers[#readyPlayers+1] = v.Name
			end
		end
		
		log("플레이어 레디 첵 " ..readyPlayerNum .." " ..self.dungeonName)
		if readyPlayerNum >= self.playerNumPerGame then
			for i = 1, math.floor(readyPlayerNum / self.playerNumPerGame) do
				local instanceRoom = self:GetOrCreateInstanceRoom()
				local toSendPlayers = {}
				
				for j = 1, self.playerNumPerGame do
					local idx = (i-1) * self.playerNumPerGame + j
					toSendPlayers[#toSendPlayers+1] = readyPlayers[idx]
				end
				
				_RoomService:MoveUsersToInstanceRoom(instanceRoom.InstanceKey, toSendPlayers)
			end
		end
	end
}

[Server]
void enterDungeon(string dungeonName, string userName)
{
	log("들어가고자하는 던전의 이름 " ..dungeonName)
	local instanceRoom = _RoomService:GetOrCreateInstanceRoom(dungeonName..tostring(self.roomIdx), 100)
	
	self.roomIdx = self.roomIdx + 1
	if instanceRoom:IsValid() then
		log(instanceRoom.InstanceKey .."값 입니다. " ..userName .."은 던전으로 갑니다. ")
	
		_RoomService:MoveUserToInstanceRoom(instanceRoom.InstanceKey, userName, dungeonName)
	else
		log("안돼 돌아가")
	end
}

[Client]
void getButtonDungeon(string dungeonName)
{
	self.dungeonName = dungeonName
	self:enterDungeon(self.dungeonName, _UserService.LocalPlayer.Name)
}

[Client Only]
void OnBeginPlay()
{
	self.btn1:ConnectEvent(ButtonClickEvent, function() self:enterDungeon("Boss_Golem", _UserService.LocalPlayer.Name) end)
	self.btn2:ConnectEvent(ButtonClickEvent, function() self:enterDungeon("Boss_Stump", _UserService.LocalPlayer.Name) end)
	self.btn3:ConnectEvent(ButtonClickEvent, function() self:enterDungeon("Boss_KnightStatue", _UserService.LocalPlayer.Name) end)
	self.btn4:ConnectEvent(ButtonClickEvent, function() self:enterDungeon("Boss_Pirate", _UserService.LocalPlayer.Name) end)
	self.btnClose:ConnectEvent(ButtonClickEvent, function() self.matchPaneUI.Enable = false end)
}


--Events--

