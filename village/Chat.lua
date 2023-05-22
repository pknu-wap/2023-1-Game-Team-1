--Properties--

string dataSetName = ""


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 데이터셋 불러오기
	
	local dataSet = _DataService:GetTable(self.dataSetName)
	for _, row in pairs(dataSet:GetAllRow()) do
		local name = row:GetItem("name")
		local image = row:GetItem("image")
		local script = row:GetItem("script")
	end
}


--Events--

