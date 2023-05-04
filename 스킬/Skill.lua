--Properties--



--Methods--

[Default]
void OnEnter()
{
	_UserService.LocalPlayer.PlayerControllerComponent.Enable = false
}

[Default]
void OnExit()
{
	_UserService.LocalPlayer.PlayerControllerComponent.Enable = true
	--_UserService.LocalPlayer.StateComponent:ChangeState("IDLE")
}


--Events--

