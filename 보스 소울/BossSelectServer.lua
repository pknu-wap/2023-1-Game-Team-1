--Properties--

integer roomIdx = 0
dictionary<number, string> bossNameArr


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.bossNameArr[1] = "Boss_Golem"
	self.bossNameArr[2] = "Boss_KnightStatue"
	self.bossNameArr[3] = "Boss_Stump"
	self.bossNameArr[4] = "Boss_Pirate"
}

[Server]
void EnterDungeon(integer bossIdx, string userName)
{
	_UIWindowHandler:CloseWindow(userName)
	
	local dungeonName = self.bossNameArr[bossIdx]
	
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


--Events--

