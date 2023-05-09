--Properties--



--Methods--


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
		_SkillManager:Skill1()
		
	elseif key == KeyboardKey.S then
		_SkillManager:Skill2()
		
	elseif key == KeyboardKey.D then
		_SkillManager:Skill3()
		
	elseif key == KeyboardKey.F then
		_SkillManager:Skill4()
		
	elseif key == KeyboardKey.C then
		_SkillManager:Skill5()
	
	elseif key == KeyboardKey.V then
		_SkillManager:UltimateSkill()
	
	elseif key == KeyboardKey.X then
		_SkillManager:Dash()
	end
}

