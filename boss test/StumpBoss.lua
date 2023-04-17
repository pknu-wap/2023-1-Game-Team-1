--Properties--

number test = 2


--Methods--

[Server Only]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	self.stateComponent:AddState("Chase")
	
}


--Events--

