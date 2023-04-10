--Properties--

string cnt = "Text_item_count"
string line = "line_selected"


--Methods--

[Client Only]
void OnBeginPlay()
{
	local cnt = self.Entity:GetChildByName(self.cnt)
	local line = self.Entity:GetChildByName(self.line)
	--cnt.Enable = false
	line.Enable = false
}


--Events--

