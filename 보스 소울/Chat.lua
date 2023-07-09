--Properties--

string dataSetName = nil
number startIndex = nil
number endIndex = nil
table names
table images
table scripts
number idx = 1
Entity btnPrev
Entity btnNext
Component nameText
Component imageSprite
Component scriptText
Entity uiDialog
Entity btnComplete
string playerName = nil
Entity avatar
Component todd


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 데이터셋 불러오기
	
	local dataSet = _DataService:GetTable(self.dataSetName)
	for k, row in pairs(dataSet:GetAllRow()) do
		self.names[k] = row:GetItem("name")
		self.images[k] = row:GetItem("image")
		self.scripts[k] = row:GetItem("script")
	end
	
	-- 이벤트 연결
	
	self.playerName = _UserService.LocalPlayer.PlayerComponent.Nickname
	self.btnPrev:ConnectEvent(ButtonClickEvent, self.OnClickBtnPrev)
	self.btnNext:ConnectEvent(ButtonClickEvent, self.OnClickBtnNext)
	self.btnComplete:ConnectEvent(ButtonClickEvent, self.OnClickBtnComplete)
}

[Client]
void UpdateUI(number idx)
{
	self.idx = idx
	
	if self.names[idx] == "playerName" then
		self.nameText.Text = self.playerName
	else
		self.nameText.Text = self.names[idx]
	end
	
	if self.images[idx] == "playerImage" then
		self.avatar.Enable = true
		self.imageSprite.ImageRUID = "3e9d52ed52d64794bbd6f72bab8ee3d9"
	else
		self.avatar.Enable = false
		self.imageSprite.ImageRUID = self.images[idx]
	end
	
	self.scriptText.Text = self.scripts[idx]
	
	self.btnPrev.Enable = (idx ~= self.startIndex)
	self.btnNext.Enable = (idx ~= self.endIndex)
}

[Client]
void OnClickBtnPrev()
{
	if self.idx == 1 then return end
	self:UpdateUI(self.idx - 1)
}

[Client]
void OnClickBtnNext()
{
	if self.idx == self.endIndex then return end
	self:UpdateUI(self.idx + 1)
}

[Client]
void OnClickBtnComplete()
{
	self.uiDialog.Enable = false
	self.todd:EndChatEvent()
}


--Events--

