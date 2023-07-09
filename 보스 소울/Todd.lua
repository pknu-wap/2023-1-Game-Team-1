--Properties--

Component chat
Component trans
number mode = 0
Entity check
Entity ui
Entity quest
string returnMap = "Town"
Component questTrans


--Methods--

[Client]
void ChangeMode(number mode)
{
	self.mode = mode
	
	if mode == 1 then
		local id = _UserService.LocalPlayer.Name
		_EntryChecker:SetTutorialCompleted(id)
		self.ui.Enable = true
		self.chat.startIndex = 1
		self.chat.endIndex = 8
		self.chat:UpdateUI(1)
	elseif mode == 2 then
		self.quest.Enable = true
		self.chat.startIndex = 10
		self.chat.endIndex = 16
		self.trans.Position.x = -0.43
		self.trans.Position.y = 10.47
		self.questTrans.Position.x = -0.375
		self.questTrans.Position.y = 11.57
	elseif mode == 3 then
		self.ui.Enable = true
		self.chat:UpdateUI(10)
		self:Spawn()
	elseif mode == 4 then
		self.quest.Enable = true
		self.chat.startIndex = 18
		self.chat.endIndex = 24
	elseif mode == 5 then
		self.ui.Enable = true
		self.chat:UpdateUI(18)
		self.quest.Enable = false
	end
}

[Client]
void EndChatEvent()
{
	if self.mode == 1 then
		self.quest.Enable = false
	elseif self.mode == 3 then
		self.quest.Enable = false
		_SkillUI:ChangeUI("sword")
	elseif self.mode == 5 then
		local id = _UserService.LocalPlayer.Name
		self:GoBack(id)
	end
}

[Server]
void Spawn()
{
	local pos = Vector3(4.5, 12, 0)
	_SpawnService:SpawnByModelId("model://6089d8b1-9fcb-4183-a9e1-910cb7ca6e22", "mush", pos, self.Entity.Parent)
}

[Server]
void GoBack(string id)
{
	_RoomService:MoveUserToStaticRoom(id, self.returnMap)
}


--Events--

[Default]
HandleTouchEvent(TouchEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TouchReceiveComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local TouchId = event.TouchId
	local TouchPoint = event.TouchPoint
	---------------------------------------------------------
	if self.mode == 0 then
		self:ChangeMode(1)
	elseif self.mode == 2 then
		self:ChangeMode(3)
	elseif self.mode == 4 then
		self:ChangeMode(5)
	end
}

[Default]
HandleTriggerEnterEvent(TriggerEnterEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: TriggerComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local TriggerBodyEntity = event.TriggerBodyEntity
	---------------------------------------------------------
	if self.mode == 1 then
		self.check.Enable = false
		self:ChangeMode(2)
	end
}

