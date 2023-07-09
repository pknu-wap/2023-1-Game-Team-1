--Properties--

Entity title
number roomIdx = 0
string tutorialMapName = "Tutorial"
string townMapName = "Town"


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 플레이어 비활성화
	
	local scale = _UserService.LocalPlayer.TransformComponent.Scale
	scale.x = 0
	scale.y = 0
	
	-- 타이틀 표시
	
	self.title.Enable = true
}

[Server]
void MoveUserToTutorial(string userId)
{
	local room = _RoomService:CreateInstanceRoom(tostring(self.roomIdx), {self.tutorialMapName})
	_RoomService:MoveUserToInstanceRoom(tostring(self.roomIdx), userId, self.tutorialMapName)
	self.roomIdx = self.roomIdx + 1
}

[Server]
void MoveUserToTown(string userId)
{
	_TeleportService:TeleportToMapPosition(_UserService:GetUserEntityByUserId(userId), Vector3.zero, self.townMapName)
}

[Server]
void Entry(string userId)
{
	if _EntryChecker:HasCompletedTutorial(userId) then
		self:MoveUserToTown(userId);
	else
		self:MoveUserToTutorial(userId);
	end
}

[Client Only]
void OnMapLeave(Entity leftMap)
{
	self.title.Enable = false;
}


--Events--

[Default]
HandleKeyDownEvent(KeyDownEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: InputService
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local key = event.key
	---------------------------------------------------------
	if key ~= KeyboardKey.X then return end
	local userId = _UserService.LocalPlayer.Name
	self:Entry(userId)
}

