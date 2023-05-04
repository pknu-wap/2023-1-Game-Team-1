--Properties--

Component skill1
Component skill2
Component skill3
Component skill4
Component skill5
Component ultimateSkill
Component dash


--Methods--

[Client Only]
void OnBeginPlay()
{
	local player = _UserService.LocalPlayer
	
	self.skill1 = player.Skill1
	self.skill2 = player.Skill2
	self.skill3 = player.Skill3
	self.skill4 = player.Skill4
	self.skill5 = player.Skill5
	self.ultimateSkill = player.UltimateSkill
	self.dash = player.Dash
}

[Default]
void Skill1()
{
	self.skill1:PreSkill()
}

[Default]
void Skill2()
{
	self.skill2:PreSkill()
}

[Default]
void Skill3()
{
	self.skill3:PreSkill()
}

[Default]
void Skill4()
{
	self.skill4:PreSkill()
}

[Default]
void Skill5()
{
	self.skill5:PreSkill()
}

[Default]
void UltimateSkill()
{
	self.ultimateSkill:PreSkill()
}

[Default]
void Dash()
{
	self.dash:PreSkill()
}


--Events--

