--Properties--

Component controller
Component state


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.controller = _UserService.LocalPlayer.PlayerControllerComponent
	self.state = _UserService.LocalPlayer.StateComponent
	
	self.controller:RemoveActionKey(KeyboardKey.W)
	self.controller:RemoveActionKey(KeyboardKey.A)
	self.controller:RemoveActionKey(KeyboardKey.S)
	self.controller:RemoveActionKey(KeyboardKey.D)
	self.controller:RemoveActionKey(KeyboardKey.C)
	self.controller:RemoveActionKey(KeyboardKey.Space)
	
	self.state:AddState("SKILL", Skill)
	self.state:AddCondition("SKILL", "IDLE")
}


--Events--

