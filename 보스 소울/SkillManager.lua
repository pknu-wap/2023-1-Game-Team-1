--Properties--

table skillDictionary


--Methods--

[Default]
void OnBeginPlay()
{
	self.skillDictionary = {}
	
	local sword = {
		sw1 = _SwordSkill1,
		sw2 = _SwordSkill2,
		sw3 = _SwordSkill3,
		sw4 = _SwordSkill4,
		sw5 = _SwordSkill5,
		sw6 = _SwordSkill6,
		sw7 = _SwordUltimateSkill,
		}
	
	local wand = {
		wa1 = _WandSkill1,
		wa2 = _WandSkill2,
		wa3 = _WandSkill3,
		wa4 = _WandSkill4,
		wa5 = _WandSkill5,
		wa6 = _WandSkill6,
		wa7 = _WandUltimateSkill
		}
	
	local dagger = {
		dg1 = _DaggerSkill1,
		dg2 = _DaggerSkill2,
		dg3 = _DaggerSkill3,
		dg4 = _DaggerSkill4
		}
	
	self.skillDictionary = {
		sword = sword,
		wand = wand,
		dagger = dagger
		}
}

[Client]
void UseSkill(string class, string key)
{
	self.skillDictionary[class][key]:PreSkill()
}

[Default]
any ConvertIndexToKey(integer classIndex, integer keyIndex)
{
	if classIndex == 1 then
		return self.skillDictionary["sword"]["sw"..tostring(keyIndex)]
	elseif classIndex == 2 then
		return self.skillDictionary["wand"]["wa"..tostring(keyIndex)]
	elseif classIndex == 3 then
		return self.skillDictionary["dagger"]["dg"..tostring(keyIndex)] 
	end
}


--Events--

