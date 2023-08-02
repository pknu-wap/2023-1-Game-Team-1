--Properties--

table BossDataSet
table BossDetailDataSet
table ClassDataSet
table ConsumeDataSet
table EnforceDataSet
table EquipDataSet
table ExpDataSet
table MaterialDataSet
table ScrollDataSet
table SkillClassDataSet


--Methods--

[Client Only]
void OnBeginPlay()
{
	local bossData = _DataService:GetTable("BossDataSet")
	local bossKeys = {"code", "img", "name"}
	
	
	local bossDetailData = _DataService:GetTable("BossDetailDataSet")
	local classData = _DataService:GetTable("ClassDataSet")
	local consumeDataSet = _DataService:GetTable("ConsumeDataSet")
	local enforceDataSet = _DataService:GetTable("EnforceDataSet")
	local equipDataSet = _DataService:GetTable("EquipDataSet")
	local expDataSet = _DataService:GetTable("ExpDataSet")
	local materialDataSet = _DataService:GetTable("MaterialDataSet")
	local scrollDataSet = _DataService:GetTable("ScrollDataSet")
	local skillClassDataSet = _DataService:GetTable("SkillClassDataSet")
	
	
	
}


--Events--

