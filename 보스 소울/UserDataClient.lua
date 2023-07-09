--Properties--

table userData


--Methods--

[Client Only]
void OnBeginPlay()
{
	local userId = _UserService.LocalPlayer.Name
	_UserDataServer:OnUserEnter(userId)
}

[Client]
void SetUserData(string userDataJson)
{
	self.userData = _HttpService:JSONDecode(userDataJson)
}


--Events--

