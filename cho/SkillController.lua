--Properties--

table quick


--Methods--

[Client]
void Init()
{
	self.quick = _UserDataClient:GetQuickSlot("sword")
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
	if key == KeyboardKey.A then
		_SkillManager:ConvertIndexToKey(1, self.quick[1]):PreSkill()
		
	elseif key == KeyboardKey.S then
		_SkillManager:ConvertIndexToKey(1, self.quick[2]):PreSkill()
		
	elseif key == KeyboardKey.D then
		_SkillManager:ConvertIndexToKey(1, self.quick[3]):PreSkill()
		
	elseif key == KeyboardKey.Z then
		_SkillManager:ConvertIndexToKey(1, self.quick[4]):PreSkill()
	
	elseif key == KeyboardKey.X then
		_SkillManager:ConvertIndexToKey(1, self.quick[5]):PreSkill()
	
	elseif key == KeyboardKey.C then
		_SkillManager:ConvertIndexToKey(1, self.quick[6]):PreSkill()
		
	elseif key == KeyboardKey.V then
		_SkillManager:UseSkill("sword", "sw7")	
			
	elseif key == KeyboardKey.P then
		_UserService.LocalPlayer.ExtendPlayerComponent:RecoverHp(1000)
		log("피 회복")
	end
}

