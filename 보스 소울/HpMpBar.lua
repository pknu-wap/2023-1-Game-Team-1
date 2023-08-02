--Properties--

Component playerComponent
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
	self.playerComponent = _UserService.LocalPlayer.ExtendPlayerComponent
	
	self.hpText = _EntityService:GetEntityByPath(currentPath .. "/HP/Num").TextComponent
	self.mpText = _EntityService:GetEntityByPath(currentPath .. "/MP/Num").TextComponent
	
	self.hpBar = _EntityService:GetEntityByPath(currentPath .. "/HP/Fill").UITransformComponent
	self.mpBar = _EntityService:GetEntityByPath(currentPath .. "/MP/Fill").UITransformComponent
	self.maxWidth = self.hpBar.RectSize.x
}

[Client Only]
void OnUpdate(number delta)
{
	if self.hpBar ~= nil then
		local hp = self.playerComponent.Hp
		local maxhp = self.playerComponent.MaxHp
		self.hpBar.RectSize = Vector2(hp / maxhp * self.maxWidth,self.hpBar.RectSize.y)
		self.hpText.Text = string.format("%d / %d", hp,maxhp)
	end
	
	if self.mpBar ~= nil then
		local mp = self.playerComponent.Mp
		local maxmp = self.playerComponent.MaxMp
		self.mpBar.RectSize = Vector2(mp / maxmp * self.maxWidth,self.mpBar.RectSize.y)
		self.mpText.Text = string.format("%d / %d", mp,maxmp)
	end
}


--Events--

