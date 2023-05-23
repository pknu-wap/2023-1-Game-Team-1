--Properties--

string dataSetName = ""
table names
table images
table scripts
number idx = 1
Entity btnPrev
Entity btnNext
Component nameText
Component imageSprite
Component scriptText
Entity ui
Entity uiDialog
Entity btnComplete


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
	
	self.ui.Enable = true
	self.uiDialog.Enable = true
	self.btnPrev:ConnectEvent(ButtonClickEvent, self.OnClickBtnPrev)
	self.btnNext:ConnectEvent(ButtonClickEvent, self.OnClickBtnNext)
	self.btnComplete:ConnectEvent(ButtonClickEvent, self.OnClickBtnComplete)
}

[Client]
void UpdateUI(number idx)
{
	self.nameText.Text = self.names[idx]
	self.imageSprite.ImageRUID = self.images[idx]
	self.scriptText.Text = self.scripts[idx]
	
	self.btnPrev.Enable = (idx ~= 1)
	self.btnNext.Enable = (idx ~= #self.scripts)
}

[Client]
void OnClickBtnPrev()
{
	if self.idx == 1 then return end
	self.idx = self.idx - 1
	self:UpdateUI(self.idx)
}

[Client]
void OnClickBtnNext()
{
	if self.idx == #self.scripts then return end
	self.idx = self.idx + 1
	self:UpdateUI(self.idx)
}

[Client]
void OnClickBtnComplete()
{
	self.uiDialog.Enable = false
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
	if key == KeyboardKey.Q then
		self.uiDialog.Visible = true
		self:UpdateUI(1)
	end
}

