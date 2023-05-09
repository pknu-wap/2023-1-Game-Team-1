--Properties--

Component hpBar
Component mpBar
number maxWidth = 0
Component hpText
Component mpText


--Methods--

[Client Only]
void OnBeginPlay()
{
	local currentPath = self.Entity.Path
	
	local nameText = _EntityService:GetEntityByPath(currentPath .. "/info_top/text_name")
	nameText.TextComponent.Text = _UserService.LocalPlayer.PlayerComponent.Nickname
	self.hpText = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Hp/text_value").TextComponent
	self.mpText = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Mp/text_value").TextComponent
	
	self.hpBar = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Hp/img_bar").UITransformComponent
	self.mpBar = _EntityService:GetEntityByPath(currentPath .. "/info_bottom/Mp/img_bar").UITransformComponent
	self.maxWidth = self.hpBar.RectSize.x
}

[Client Only]
void OnUpdate(number delta)
{
	if self.hpBar ~= nil then
		local hp = _UserService.LocalPlayer.PlayerComponent.Hp
		local maxhp = _UserService.LocalPlayer.PlayerComponent.MaxHp
		self.hpBar.RectSize = Vector2(hp / maxhp * self.maxWidth,self.hpBar.RectSize.y)
		self.hpText.Text = string.format("%d / %d", hp,maxhp)
	end
	
	if self.mpBar ~= nil then
		local mp = _UserService.LocalPlayer.PlayerComponent.Mp
		local maxmp = _UserService.LocalPlayer.PlayerComponent.MaxMp
		self.mpBar.RectSize = Vector2(mp / maxmp * self.maxWidth,self.mpBar.RectSize.y)
		self.mpText.Text = string.format("%d / %d", mp,maxmp)
	end
}


--Events--

