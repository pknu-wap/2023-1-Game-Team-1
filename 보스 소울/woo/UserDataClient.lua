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
	log("setUserData")
	self.userData = _HttpService:JSONDecode(userDataJson)
	self:InitUI()
}

[Client]
table GetLevel(string class)
{
	-- class에 해당하는 클래스의 레벨, 경험치 정보를 {level, exp} 형태로 반환
	return self.userData.level[class]
}

[Client]
table GetQuickSlot(string class)
{
	-- class에 해당하는 클래스의 퀵 슬롯 정보를 int[6] 형태로 반환
	--log("getQuickSlot")
	return self.userData.quickSlot[class]
}

[Client]
table GetBossClear(string bossName)
{
	-- bossName에 해당하는 보스의 난이도별 클리어 여부를 boolean[3] 형태로 반환
	return self.userData.bossClear[bossName]
}

[Client]
void InitUI()
{
	log("UI Initialize")
	_HUDClient:Init()
	_SkillSetClient:Init()
	_BossSelectClient:Init()
}


--Events--

