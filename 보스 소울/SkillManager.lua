--Properties--

table skillDictionary


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.skillDictionary = {
		sw1 = _SwordSkill1,
		sw2 = _SwordSkill2,
		sw3 = _SwordSkill3,
		sw4 = _SwordSkill4,
		sw5 = _SwordSkill5,
		sw6 = _SwordSkill6,
		swU = _SwordUltimateSkill,
		wa1 = _WandSkill1,
		wa2 = _WandSkill2,
		wa3 = _WandSkill3,
		wa4 = _WandSkill4,
		wa5 = _WandSkill5,
		wa6 = _WandSkill6,
		waU = _WandUltimateSkill
	}
}

[Client]
void UseSkill(string key)
{
	self.skillDictionary[key]:PreSkill()
}


--Events--

