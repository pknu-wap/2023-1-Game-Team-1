--Properties--



--Methods--

[Client Only]
void OnBeginPlay()
{
	local entity = self.Entity
	local children = entity.Children
	local equipped = children[3]
	local line = children[4]
	
	equipped.Enable = false
	line.Enable = false
}


--Events--

