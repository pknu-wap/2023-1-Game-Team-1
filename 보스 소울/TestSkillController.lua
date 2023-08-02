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
		_SkillManager:UseSkill("dagger", "dg1")
		
	elseif key == KeyboardKey.S then
		_SkillManager:UseSkill("dagger", "dg2")
		
	elseif key == KeyboardKey.D then
		_SkillManager:UseSkill("dagger", "dg3")
	
	elseif key == KeyboardKey.F then
		_SkillManager:UseSkill("dagger", "dg4")
	end
}

