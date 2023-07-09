--Properties--

Component icon1
Component icon2
Component icon3
Component icon4
Component icon5
Component icon6
Component icon7
Component icon8
Component cool1
Component cool2
Component cool3
Component cool4
Component cool5
Component cool6
Component cool7
Component cool8
Entity ui
table icons
table cools


--Methods--

[Client]
void SetIcons(string dataSetName)
{
	local dataSet = _DataService:GetTable(dataSetName)
	for k, row in ipairs(dataSet:GetAllRow()) do
		self.icons[k].ImageRUID = row:GetItem("IconRUID")
	end
}

[Client]
void ChangeUI(string job)
{
	self.ui.Enable = true
	if job == "wand" then
		self:SetIcons("WandSkillData")
	else
		self:SetIcons("SwordSkillData")
	end
}

[Client Only]
void OnUpdate(number delta)
{
	local player = _UserService.LocalPlayer
	
	local job = player.SkillController:GetCurrentJob()
	local skills = nil
	if job == "sword" then
		skills = { _SwordSkill1, _SwordSkill2, _SwordSkill3, _SwordSkill4, _SwordSkill5, _SwordSkill6, _SwordUltimateSkill }
	else
		skills = { _WandSkill1, _WandSkill2, _WandSkill3, _WandSkill4, _WandSkill5, _WandSkill6, _WandUltimateSkill,}
	end
	
	for i = 1, 6 do
		local cool = skills[i].remainCoolTime
		if (cool < 0.1) then
			self.icons[i].Color.a = 1
			self.cools[i].Text = ""
		else
			self.icons[i].Color.a = 0.5
			self.cools[i].Text = cool / 10
		end
	end
	
	self.cools[7].Text = player.ExtendPlayerComponent.Up
}

[Client Only]
void OnBeginPlay()
{
	self.icons = { self.icon2, self.icon3, self.icon4, self.icon5, self.icon6, self.icon7, self.icon8 }
	self.cools = { self.cool2, self.cool3, self.cool4, self.cool5, self.cool6 , self.cool7, self.cool8 }
	
	local map = _UserService.LocalPlayer.CurrentMapName
	if map  == "Title" or map == "Match" or map == "Forge" or map == "Tutorial" then return end
	
	local job = _UserService.LocalPlayer.SkillController:GetCurrentJob()
	
	self:ChangeUI(job)
	
	self.ui.Enable = true
}


--Events--

[Default]
HandleEntityMapChangedEvent(EntityMapChangedEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: Entity
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local NewMap = event.NewMap
	local OldMap = event.OldMap
	local Entity = event.Entity
	---------------------------------------------------------
	local map = NewMap.CurrentMapName
	
	if map  == "Title" or map == "Match" or map == "Forge" or map == "Tutorial" then
		self.ui.Enable = false
	return end
	
	local job = _UserService.LocalPlayer.SkillController:GetCurrentJob()
	
	self:ChangeUI(job)
	
	self.ui.Enable = true
}

