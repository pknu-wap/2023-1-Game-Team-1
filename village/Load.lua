--Properties--

Entity load


--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 플레이어 비활성화
	
	local scale = _UserService.LocalPlayer.TransformComponent.Scale
	scale.x = 0
	scale.y = 0
	
	-- 로딩 표시
	
	self.load.Enable = true
}

[Client Only]
void OnMapLeave(Entity leftMap)
{
	self.load.Enable = false
}


--Events--

