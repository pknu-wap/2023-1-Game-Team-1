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

