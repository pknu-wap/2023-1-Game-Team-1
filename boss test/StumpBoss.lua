--Properties--

number speed = 0.5


--Methods--

[Server Only]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	self.stateComponent:AddState("Chase")
	self.stateComponent:AddState("ATTACK1")
	self.stateComponent:AddState("ATTACK2")
	self.stateComponent:AddState("ATTACK3")
	self.Entity.MovementComponent.InputSpeed = self.speed
}


--Events--

