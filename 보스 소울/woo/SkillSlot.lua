--Properties--

Component icon
string RUID = ""


--Methods--

[Client]
void Change(string RUID)
{
	self.RUID = RUID
	self.icon.ImageRUID = RUID
}


--Events--

