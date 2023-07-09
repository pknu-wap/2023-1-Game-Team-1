--Properties--

string userDataKey = "UserData"


--Methods--

[Server]
void OnUserEnter(string userId)
{
	local db = _DataStorageService:GetUserDataStorage(userId)
	local _, userDataJson = db:GetAndWait(self.userDataKey)
	
	if not userDataJson then
		self:InitData(userId)
	end
}

[Server]
void InitData(string userId)
{
	local dummyDict = {
		dummy = "dummy"
	}
	
	local userData = {
	    item = {
	        equip = dummyDict,
	        consume = dummyDict,
	        material = dummyDict,
	        costume = dummyDict
	    },
	    
	    equip = {
			weapon = "",
			subWeapon = "",
			hat = "",
			top = "",
			bottom = "",
			gloves = "",
			shoes = ""
		},
	    
	    resource = {
			soul = 0,
			stone = 0
		}
	}
	
	local db = _DataStorageService:GetUserDataStorage(userId)
	local userDataJson = _HttpService:JSONEncode(userData)
	
	db:SetAndWait(self.userDataKey, userDataJson)
	_UserDataClient:SetUserData(userDataJson, userId)
}


--Events--

