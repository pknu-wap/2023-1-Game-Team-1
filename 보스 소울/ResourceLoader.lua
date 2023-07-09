--Properties--

string swordSkillDataSetName = "SwordSkillData"
string wandSkillDataSetName = "WandSkillData"


--Methods--

[Client Only]
void OnBeginPlay()
{
	local dataSetNames = {self.swordSkillDataSetName, self.wandSkillDataSetName}
	local columns = {"EffectRUID", "HitEffectRUID", "SoundRUID", "HitSoundRUID", "IconRUID"}
	local resouces = {"af166c03cbbd4c82b128f1ad8f3cbaf4", "114cfd8a5b0842f1a21432d386f3c7fc",
		"c1996d3f0225490ca9a551fad51eb29e", "a2b497a1013f44e7b29ef8de081720f1", "62eb26d02ba14671b74a5a871aac94ac", "5b84bbcf3b9f4c9b945d16775e65df5e"}
	
	for _, dataSetName in pairs(dataSetNames) do
		local dataSet = _DataService:GetTable(dataSetName)
		for _, row in pairs(dataSet:GetAllRow()) do
			for _, column in pairs(columns) do
				local res = _DataSetToTable:GetStringTable(row:GetItem(column))
				for k, v in pairs(res) do
					table.insert(resouces, v)
				end
			end
		end
	end
	
	_ResourceService:PreloadAsync(resouces, function() log("스킬 리소스 로드완료") end)
}


--Events--

