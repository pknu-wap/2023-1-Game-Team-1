--Properties--

string currentJob = "sword"
Entity NewValue1
boolean isMain = true


--Methods--

[Client]
void UseSkill(number idx)
{
	if self.currentJob == "sword" then
		if idx == 1 then
			_SkillManager:UseSkill("sw1")
		elseif idx == 2 then
			_SkillManager:UseSkill("sw2")
		elseif idx == 3 then
			_SkillManager:UseSkill("sw3")
		elseif idx == 4 then
			_SkillManager:UseSkill("sw4")
		elseif idx == 5 then
			_SkillManager:UseSkill("sw5")
		elseif idx == 6 then
			_SkillManager:UseSkill("sw6")
		elseif idx == 7 then
			_SkillManager:UseSkill("swU")
		end
	else
		if idx == 1 then
			_SkillManager:UseSkill("wa1")
		elseif idx == 2 then
			_SkillManager:UseSkill("wa2")
		elseif idx == 3 then
			_SkillManager:UseSkill("wa3")
		elseif idx == 4 then
			_SkillManager:UseSkill("wa4")
		elseif idx == 5 then
			_SkillManager:UseSkill("wa5")
		elseif idx == 6 then
			_SkillManager:UseSkill("wa6")
		elseif idx == 7 then
			_SkillManager:UseSkill("waU")
		end
	end
}

[Client]
void ChangeJob(string job)
{
	self:ChangeComponent(self.currentJob, job)
	
	self.currentJob = job
	_SkillUI:ChangeUI(job)
}

[Default]
string GetCurrentJob()
{
	return self.currentJob
}

[Server]
void ChangeComponent(string prev, string next)
{
	local db = _DataStorageService:GetUserDataStorage(self.Entity.Name)
	local _, currentEquipmentJson = db:GetAndWait("currentEquipment")
	local _, equipStatusJson = db:GetAndWait("EquipStatus")
	local equipStatus = _HttpService:JSONDecode(equipStatusJson)
	local currentEquipment = _HttpService:JSONDecode(currentEquipmentJson)
	local mainWeapon = currentEquipment[1]
	local subWeapon = currentEquipment[2]
	
	if subWeapon == "0" then return end 
	
	self.Entity.CostumeManagerComponent:SetEquip(MapleAvatarItemCategory.OneHandedWeapon, "")
	self.Entity.CostumeManagerComponent:SetEquip(MapleAvatarItemCategory.TwoHandedWeapon, "")
	
	if self.isMain then
		self.Entity.CostumeManagerComponent:SetEquip(MapleAvatarItemCategory.OneHandedWeapon, equipStatus[subWeapon].RUID)
		self.isMain = false
	else
		self.Entity.CostumeManagerComponent:SetEquip(MapleAvatarItemCategory.TwoHandedWeapon, equipStatus[mainWeapon].RUID)
		self.isMain = true
	end
	
	if prev == "sword" then 
	    self.Entity:RemoveComponent(PlayerAttack_Sword)
	    self.Entity:AddComponent(PlayerAttack_Wand)
	else
	    self.Entity:RemoveComponent(PlayerAttack_Wand)
	    self.Entity:AddComponent(PlayerAttack_Sword)
	end
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
	if key == KeyboardKey.C then
		self:UseSkill(1)
		
	elseif key == KeyboardKey.V then
		self:UseSkill(2)
		
	elseif key == KeyboardKey.A then
		self:UseSkill(3)
		
	elseif key == KeyboardKey.S then
		self:UseSkill(4)
		
	elseif key == KeyboardKey.D then
		self:UseSkill(5)
		
	elseif key == KeyboardKey.F then
		self:UseSkill(6)
	
	elseif key == KeyboardKey.Q then
		self:UseSkill(7)
		
	elseif key == KeyboardKey.Space then
		if self.currentJob == "sword" then
			self:ChangeJob("wand")
		else 
			self:ChangeJob("sword")
		end
		
	elseif key == KeyboardKey.P then
		_UserService.LocalPlayer.ExtendPlayerComponent:RecoverHp(1000)
		log("피 회복")
	end
}

