--Properties--

string tutorialCompletedKey = "TutorialCompleted"


--Methods--

[Server]
boolean HasCompletedTutorial(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, tutorialCompleted = db:GetAndWait(self.tutorialCompletedKey)
	
	return tutorialCompleted ~= nil
}

[Server]
void SetTutorialCompleted(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	db:SetAndWait(self.tutorialCompletedKey, "1")
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
	-- 디버그용
	
	if key == KeyboardKey.A then
		log("A")
		self:SetTutorialCompleted(_UserService.LocalPlayer.Name)
	end
}

