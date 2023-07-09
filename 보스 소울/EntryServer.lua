--Properties--

string lastVisitKey = "lastVisit"


--Methods--

[Server]
string GetLastVisit(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, lastVisit = db:GetAndWait(self.lastVisitKey)
	return lastVisit
}

[Server]
void SetLastVisit(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local currentDay = DateTime.UtcNow:ToFormattedString("yyyy년 MM월 dd일")
	log(currentDay)
	db:SetAndWait(self.lastVisitKey, currentDay)
}

[Server]
void IsNewbie(string userId)
{
	
}

[Server Only]
void OnBeginPlay()
{
	self:SetLastVisit("asd")
}


--Events--

