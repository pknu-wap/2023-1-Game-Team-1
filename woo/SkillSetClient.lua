--Properties--

table skillRUIDArray
dictionary<integer, ClassSlot> classSlots
dictionary<integer, SkillComponent> skillSlots
dictionary<integer, SkillComponent> quickSlots
dictionary<integer, integer> checkFlag
dictionary<integer, integer> quickSlotsFlag
Entity characters
Entity skillScroll
Entity quickSlot
integer currentClass = 0
table currentSkill
Entity resetButton
Entity submitButton


--Methods--

[Client Only]
void OnBeginPlay()
{
	
}

[Client]
void Init()
{
	log("skillSet init")
	-- 스킬 정보
	for class, dataSet in pairs(_DataSetEnum.SkillDataSet) do
		self.skillRUIDArray[class] = {}
		
		local data = _DataService:GetTable(dataSet)
		local RUIDColumns = data:GetColumn("IconRUID")
		
		for i = 1, #RUIDColumns do
			---@type table<integer, string>
			self.skillRUIDArray[class][i] = RUIDColumns[i]
		end
		
	end
	
	local data = _DataService:GetTable(_DataSetEnum.SkillClassDataSet)
	
	-- 캐릭터
	for i = 1, 4 do
		local text = "Char" .. tostring(i)
		
		local dataRow = data:GetRow(i)
		local selected = dataRow:GetItem(_SkillSetEnum.selected)
		local deselected = dataRow:GetItem(_SkillSetEnum.deselected)
		local krName = dataRow:GetItem(_SkillSetEnum.krName)
		local enName = dataRow:GetItem(_SkillSetEnum.enName)
		
		local slot = self.characters:GetChildByName(text).ClassSlot
		slot:Init(i, selected, deselected, krName, enName)
		slot:SetValue(false, false, 1, 0)
		slot:Update()
		self.classSlots[i] = slot
	end
	
	-- 스킬 슬롯
	for i = 1, 7 do
		local text = "Skill_" .. tostring(i)
		local slot = self.skillScroll:GetChildByName(text):GetChildByName("Icon").SkillComponent
		slot:SetSelected(false)
		
		self.skillSlots[i] = slot
		self.checkFlag[i] = 0
	end
	
	-- 퀵 슬롯
	for i = 1, 6 do
		local text = "Skill_" .. tostring(i)
		local slot = self.quickSlot:GetChildByName(text).SkillComponent
		slot:SetSelected(false)
		
		self.quickSlots[i] = slot
		self.quickSlotsFlag[i] = 0
	end
	
	-- 버튼
	self.resetButton:ConnectEvent(ButtonClickEvent, function() self:Reset() end)
	self.submitButton:ConnectEvent(ButtonClickEvent, function() self:Submit() end)
	
	self:ClassSlotClicked(1)
	self:UpdateSlots()
}

[Client]
void UpdateSlots()
{
	-- 클래스 슬롯 정보 업데이트
	for _, slot in pairs(self.classSlots) do
		slot:Update()
	end
	
	-- 스킬 슬롯 정보 업데이트
	for _, slot in pairs(self.skillSlots) do
		slot:Update()
	end
	
	-- 퀵슬롯 정보 업데이트
	for idx, slot in pairs(self.quickSlots) do
		local skillIdx = self.quickSlotsFlag[idx]
		local RUID = ""
		if skillIdx == 0 then RUID = _Util.EmptyImg
		else RUID = self.skillRUIDArray[self.currentClass][skillIdx] end
		slot:SetValue(RUID)
		slot:Update()
	end
}

[Client]
void ClassSlotClicked(integer classIdx)
{
	-- 다른 클래스들 비활성화
	for _, slot in pairs(self.classSlots) do
		slot:SetSelected(false)
	end
	
	-- 선택한 클래스 활성화
	self.classSlots[classIdx]:SetSelected(true)
	self.currentClass = classIdx
	
	-- 유저의 해당 클래스의 퀵슬롯 설정값을 가져옴
	-- 추후 변경
	for i = 1, 6 do
		self.checkFlag[i] = 0
	end
	
	-- 선택한 캐릭터 스킬로 변경
	for skillIdx = 1, 7 do
		local RUID = self.skillRUIDArray[classIdx][skillIdx]
		self.skillSlots[skillIdx]:SetValue(RUID)
		
	end
	
	self:Reset()
	self:UpdateSlots()
}

[Client]
void SkillSlotClicked(integer group, integer idx)
{
	-- 모든 스킬 슬롯 비활성화
	---@type table<table<SkillComponent>>
	local arr = {
		self.skillSlots,
		self.quickSlots
		}
	
	for _, slots in pairs(arr) do
		for _, slot in pairs(slots) do
			slot:SetSelected(false)
		end
	end
	 
	-- 선택된 슬롯이 없거나 같은 그룹의 슬롯일 때
	-- 파라미터로 받은 슬롯 설정
	if self.currentSkill[1] == 0 or self.currentSkill[1] == group then
		self.currentSkill[1] = group
		self.currentSkill[2] = idx
		if group == 1 then 
			self.skillSlots[idx]:SetSelected(true)
		else self.quickSlots[idx]:SetSelected(true) end
		
	-- 위의 경우를 제외하고 나머지는 모두 슬롯 선택 해제
	else
		-- 만약 스킬에서 퀵슬롯으로 선택하면 장착되게
		if self.currentSkill[1] == 1 and group == 2 then
			self:RegistSkillInQuickSlot(idx, self.currentSkill[2])
		end
		
		self.currentSkill[1] = 0
		self.currentSkill[2] = 0
	end
	
	self:UpdateSlots()
}

[Client]
void Reset()
{
	for i = 1, 6 do
		self.checkFlag[i] = 0
		self.quickSlotsFlag[i] = 0
	end
	
	self:UpdateSlots()
}

[Client]
void Submit()
{
	log("퀵 슬롯 저장")
	local name = _UserService.LocalPlayer.Name
	local class = _Util:ClassIdxToString(self.currentClass)
	local table = self.quickSlotsFlag
	_UserDataServer:SetQuickSlot(name, class, table)
}

[Client]
void RegistSkillInQuickSlot(integer quickIdx, integer skillIdx)
{
	local currentSkillRocation = self.checkFlag[skillIdx]
	local targetQuickSlot = self.quickSlotsFlag[quickIdx]
	
	-- 스킬이 이미 등록 되어 있으면
	if currentSkillRocation ~= 0 then
		self.quickSlotsFlag[currentSkillRocation] = 0
	end
	
	-- 대상 자리에 뭐가 있는 경우
	if targetQuickSlot ~= 0 then
		self.checkFlag[targetQuickSlot] = 0
	end
	
	self.quickSlotsFlag[quickIdx] = skillIdx
	self.checkFlag[skillIdx] = quickIdx
}


--Events--

