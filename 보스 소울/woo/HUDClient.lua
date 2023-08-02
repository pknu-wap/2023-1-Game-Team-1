--Properties--

Component hp
Component mp
dictionary<integer, Gauge> skillGauge
dictionary<integer, SkillSlot> skillSlot
Entity skill
Component ult
integer currentClass = 1
Component playerComponent


--Methods--

[Client Only]
void OnBeginPlay()
{
	
}

[Client]
void Init()
{
	log("HUD Init")
	self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
	self.hp:Init(self.playerComponent.MaxHp, false, true)
	self.mp:Init(self.playerComponent.MaxMp, false, true)
	self.ult:Init(100, false, false)
	for i = 1, 7 do
		local text = "Skill" .. tostring(i)
		local entity = self.skill:GetChildByName(text)
		self.skillGauge[i] = entity.Gauge
		self.skillGauge[i]:Init(100, true, false)
		
		self.skillSlot[i] = entity.SkillSlot
	end
	
	
}

[Client]
void SetSkillCoolTime()
{
	local skillArr = _UserDataClient:GetQuickSlot(_Util:ClassIdxToString(self.currentClass))
	
	for i = 1, 6 do
		local skillIdx = skillArr[i]
		local skill = _SkillManager:ConvertIndexToKey(self.currentClass, skillIdx)
		self.skillGauge[skillIdx]:Init(skill.skillCoolTime, nil, nil)
		self.skillSlot[skillIdx]:Change(_SkillSetClient.skillRUIDArray[self.currentClass][skillIdx])
	end
	
	_UserService.LocalPlayer.SkillController:Init()
}

[Client Only]
void OnUpdate(number delta)
{
	--if 1==1 then return end
	local job = _Util:ClassIdxToString(self.currentClass)
	local skillArr = _UserDataClient:GetQuickSlot(job)
	
	for i = 1, 6 do
		local skill = _SkillManager:ConvertIndexToKey(self.currentClass, i)
		self.skillGauge[skillArr[i]]:SetValue(skill.remainCoolTime)
	end
	
	self.hp:SetValue(self.playerComponent.Hp)
	self.mp:SetValue(self.playerComponent.Mp)
}


--Events--

