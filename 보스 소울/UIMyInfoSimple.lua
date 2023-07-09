--Properties--

Component myName
Component myHP


--Methods--

[Client Only]
void OnBeginPlay()
{
	local currentPath = self.Entity.Path
	self.myName = _EntityService:GetEntityByPath(currentPath .. "/Text_name").TextComponent
	self.myHP = _EntityService:GetEntityByPath(currentPath .. "/HP_bar").SliderComponent
}

[Client Only]
void OnUpdate(number delta)
{
	if _UserService.LocalPlayer == nil then
		return
	end
	local player = _UserService.LocalPlayer.PlayerComponent
	if player == nil then
		return
	end
	self.myName.Text = player.Nickname
	self.myHP.Value = player.Hp / player.MaxHp
}


--Events--

