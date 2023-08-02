--Properties--

string Id = "id"
string Probability = "probability"
string SoulCost = "soulCost"
string StoneCost = "stoneCost"
string Ratio = "ratio"
string Fixed = "fixed"
string Name = "name"
string Quality = "quality"
string Type = "type"
string Value = "value"
string Code = "code"
string AttackPoint = "attackPoint"
string AttackSpeed = "attackSpeed"
string Grade = "grade"
string Img = "img"
string Description = "description"
string TypeRatio = "r"
string TypeFixed = "f"
string ConsumeDataSet = "ConsumeDataSet"
string EnforceDataSet = "EnforceDataSet"
string EquipDataSet = "EquipDataSet"
string ScrollDataSet = "ScrollDataSet"
string MaterialDataSet = "MaterialDataSet"
string BossDetailDataSet = "BossDifficultDataSet"
string BossDataSet = "BossDataSet"
string ExpDataSet = "ExpDataSet"
string SkillClassDataSet = "SkillClassDataSet"
array<string> EquipDataSetKeys
integer EquipDataStartNum = 10000
string HeroSkillDataSet = "SwordSkillData"
string BishopSkillDataSet = "WandSkillData"
string ShadowerSkillDataSet = "DaggerSkillData"
dictionary<integer, string> SkillDataSet
number NewValue1 = 0


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.EquipDataSetKeys[1] = self.Code
	self.EquipDataSetKeys[2] = self.Type
	self.EquipDataSetKeys[3] = self.Name
	self.EquipDataSetKeys[4] = self.AttackPoint
	self.EquipDataSetKeys[5] = self.AttackSpeed
	self.EquipDataSetKeys[6] = self.Grade
	self.EquipDataSetKeys[7] = self.Img
	self.EquipDataSetKeys[8] = self.Description
	
	self.SkillDataSet[_ClassEnum.Sword] = self.HeroSkillDataSet
	self.SkillDataSet[_ClassEnum.Wand] = self.BishopSkillDataSet
	self.SkillDataSet[_ClassEnum.Dagger] = self.ShadowerSkillDataSet
}


--Events--

