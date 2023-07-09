--Properties--

Entity startPoint
Entity difficultEntity
array<Entity> selected
array<Entity> buttons
array<Entity> locks
array<Entity> difficultButton
array<Entity> difficultLight
Component difficultText
dictionary<string, TextComponent> bossInfo
Component bossImg
integer currentBoss = 0
integer currentDifficult = 1
Entity startButton


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 보스 슬롯
	---@type table<Entity>
	local bossTable = {
		_BossSelectEnum.boss1, _BossSelectEnum.boss2, _BossSelectEnum.boss3, _BossSelectEnum.boss4, 
		_BossSelectEnum.boss5, _BossSelectEnum.boss6, _BossSelectEnum.boss7}
	
	for idx, boss in ipairs(bossTable) do
		---@type Entity
		local selected = boss:GetChildByName("Selected")
		---@type Entity
		local button = boss:GetChildByName("Button")
		---@type Entity
		local lock = button:GetChildByName("Lock")
		self.selected[idx] = selected
		self.buttons[idx] = button
		self.locks[idx] = lock
		button:ConnectEvent(ButtonClickEvent, function() self:BossClicked(idx) end)
	end
	
	
	-- 보스 정보 슬롯
	self.bossInfo[_BossSelectEnum.Grade] = _BossSelectEnum.bossGrade
	self.bossInfo[_BossSelectEnum.Name] = _BossSelectEnum.bossName
	self.bossInfo[_BossSelectEnum.BattlePoint] = _BossSelectEnum.bossBattlePoint
	self.bossInfo[_BossSelectEnum.Reward] = _BossSelectEnum.bossReward
	self.bossInfo[_BossSelectEnum.ClearCount] = _BossSelectEnum.bossClearCount
	
	
	-- 난이도 설정 버튼
	local left = self.difficultEntity:GetChildByName("Left")
	local right = self.difficultEntity:GetChildByName("Right")
	local center = self.difficultEntity:GetChildByName("Center")
	
	self.difficultButton[_BossSelectEnum.Left] = left
	self.difficultButton[_BossSelectEnum.Right] = right
	
	left:ConnectEvent(ButtonClickEvent, function() self:DifficultChange(_BossSelectEnum.Left) end)
	right:ConnectEvent(ButtonClickEvent,function() self:DifficultChange(_BossSelectEnum.Right) end)
	
	-- 난이도 반짝이
	local easy = center:GetChildByName("Easy"):GetChildByName("Selected")
	local normal = center:GetChildByName("Normal"):GetChildByName("Selected")
	local hard = center:GetChildByName("Hard"):GetChildByName("Selected")
	
	self.difficultLight[_BossSelectEnum.Easy] = easy
	self.difficultLight[_BossSelectEnum.Normal] = normal
	self.difficultLight[_BossSelectEnum.Hard] = hard
	
	
	-- 버튼 연결
	self.startButton:ConnectEvent(ButtonClickEvent, function() self:StartBoss() end)
	
	-- Enum 비우기
	_BossSelectEnum:SetNull()
}

[Client]
void BossClicked(integer bossNum)
{
	for _, selected in pairs(self.selected) do
		selected:SetVisible(false)
	end
	
	self.selected[bossNum]:SetVisible(true)
	self.currentBoss = bossNum
	self:DifficultSet(_BossSelectEnum.Easy)
}

[Client]
void DifficultChange(integer dir)
{
	local cur = self.currentDifficult
	if cur == 0 then 
		cur = 1 
	
	elseif dir == _BossSelectEnum.Left then
		if cur == 1 then
			return
		else 
			cur -= 1	
		end
		
	elseif dir == _BossSelectEnum.Right then
		if cur == 3 then
			return
		else
			cur += 1
		end
		
	end
	
	for _, light in pairs(self.difficultLight) do
		light:SetVisible(false)
	end
	
	self.difficultLight[cur]:SetVisible(true)
	self.difficultText.Text = _BossSelectEnum.difficultText[cur]
	self.difficultText.FontColor = Color.FromHexCode(_BossSelectEnum.difficultColor[cur])
	self.currentDifficult = cur
	
	self:BossInfo()
}

[Client]
void DifficultSet(integer difficult)
{
	for _, light in pairs(self.difficultLight) do
		light:SetVisible(false)
	end
	
	self.difficultLight[difficult]:SetVisible(true)
	self.difficultText.Text = _BossSelectEnum.difficultText[difficult]
	self.difficultText.FontColor = Color.FromHexCode(_BossSelectEnum.difficultColor[difficult])
	self.currentDifficult = difficult
	
	self:BossInfo()
}

[Client]
void BossInfo()
{
	local boss = self.currentBoss
	local diff = self.currentDifficult
	
	local bossNum = ((boss - 1) * 3) + diff
	
	local bossRow = _DataService:GetTable(_DataSetEnum.BossDataSet):GetRow(boss)
	local bossDifficultRow = _DataService:GetTable(_DataSetEnum.BossDifficultDataSet):GetRow(bossNum)
	
	local bossName = bossRow:GetItem(_BossSelectEnum.Name)
	local bossImg = bossRow:GetItem(_BossSelectEnum.Img)
	
	local bossGrade = bossDifficultRow:GetItem(_BossSelectEnum.Grade)
	local bossReward = bossDifficultRow:GetItem(_BossSelectEnum.Reward)
	local bossBattlePoint = bossDifficultRow:GetItem(_BossSelectEnum.BattlePoint)
	
	-- 보스 클리어 횟수 불러오는 기능 만들기
	local bossClearCount = 0
	local bossClearText = "클리어 : "..tostring(bossClearCount).."번"
	
	self.bossInfo[_BossSelectEnum.Grade].Text = bossGrade
	self.bossInfo[_BossSelectEnum.Name].Text = bossName
	self.bossInfo[_BossSelectEnum.BattlePoint].Text = bossBattlePoint
	self.bossInfo[_BossSelectEnum.Reward].Text = bossReward
	self.bossInfo[_BossSelectEnum.ClearCount].Text = bossClearText
	
	self.bossImg.ImageRUID = bossImg
}

[Client]
void StartBoss()
{
	-- 해당 플레이어가 이 보스, 이 난이도를 도전할 수 있는지 확인 하기
	-- 방찾기 코드 짜기
}


--Events--

